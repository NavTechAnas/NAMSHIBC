codeunit 50002 "Sales Invoice Subscription"
{
    TableNo = "Job Queue Entry";

    trigger OnRun();
    begin
        CASE rec."Parameter String" OF
            'Create Subscription Sales Invoice':
                CreateSalesInvoice;

            'Post Subscription Sales Invoice':
                PostSalesInvoice;
        END;
    end;

    procedure CreateSalesInvoice();
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ItemRec: Record Item;
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Subscription Customer No.");

        GLSetup.Get();
        GLSetup.TestField("VAT Bus. Posting Group");
        GLSetup.TestField("No VAT Bus. Posting Group");

        SalesInvoiceSubscription.RESET;
        SalesInvoiceSubscription.SETRANGE(sales_invoice_created, FALSE);
        IF SalesInvoiceSubscription.FINDSET(TRUE, FALSE) THEN
            REPEAT
                IF NOT ItemRec.GET(SalesInvoiceSubscription.subscription_type) THEN
                    CreateItem(SalesInvoiceSubscription);
                CreateSalesHeader(SalesInvoiceSubscription);
                CreateSalesLine(SalesInvoiceSubscription, SalesHeader);
                SalesInvoiceSubscription.sales_invoice_created := TRUE;
                SalesInvoiceSubscription.MODIFY;
            UNTIL SalesInvoiceSubscription.NEXT = 0;
    end;


    local procedure CreateSalesHeader(SalesInvSubsc: Record "Subscription Sales Invoice FTP");
    var
        NewSalesHeader: Record "Sales Header";
    begin
        NewSalesHeader.INIT;
        NewSalesHeader."Document Type" := NewSalesHeader."Document Type"::Invoice;
        NewSalesHeader."No." := SalesInvSubsc.invoice_id;
        NewSalesHeader.VALIDATE("Sell-to Customer No.", SalesSetup."Subscription Customer No.");
        NewSalesHeader."Posting No." := SalesInvSubsc.invoice_id;
        NewSalesHeader."External Document No." := SalesInvSubsc.order_reference;
        // IF SalesInvSubsc."Location Code" = 'AE' THEN
        //     NewSalesHeader.VALIDATE("Location Code", 'DXB')
        // ELSE
        //     NewSalesHeader.VALIDATE("Location Code", 'KSA');
        //NewSalesHeader.VALIDATE("Gen. Bus. Posting Group", 'AR-SUBCPTN');
        // IF SalesInvSubsc.SubscriptionDate < 201201D THEN
        //     NewSalesHeader.VALIDATE("Posting Date", TODAY)
        // ELSE
        //     NewSalesHeader.VALIDATE("Posting Date", SalesInvSubsc.SubscriptionDate);
        NewSalesHeader.VALIDATE("Posting Date", SalesInvSubsc.subscription_date);
        NewSalesHeader.VALIDATE("Document Date", SalesInvSubsc.subscription_date);
        NewSalesHeader.VALIDATE("Order Date", SalesInvSubsc.subscription_date);
        //NewSalesHeader.VALIDATE("Currency Code",SalesInvSubsc.CurrencyCode);
        IF SalesInvSubsc.subscription_vat_amount <> 0 THEN BEGIN
            NewSalesHeader."VAT Bus. Posting Group" := GLSetup."VAT Bus. Posting Group";
            NewSalesHeader.VALIDATE("Prices Including VAT", TRUE);
        END ELSE
            NewSalesHeader."VAT Bus. Posting Group" := GLSetup."No VAT Bus. Posting Group";

        NewSalesHeader.INSERT;
    end;

    local procedure CreateSalesLine(SalesInvSubsc: Record "Subscription Sales Invoice FTP"; SalesHeader1: record "Sales Header");
    var
        NewSalesLine: Record "Sales Line";
        ItemRec: Record Item;
    begin
        NewSalesLine.INIT;
        NewSalesLine."Document Type" := SalesHeader1."Document Type";
        NewSalesLine."Document No." := SalesHeader1."No.";
        NewSalesLine."Line No." := 10000;
        NewSalesLine.Type := NewSalesLine.Type::Item;
        NewSalesLine.VALIDATE("No.", SalesInvSubsc.subscription_type);
        NewSalesLine.VALIDATE(Quantity, 1);
        // IF SalesInvSubsc."Location Code" = 'AE' THEN
        //     NewSalesLine.VALIDATE("Location Code", 'DXB')
        // ELSE
        //     NewSalesLine.VALIDATE("Location Code", 'KSA');
        NewSalesLine.VALIDATE("Unit Price", SalesInvSubsc.subscription_value);
        NewSalesLine.VALIDATE("Line Discount Amount", SalesInvSubsc.subscription_discount_amount);
        IF SalesInvSubsc.subscription_vat_amount <> 0 THEN BEGIN
            NewSalesLine.VALIDATE("VAT Prod. Posting Group", GLSetup."VAT Prod. Posting Group");
            NewSalesLine.VALIDATE("VAT Bus. Posting Group", GLSetup."VAT Bus. Posting Group");
        END ELSE BEGIN
            NewSalesLine.VALIDATE("VAT Prod. Posting Group", GLSetup."No VAT Prod. Posting Group");
            NewSalesLine.VALIDATE("VAT Bus. Posting Group", GLSetup."No VAT Bus. Posting Group");
        END;
        //NewSalesLine.VALIDATE("Gen. Bus. Posting Group", 'AR-SUBCPTN');
        //NewSalesLine.VALIDATE("Currency Code",SalesInvSubsc.CurrencyCode);
        NewSalesLine.INSERT;
    end;

    procedure CreateItem(SalesInvSubsc: Record "Subscription Sales Invoice FTP");
    var
        NewItem: Record Item;
    begin
        NewItem.INIT;
        NewItem."No." := SalesInvSubsc.subscription_type;
        NewItem.Description := 'Subscription Item - ' + SalesInvSubsc.subscription_type;
        NewItem."Inventory Value Zero" := TRUE;
        NewItem."Gen. Prod. Posting Group" := 'SUBSCPTN';
        NewItem."Inventory Posting Group" := 'SUBSCPTN';
        NewItem."Base Unit of Measure" := 'PCS';
        NewItem."Prevent Negative Inventory" := NewItem."Prevent Negative Inventory"::No;
        NewItem.INSERT;
    end;

    procedure PostSalesInvoice();
    var
        SalesHeaderRec: Record "Sales Header";
        SalesReleaseDoc: Codeunit "Release Sales Document";
        SalesLineRec: Record "Sales Line";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Subscription Customer No.");

        SalesHeaderRec.RESET;
        SalesHeaderRec.SETCURRENTKEY("Document Type", "Sell-to Customer No.");
        SalesHeaderRec.SETRANGE("Document Type", SalesHeaderRec."Document Type"::Invoice);
        SalesHeaderRec.SETRANGE("Sell-to Customer No.", SalesSetup."Subscription Customer No.");
        IF SalesHeaderRec.FINDSET(TRUE, FALSE) THEN
            REPEAT
                CLEAR(SalesPost);
                SalesPost.RUN(SalesHeaderRec);
            UNTIL SalesHeaderRec.NEXT = 0;
    end;

    var
        SalesInvoiceSubscription: Record "Subscription Sales Invoice FTP";
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
}

