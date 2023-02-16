report 50005 "Process Sales Return Orders"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'Process Sales Return JOB';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Return Status FTP"; "Sales Return Status FTP")
        {
            DataItemTableView = SORTING(web_order_id, order_item_id)
                                ORDER(Ascending)
                                WHERE(sales_return_order_created = FILTER(false)
                                    , qc_status = FILTER(<> NotReceived));

            RequestFilterFields = web_order_id;

            dataitem("Sales Return FTP"; "Sales Return FTP")
            {
                DataItemTableView = SORTING(web_order_id, order_item_id)
                                ORDER(Ascending);

                DataItemLink = web_order_id = FIELD(web_order_id), order_item_id = FIELD(order_item_id);

                trigger OnAfterGetRecord();
                begin
                    if (PrevOrderNo <> '') and (PrevOrderNo <> "Sales Return FTP".return_order_no) then
                        ReleaseSalesReturn(PrevOrderNo);

                    IF NOT SalesHdr1.GET(SalesHdr1."Document Type"::"Credit Memo", "Sales Return FTP".return_order_no) THEN BEGIN
                        //if recLocation.WAREHOUSE_CODE <> "Sales Return FTP".location_code then begin
                        recLocation.Reset();
                        recLocation.SetRange(WAREHOUSE_CODE, "Sales Return FTP".location_code);
                        recLocation.FindFirst();
                        //end;
                        SalesHdr1.RESET;
                        SalesHdr1.INIT;
                        SalesHdr1.VALIDATE("Document Type", SalesHdr1."Document Type"::"Credit Memo");
                        SalesHdr1."No." := "Sales Return FTP".return_order_no;
                        SalesHdr1.Insert(true);

                        UpdateSalesHdr;
                        PrevOrderNo := "Sales Return FTP".return_order_no;

                        CountWebOrder := CountWebOrder + 1;
                        CurrWebOrderNo := "Sales Return FTP".web_order_id;
                        WalletAmount := 0;
                        line_nr := 10;
                    END;
                    SalesLine1.INIT;
                    SalesLine1.VALIDATE("Document Type", SalesHdr1."Document Type");
                    SalesLine1.VALIDATE("Document No.", SalesHdr1."No.");
                    SalesLine1.VALIDATE("Line No.", line_nr);
                    UpdateSalesLine;
                    SalesLine1.INSERT(TRUE);
                    line_nr += 10;
                    if "Sales Return FTP".crossborder_amt <> 0 then
                        CreateCrossboarderChargesLine();
                    if "Sales Return FTP".return_fee_amt <> 0 then
                        CreateReturnFeesLine();
                    WalletAmount += "Sales Return FTP".amount;
                end;
            }

            trigger OnPreDataItem()
            begin
                Win.OPEN(Text50000);
                CountWebOrder := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                IF (CurrWebOrderNo <> "Sales Return Status FTP".web_order_id) AND (CountWebOrder > SalesSetup."Sales Inv. Creation Threshold") THEN
                    CurrReport.Break();

                Win.UPDATE(1, "Sales Return Status FTP".web_order_id);
                sales_return_order_created := true;
                Modify();
            end;

            trigger OnPostDataItem()
            begin
                if PrevOrderNo <> '' then
                    ReleaseSalesReturn(PrevOrderNo);
                Win.CLOSE;
                MESSAGE('Total %1 Web Order Generated', CountWebOrder);
            end;
        }
    }

    trigger OnPreReport()
    begin
        SalesSetup.GET;
        SalesSetup.TestField("Crossborder Charges Account");
        SalesSetup.TestField("Return Fee A/C");

        GLSetup.get();
        GLSetup.TestField("VAT Bus. Posting Group");
        GLSetup.TestField("VAT Prod. Posting Group");
        GLSetup.TestField("No VAT Bus. Posting Group");
        GLSetup.TestField("No VAT Prod. Posting Group");
    end;

    procedure UpdateSalesHdr();
    var
        SalesOrderFTP: Record "Sales Order FTP";
        SalesStatusFTP: Record "Sales Status FTP";
    begin
        SalesStatusFTP.Reset();
        SalesStatusFTP.SetRange(order_no, "Sales Return FTP".web_order_id);
        SalesStatusFTP.FindFirst();

        SalesOrderFTP.Reset();
        SalesOrderFTP.SetRange(order_no, "Sales Return FTP".web_order_id);
        SalesOrderFTP.FindFirst();

        PaymentMethod := GetCarrierCustomerCode(SalesOrderFTP.payment_terms_code, SalesStatusFTP.carrier);
        SalesHdr1.VALIDATE("Posting Date", DT2Date("Sales Return Status FTP".received_date));
        SalesHdr1."Document Date" := dt2date("Sales Return FTP".return_order_date);
        SalesHdr1.VALIDATE("Sell-to Customer No.", PaymentMethod."Customer No.");
        SalesHdr1."External Document No." := "Sales Return FTP".web_order_id;
        SalesHdr1.VALIDATE("Currency Code", "Sales Return FTP".currency);
        IF "Sales Return FTP".vat_amount <> 0 THEN
            SalesHdr1.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group")
        ELSE
            SalesHdr1.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");

        IF "Sales Return FTP".vat_amount <> 0 THEN
            SalesHdr1.VALIDATE("Prices Including VAT", TRUE);
        SalesHdr1.awb_no := "Sales Return Status FTP".RAWB;
        SalesHdr1.sales_return_type := "Sales Return FTP".sales_return_type;

        IF "Sales Return FTP".vat_amount <> 0 THEN BEGIN
            SalesHdr1.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group");
            SalesHdr1.VALIDATE("Prices Including VAT", TRUE);
        END;
        SalesHdr1."Order Date" := dt2date("Sales Return FTP".return_order_date);
        SalesHdr1.VALIDATE("Location Code", recLocation.Code);
        SalesHdr1.MODIFY();
    end;

    procedure UpdateSalesLine();
    begin
        SalesLine1.VALIDATE(Type, SalesLine1.Type::Item);
        SalesLine1.VALIDATE("No.", "Sales Return FTP".bidc);
        ItemRec.GET("Sales Return FTP".bidc);
        SalesLine1.VALIDATE(Quantity, "Sales Return FTP".Quantity);

        IF "Sales Return FTP".crossborder_amt <> 0 THEN
            SalesLine1.VALIDATE("Unit Price", ("Sales Return FTP".amount - "Sales Return FTP".crossborder_amt))
        ELSE
            SalesLine1.VALIDATE("Unit Price", "Sales Return FTP".amount);

        SalesLine1.VALIDATE("BOB Order Item ID", "Sales Return FTP".ORDER_ITEM_ID);
        IF "Sales Return FTP".vat_amount <> 0 THEN
            SalesLine1.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group");

        SalesLine1.VALIDATE("VAT Prod. Posting Group", GLSetup."VAT Prod. Posting Group");
        SalesLine1."Web Order ID" := "Sales Return FTP".web_order_id;
        SalesLine1.Validate("Gen. Prod. Posting Group", ItemRec."Return Prod. Posting Group");

        IF "Sales Return FTP".crossborder_amt <> 0 THEN BEGIN
            SalesLine1.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");
            SalesHeaderRec.RESET;
            IF SalesHeaderRec.GET(SalesLine1."Document Type", SalesLine1."Document No.") THEN BEGIN
                SalesHeaderRec.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");
                SalesHeaderRec.MODIFY;
            END;
        END;
    end;

    local procedure GetCarrierCustomerCode(PaymentTermsCode: code[20]; Carrier: code[20]): Record "Payment Method"
    var
        PaymentMethod: Record "Payment Method";
    begin
        PaymentMethod.Reset();
        if PaymentTermsCode = 'POSTPAY' then
            PaymentMethod.SetRange("Payment Gateway", Carrier)
        else
            PaymentMethod.SetRange("Payment Gateway", PaymentTermsCode);
        if NOT PaymentMethod.FindFirst() then
            ERROR('Carrier does not exist %1', PaymentTermsCode);
        exit(PaymentMethod);
    end;

    local procedure CreateCrossboarderChargesLine()
    var
        SalesLineRec: Record "Sales Line";
    begin
        SalesLineRec.RESET;
        SalesLineRec.SETRANGE("Document Type", SalesHdr1."Document Type");
        SalesLineRec.SETRANGE("Document No.", SalesHdr1."No.");
        SalesLineRec.SETRANGE(Type, SalesLineRec.Type::"G/L Account");
        SalesLineRec.SETRANGE("No.", SalesSetup."Crossborder Charges Account");
        IF NOT SalesLineRec.FINDFIRST THEN BEGIN
            SalesLineRec.INIT;
            SalesLineRec."Document Type" := SalesHdr1."Document Type";
            SalesLineRec."Document No." := SalesHdr1."No.";
            SalesLineRec."Line No." := line_nr;
            SalesLineRec.Type := SalesLineRec.Type::"G/L Account";
            SalesLineRec.VALIDATE("No.", SalesSetup."Crossborder Charges Account");
            SalesLineRec.VALIDATE(Quantity, 1);
            SalesLineRec.VALIDATE("Unit Price", "Sales Return FTP".crossborder_amt);
            SalesLineRec.VALIDATE("Gen. Prod. Posting Group", SalesLine1."Gen. Prod. Posting Group");
            SalesLineRec.Insert();
            line_nr += 10;
        END ELSE BEGIN
            SalesLineRec.VALIDATE("Unit Price", SalesLineRec."Unit Price" + "Sales Return FTP".crossborder_amt);
            SalesLineRec.Modify();
        END;
    end;

    local procedure CreateReturnFeesLine()
    var
        SalesLineRec: Record "Sales Line";
    begin
        SalesLineRec.RESET;
        SalesLineRec.SETRANGE("Document Type", SalesHdr1."Document Type");
        SalesLineRec.SETRANGE("Document No.", SalesHdr1."No.");
        SalesLineRec.SETRANGE(Type, SalesLineRec.Type::"G/L Account");
        SalesLineRec.SETRANGE("No.", SalesSetup."Return Fee A/C");
        IF NOT SalesLineRec.FINDFIRST THEN BEGIN
            SalesLineRec.INIT;
            SalesLineRec."Document Type" := SalesHdr1."Document Type";
            SalesLineRec."Document No." := SalesHdr1."No.";
            SalesLineRec."Line No." := line_nr;
            SalesLineRec.Type := SalesLineRec.Type::"G/L Account";
            SalesLineRec.VALIDATE("No.", SalesSetup."Return Fee A/C");
            SalesLineRec.VALIDATE(Quantity, 1);
            SalesLineRec.VALIDATE("Unit Price", "Sales Return FTP".return_fee_amt);
            SalesLineRec.VALIDATE("Gen. Prod. Posting Group", SalesLine1."Gen. Prod. Posting Group");
            SalesLineRec.Insert();
            line_nr += 10;
        END ELSE BEGIN
            SalesLineRec.VALIDATE("Unit Price", SalesLineRec."Unit Price" + "Sales Return FTP".return_fee_amt);
            SalesLineRec.Modify();
        END;
    end;

    local procedure ReleaseSalesReturn(OrderNo: code[20])
    var
        ReleaseSalesOrder: Codeunit "Release Sales Document";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", OrderNo);
        SalesHeader."Wallet Amount" := WalletAmount;
        SalesHeader."Wallet Exist" := (WalletAmount <> 0);
        SalesHeader.Modify();
        if SalesHeader.Status <> SalesHeader.Status::Released then
            ReleaseSalesOrder.PerformManualRelease(SalesHeader);
    end;

    var
        SalesHdr1: Record "Sales Header";
        SalesLine1: Record "Sales Line";
        Customer: Record Customer;
        Win: Dialog;
        SalesSetup: Record "Sales & Receivables Setup";
        ItemRec: Record Item;
        CountWebOrder: Integer;
        Text50000: Label 'Processing Sales Return Order #1##########';
        SalesHeaderRec: Record "Sales Header";
        PrevOrderNo: Code[20];
        CurrWebOrderNo: Code[20];
        line_nr: Integer;
        PaymentMethod: Record "Payment Method";
        WalletAmount: Decimal;
        GLSetup: Record "General Ledger Setup";
        recLocation: Record Location;
}
