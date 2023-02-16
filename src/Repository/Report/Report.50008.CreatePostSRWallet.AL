report 50008 "Create Post SR Wallet JOB"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'Create Post SR Wallet JOB';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("Wallet Exist", "Wallet Created")
                                where("Wallet Exist" = filter(true),
                                        "Wallet Created" = filter(false));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                SalesCrMemoHdr1: Record "Sales Cr.Memo Header";
            begin
                if Counter > SalesSetup."Wallet Posting Threshold" then
                    CurrReport.Break();
                if "Sales Cr.Memo Header"."Wallet Amount" > 0 then
                    CreateAndPostWalletJournal("Sales Cr.Memo Header");
                SalesCrMemoHdr1.get("Sales Cr.Memo Header"."No.");
                SalesCrMemoHdr1."Wallet Created" := true;
                SalesCrMemoHdr1.Modify();
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

    local procedure CreateAndPostWalletJournal(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
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

        GenJnlLine.VALIDATE("External Document No.", SalesCrMemoHeader."External Document No.");
        GenJnlLine.VALIDATE("Document No.", SalesCrMemoHeader."External Document No.");
        GenJnlLine.VALIDATE("Posting Date", SalesCrMemoHeader."Posting Date");
        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", SalesCrMemoHeader."Bill-to Customer No.");
        //GenJnlLine."Posting Group" := 'AR-SALES';

        GenJnlLine.Validate("Currency Code", SalesCrMemoHeader."Currency Code");
        GenJnlLine.VALIDATE(Amount, SalesCrMemoHeader."Wallet Amount");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", SalesSetup."Wallet Sales A/c");

        GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
        GenJnlLine.Validate("Applies-to Doc. No.", SalesCrMemoHeader."No.");

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
}