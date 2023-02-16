report 50007 "IC Payment Transfer"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'IC Payment Transfer';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code")
                                ORDER(Ascending);

            trigger OnPreDataItem()
            begin
                Counter := 0;
                IF (TransferTo = '') OR (VendorCode = '') THEN
                    ERROR('Transfer To and Vendor Code are mandatory');

                IF TransferTo = Company.CURRENTCOMPANY THEN
                    ERROR('');

                IF "Vendor Ledger Entry".FINDSET THEN;
            end;

            trigger OnAfterGetRecord()
            begin
                TESTFIELD("Document Type", "Vendor Ledger Entry"."Document Type"::Invoice);
                CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                IF "Remaining Amount" > 0 THEN
                    ERROR(STRSUBSTNO('Document type must be INVOICE with Debit Amount'));

                IF ("Remaining Amount" = 0) OR ("Remaining Amt. (LCY)" = 0) THEN
                    CurrReport.SKIP;

                Counter += 1;
                IntercompanyPosting.CreateAndPostVendJnl("Vendor Ledger Entry", GLSetup, TransferTo, VendorCode);
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE('%1 Invoices transferred to %2', Counter, TransferTo);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(TransferTo; TransferTo)
                    {
                        ApplicationArea = All;
                        Caption = 'Transfer To';
                        ToolTip = 'Specifies the company where you want to transfer this entry for payment.';
                        TableRelation = Company.Name;

                        trigger OnValidate()
                        begin
                            GLSetup2.Reset();
                            GLSetup2.ChangeCompany(Company.Name);
                            GLSetup2.get();
                            GLSetup2.testfield("Allow IC inbound transfer");
                        end;
                    }
                    field(VendorCode; VendorCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Code';
                        ToolTip = 'Specifies the vendor code in transfree company.';

                        trigger OnValidate()
                        var
                            Vendor: Record Vendor;
                        begin
                            Vendor.RESET;
                            Vendor.CHANGECOMPANY(TransferTo);
                            IF NOT Vendor.GET(VendorCode) THEN
                                ERROR('Vendor %1 not found in %2', VendorCode, TransferTo);
                        end;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Vendor: Record Vendor;
                        begin
                            Vendor.RESET;
                            Vendor.CHANGECOMPANY(TransferTo);
                            IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                                Text := Vendor."No.";
                                EXIT(TRUE);
                            END;
                        end;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        Counter := 0;
        GLSetup.GET;
        GLSetup.TESTFIELD("Def. Pmt. Trf. Template");
        GLSetup.TESTFIELD("Def. Pmt. Trf. Batch");
        GLSetup.TESTFIELD("Def. IC Trf. G/L Account");
        GLSetup.TESTFIELD("Def. IC Vendor Account");
        GLSetup.TESTFIELD("Allow IC outbound transfer");

        Company.RESET;
        Company.SETFILTER(Name, '<>%1', Company.CURRENTCOMPANY);
        IF Company.FINDSET THEN BEGIN
            repeat
                GLSetup2.Reset();
                GLSetup2.ChangeCompany(Company.Name);
                GLSetup2.get();
                if GLSetup2."Allow IC inbound transfer" then begin
                    TransferTo := Company.Name;
                    Counter += 1;
                end;
            until Company.Next() = 0;
            if Counter > 1 then
                TransferTo := '';
        END ELSE
            ERROR('No company is configured for Inbound Transfer.');
    end;


    var
        Company: Record Company;
        GLSetup: Record "General Ledger Setup";
        GLSetup2: Record "General Ledger Setup";
        TransferTo: text[30];
        Counter: Integer;
        VendorCode: code[20];
        IntercompanyPosting: Codeunit "InterCompany Posting";
}

