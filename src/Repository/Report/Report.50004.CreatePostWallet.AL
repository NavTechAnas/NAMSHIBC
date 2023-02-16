report 50004 "Create Post Wallet JOB"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'Create Post Wallet JOB';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("Wallet Exist", "Wallet Created")
                                where("Wallet Exist" = filter(true),
                                        "Wallet Created" = filter(false));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                SalesInvHdr1: Record "Sales Invoice Header";
            begin
                if Counter > SalesSetup."Wallet Posting Threshold" then
                    CurrReport.Break();
                if "Sales Invoice Header"."Wallet Amount" > 0 then
                    CreateAndPostWalletJournal("Sales Invoice Header");
                SalesInvHdr1.get("Sales Invoice Header"."No.");
                SalesInvHdr1."Wallet Created" := true;
                SalesInvHdr1.Modify();
                Counter += 1;
            end;
        }
    }

    trigger OnPreReport()
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Wallet Gen Journal Template");
        LineNo := 10;
    end;

    local procedure CreateAndPostWalletJournal(SalesInvHeader: Record "Sales Invoice Header")
    var
        myInt: Integer;
        JournalTemplateName: code[10];
        JournalBatchName: code[10];
        GenJnlLine: Record "Gen. Journal Line";
    begin
        JournalTemplateName := SalesSetup."Wallet Gen Journal Template";
        JournalBatchName := 'DEFAULT';

        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", JournalTemplateName);
        GenJnlLine.VALIDATE("Journal Batch Name", JournalBatchName);
        GenJnlLine.VALIDATE("Line No.", LineNo);
        //GenJnlLine.INSERT;

        GenJnlLine.VALIDATE("External Document No.", SalesInvHeader."External Document No.");
        GenJnlLine.VALIDATE("Document No.", SalesInvHeader."External Document No.");
        GenJnlLine.VALIDATE("Posting Date", SalesInvHeader."Posting Date");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", SalesInvHeader."Bill-to Customer No.");
        //GenJnlLine."Posting Group" := 'AR-SALES';

        GenJnlLine.Validate("Currency Code", SalesInvHeader."Currency Code");
        GenJnlLine.VALIDATE(Amount, SalesInvHeader."Wallet Amount" * -1);
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", SalesSetup."Wallet Sales A/c");

        GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
        GenJnlLine.Validate("Applies-to Doc. No.", SalesInvHeader."No.");

        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine.Insert();

        CLEAR(GenJnlLinePost);
        GenJnlLinePost.RUN(GenJnlLine);
        LineNo += 10;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        Counter: Integer;
        GenJnlLinePost: Codeunit "Gen. Jnl.-Post";
        LineNo: Integer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
}