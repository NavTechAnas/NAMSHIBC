report 50001 "Process Sales Orders"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'Process Sales JOB';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Status FTP"; "Sales Status FTP")
        {
            DataItemTableView = SORTING(order_no, order_item_id)
                                ORDER(Ascending)
                                WHERE(order_updated = FILTER(false)
                                    , status = FILTER(SHIPPED));

            RequestFilterFields = order_no;

            dataitem("Sales Order FTP"; "Sales Order FTP")
            {
                DataItemTableView = SORTING(order_no, order_item_id)
                                ORDER(Ascending)
                                WHERE(customer_no = FILTER(<> ''));
                DataItemLink = order_no = FIELD(order_no), order_item_id = FIELD(order_item_id);

                trigger OnAfterGetRecord();
                begin
                    IF NOT Customer.GET("Sales Order FTP".customer_no) THEN
                        ERROR(Text50000, "Sales Order FTP".customer_no);

                    if (PrevOrderNo <> '') and (PrevOrderNo <> "Sales Status FTP".web_invoice_no) then
                        ReleaseSI(PrevOrderNo);

                    IF NOT SalesHdr1.GET(SalesHdr1."Document Type"::Invoice, "Sales Status FTP".web_invoice_no) THEN BEGIN
                        //if recLocation.WAREHOUSE_CODE <> "Sales Order FTP".location then begin
                        recLocation.Reset();
                        recLocation.SetRange(WAREHOUSE_CODE, "Sales Order FTP".location);
                        recLocation.FindFirst();
                        //end;
                        SalesHdr1.RESET;
                        SalesHdr1.INIT;
                        SalesHdr1.VALIDATE("Document Type", SalesHdr1."Document Type"::Invoice);
                        SalesHdr1.VALIDATE("No.", "Sales Status FTP".web_invoice_no);

                        UpdateSalesHdr;
                        SalesHdr1."Order Date" := "Sales Order FTP".order_date;
                        SalesHdr1.INSERT();
                        SalesHdr1.VALIDATE("Location Code", recLocation.Code);
                        SalesHdr1.MODIFY();
                        PrevOrderNo := "Sales Status FTP".web_invoice_no;

                        CountWebOrder := CountWebOrder + 1;
                        CurrOrderNo := "Sales Order FTP".order_no;
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
                    if "Sales Order FTP".cross_border_charges <> 0 then
                        CreateCrossboarderChargesLine();
                    if "Sales Status FTP".shipping_amount <> 0 then
                        CreateShippingChargesLine();
                    WalletAmount += "Sales Order FTP".wallet_item_amt;
                end;
            }

            trigger OnPreDataItem()
            begin
                Win.OPEN(Text50000);
                CountWebOrder := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                IF (CurrOrderNo <> "Sales Status FTP".order_no) AND (CountWebOrder > SalesSetup."Sales Inv. Creation Threshold") THEN
                    CurrReport.Break();

                Win.UPDATE(1, "Sales Status FTP".order_no);
                order_updated := true;
                Modify();
            end;

            trigger OnPostDataItem()
            begin
                if PrevOrderNo <> '' then
                    ReleaseSI(PrevOrderNo);
                Win.CLOSE;
                MESSAGE('Total %1 Web Order Generated', CountWebOrder);
            end;
        }
    }

    trigger OnPreReport()
    begin
        SalesSetup.GET;
        SalesSetup.TestField("Crossborder Charges Account");
        SalesSetup.TestField("Shipping Charges Account");

        GLSetup.get();
        GLSetup.TestField("VAT Bus. Posting Group");
        GLSetup.TestField("VAT Prod. Posting Group");
        GLSetup.TestField("No VAT Bus. Posting Group");
        GLSetup.TestField("No VAT Prod. Posting Group");
    end;

    procedure UpdateSalesHdr();
    begin
        PaymentMethod := GetGatwayCustomerCode("Sales Order FTP".payment_terms_code, "Sales Status FTP".carrier);
        SalesHdr1.VALIDATE("Posting Date", "Sales Status FTP".status_date);
        SalesHdr1."Document Date" := "Sales Order FTP".order_date;
        if "Sales Order FTP".payment_terms_code <> 'POSTPAY' then
            SalesHdr1.VALIDATE("Sell-to Customer No.", "Sales Order FTP".payment_terms_code)
        else begin
            SalesHdr1.VALIDATE("Sell-to Customer No.", PaymentMethod."Customer No.");
        end;
        SalesHdr1."External Document No." := "Sales Order FTP".order_no;
        SalesHdr1.VALIDATE("Payment Method Code", PaymentMethod.Code);
        SalesHdr1.VALIDATE("Currency Code", "Sales Order FTP".currency);
        SalesHdr1."Ship-to County" := "Sales Order FTP".ship_to_country;
        SalesHdr1."Ship-to Country/Region Code" := "Sales Order FTP".ship_to_country;

        // SalesHdr1.VALIDATE("Gen. Bus. Posting Group", 'AR-SALES');
        // SalesHdr1."Customer Posting Group" := 'AR-SALES';

        IF "Sales Order FTP".vat_amount <> 0 THEN
            SalesHdr1.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group")
        ELSE
            SalesHdr1.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");

        IF "Sales Order FTP".vat_amount <> 0 THEN
            SalesHdr1.VALIDATE("Prices Including VAT", TRUE);
        SalesHdr1."Your Reference" := "Sales Order FTP".PROMO;
        SalesHdr1.awb_no := "Sales Status FTP".awb_no;

        IF "Sales Order FTP".vat_amount <> 0 THEN BEGIN
            SalesHdr1.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group");
            SalesHdr1.VALIDATE("Prices Including VAT", TRUE);
        END;
    end;

    procedure UpdateSalesLine();
    begin
        SalesLine1.VALIDATE(Type, SalesLine1.Type::Item);
        SalesLine1.VALIDATE("No.", "Sales Order FTP".bidc);
        ItemRec.GET("Sales Order FTP".bidc);
        SalesLine1.VALIDATE(Quantity, "Sales Order FTP".Quantity);

        IF ("Sales Order FTP".cross_border_charges <> 0) AND ("Sales Order FTP".Destination <> '') THEN
            SalesLine1.VALIDATE("Unit Price", (("Sales Order FTP".paid_price + "Sales Order FTP".wallet_item_amt) - "Sales Order FTP".cross_border_charges))
        ELSE
            SalesLine1.VALIDATE("Unit Price", ("Sales Order FTP".paid_price + "Sales Order FTP".wallet_item_amt));

        SalesLine1.VALIDATE("Line Discount Amount", ("Sales Order FTP".discount_amount + "Sales Order FTP".coupon_money));
        SalesLine1.VALIDATE("BOB Order Item ID", "Sales Order FTP".ORDER_ITEM_ID);
        IF "Sales Order FTP".vat_amount <> 0 THEN
            SalesLine1.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group");

        SalesLine1.VALIDATE("VAT Prod. Posting Group", GLSetup."VAT Prod. Posting Group");
        SalesLine1.boxid := "Sales Order FTP".boxid;
        SalesLine1."Web Order ID" := "Sales Order FTP".order_no;

        IF ("Sales Order FTP".cross_border_charges <> 0) AND ("Sales Order FTP".Destination <> '') THEN BEGIN
            SalesLine1.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");
            SalesHeaderRec.RESET;
            IF SalesHeaderRec.GET(SalesHeaderRec."Document Type"::Invoice, SalesLine1."Document No.") THEN BEGIN
                SalesHeaderRec.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");
                SalesHeaderRec.MODIFY;
            END;
        END;
    end;

    local procedure GetGatwayCustomerCode(PaymentTermsCode: Code[20]; Carrier: code[20]): Record "Payment Method"
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
            SalesLineRec.VALIDATE("Unit Price", "Sales Order FTP".cross_border_charges);
            SalesLineRec.VALIDATE("Gen. Prod. Posting Group", SalesLine1."Gen. Prod. Posting Group");
            SalesLineRec.Insert();
            line_nr += 10;
        END ELSE BEGIN
            SalesLineRec.VALIDATE("Unit Price", SalesLineRec."Unit Price" + "Sales Order FTP".cross_border_charges);
            SalesLineRec.Modify();
        END;
    end;

    local procedure CreateShippingChargesLine()
    var
        SalesLineRec: Record "Sales Line";
    begin
        SalesLineRec.RESET;
        SalesLineRec.SETRANGE("Document Type", SalesHdr1."Document Type");
        SalesLineRec.SETRANGE("Document No.", SalesHdr1."No.");
        SalesLineRec.SETRANGE(Type, SalesLineRec.Type::"G/L Account");
        SalesLineRec.SETRANGE("No.", SalesSetup."Shipping Charges Account");
        IF NOT SalesLineRec.FINDFIRST THEN BEGIN
            SalesLineRec.INIT;
            SalesLineRec."Document Type" := SalesHdr1."Document Type";
            SalesLineRec."Document No." := SalesHdr1."No.";
            SalesLineRec."Line No." := line_nr;
            SalesLineRec.Type := SalesLineRec.Type::"G/L Account";
            SalesLineRec.VALIDATE("No.", SalesSetup."Shipping Charges Account");
            SalesLineRec.VALIDATE(Quantity, 1);
            SalesLineRec.VALIDATE("Unit Price", "Sales Status FTP".shipping_amount + "Sales Status FTP".shipping_vat_amount);
            SalesLineRec.Validate("Gen. Bus. Posting Group", SalesLine1."Gen. Bus. Posting Group");
            SalesLineRec.VALIDATE("Gen. Prod. Posting Group", SalesLine1."Gen. Prod. Posting Group");
            SalesLineRec.Validate("VAT Bus. Posting Group", SalesLine1."VAT Bus. Posting Group");
            if "Sales Status FTP".shipping_vat_amount <> 0 then
                SalesLineRec.Validate("VAT Prod. Posting Group", GLSetup."VAT Prod. Posting Group")
            ELSE
                SalesLineRec.Validate("VAT Prod. Posting Group", GLSetup."No VAT Prod. Posting Group");
            SalesLineRec.Insert();
            line_nr += 10;

            IF "Sales Status FTP".shipping_cross_border_charges <> 0 then begin
                SalesLineRec.INIT;
                SalesLineRec."Document Type" := SalesHdr1."Document Type";
                SalesLineRec."Document No." := SalesHdr1."No.";
                SalesLineRec."Line No." := line_nr;
                SalesLineRec.Type := SalesLineRec.Type::"G/L Account";
                SalesLineRec.VALIDATE("No.", SalesSetup."Crossborder Charges Account");
                SalesLineRec.VALIDATE(Quantity, 1);
                SalesLineRec.VALIDATE("Unit Price", "Sales Status FTP".shipping_cross_border_charges);
                SalesLineRec.Validate("Gen. Bus. Posting Group", SalesLine1."Gen. Bus. Posting Group");
                SalesLineRec.VALIDATE("Gen. Prod. Posting Group", SalesLine1."Gen. Prod. Posting Group");
                SalesLineRec.Validate("VAT Bus. Posting Group", SalesLine1."VAT Bus. Posting Group");
                SalesLineRec.Validate("VAT Prod. Posting Group", GLSetup."No VAT Prod. Posting Group");
                SalesLineRec.Insert();
                line_nr += 10;
            end;
        END;
    end;

    local procedure ReleaseSI(OrderNo: code[20])
    var
        ReleaseSalesOrder: Codeunit "Release Sales Document";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(SalesHeader."Document Type"::Invoice, OrderNo);
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
        Text50000: Label 'Processing Sales Order #1##########';
        CompanyInfo: Record "Company Information";
        SalesHeaderRec2: Record "Sales Header";
        SalesHeaderRec: Record "Sales Header";
        PrevOrderNo: Code[20];
        CurrOrderNo: Code[20];
        line_nr: Integer;
        SalesStatusFTP: Record "Sales Status FTP";
        PaymentMethod: Record "Payment Method";
        WalletAmount: Decimal;
        GLSetup: Record "General Ledger Setup";
        recLocation: Record Location;
}

