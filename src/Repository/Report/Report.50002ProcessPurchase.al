report 50002 "Process Purchase Order FTP"
{
    Caption = 'Process Purchase JOB';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Order FTP"; "Purchase Order FTP")
        {
            DataItemTableView = SORTING(document_nr, line_nr)
                                ORDER(Ascending)
                                WHERE(order_updated = FILTER(false));

            RequestFilterFields = document_nr;

            trigger OnPreDataItem()
            begin
                recCount := 1;
            end;

            trigger OnAfterGetRecord();
            begin
                IF "Purchase Order FTP".ISEMPTY THEN
                    CurrReport.Break();
                IF recCount > PurchSetup."Purch. Inv. Creation Threshold" THEN
                    currreport.Break();

                IF "Purchase Order FTP".qty < 0 THEN
                    ERROR('Negative Qty Not Allowed');

                TestField(putaway_nr);
                Vendor.GET(vendor_code);
                Vendor.TestField(Blocked, Vendor.Blocked::" ");

                if (OldDocumentNr <> '') and (OldDocumentNr <> document_nr) then
                    ReleasePI(OldDocumentNr);

                IF (document_nr <> OldDocumentNr) THEN BEGIN
                    CreatePurchHeader();
                    LineNo := 10;
                    OldDocumentNr := document_nr;
                end;
                CreatePurchLines();

                PurchaseOrderFTP.get("Purchase Order FTP".document_nr, "Purchase Order FTP".line_nr);
                PurchaseOrderFTP.order_updated := TRUE;
                PurchaseOrderFTP.Modify();
            end;
        }
    }

    trigger OnPreReport()
    begin
        GLSetup.Get();
        PurchSetup.Get();
    end;

    trigger OnPostReport()
    begin
        if (OldDocumentNr <> '') then
            ReleasePI(OldDocumentNr);
    end;

    local procedure CreatePurchHeader();
    begin
        //if recLocation.WAREHOUSE_CODE <> "Purchase Order FTP".location then begin
        recLocation.Reset();
        recLocation.SetRange(WAREHOUSE_CODE, "Purchase Order FTP".location);
        recLocation.FindFirst();
        //end;
        PurchHeader.INIT;
        PurchHeader.VALIDATE("Document Type", PurchHeader."Document Type"::Invoice);
        PurchHeader.VALIDATE("No.", "Purchase Order FTP".document_nr);
        PurchHeader.VALIDATE("Order Date", DT2DATE("Purchase Order FTP".posted_at));
        PurchHeader.VALIDATE("Document Date", DT2DATE("Purchase Order FTP".posted_at));
        PurchHeader.VALIDATE("Posting Date", DT2DATE("Purchase Order FTP".posted_at));
        PurchHeader.VALIDATE("Buy-from Vendor No.", "Purchase Order FTP".vendor_code);
        PurchHeader.VALIDATE("Currency Code", "Purchase Order FTP".currency);
        PurchHeader.VALIDATE("Invoice Disc. Code", "Purchase Order FTP".vendor_code);
        PurchHeader.VALIDATE("Payment Terms Code", "Purchase Order FTP".payment_terms);
        PurchHeader.VALIDATE("Vendor Invoice No.", COPYSTR("Purchase Order FTP".vendor_invoice_nr, 1, 35));
        PurchHeader.qc_status := "Purchase Order FTP".qc_status;
        PurchHeader."Vendor Order No." := "Purchase Order FTP".document_nr;
        PurchHeader.PO_ShipmentNr := "Purchase Order FTP".po_shipment_nr;
        PurchHeader."Posting No." := "Purchase Order FTP".putaway_nr;
        PurchHeader.INSERT(TRUE);
        PurchHeader."Location Code" := recLocation.Code;
        PurchHeader."Posting No. Series" := '';
        PurchHeader.Modify();
        recCount += 1;
    end;


    local procedure CreatePurchLines()
    var
        bidcAvgUnitCost: Decimal;
        bidcTotQty: Decimal;
    begin
        FindOrCreateItem();
        PurchLine.RESET;
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("No.", "Purchase Order FTP".bidc);
        if PurchLine.FindFirst() then begin
            bidcTotQty := PurchLine.Quantity + "Purchase Order FTP".qty;
            bidcAvgUnitCost := ((PurchLine."Direct Unit Cost" * PurchLine.Quantity) +
                       ("Purchase Order FTP".unit_cost * "Purchase Order FTP".qty)) / bidcTotQty;

            PurchLine.VALIDATE(Quantity, bidcTotQty);
            PurchLine.VALIDATE("Direct Unit Cost", bidcAvgUnitCost);
            IF "Purchase Order FTP".unit_cost <> 0 THEN
                PurchLine.VALIDATE("Indirect Cost %");
            PurchLine.Modify();
        end else begin
            PurchLine.Reset();
            PurchLine.INIT;
            PurchLine.VALIDATE("Document Type", PurchHeader."Document Type");
            PurchLine.VALIDATE("Document No.", PurchHeader."No.");
            PurchLine.VALIDATE("Line No.", LineNo);
            PurchLine.VALIDATE(Type, PurchLine.Type::Item);
            PurchLine.VALIDATE("No.", "Purchase Order FTP".bidc);
            PurchLine.VALIDATE("Buy-from Vendor No.", "Purchase Order FTP".vendor_code);
            PurchLine.VALIDATE(Quantity, "Purchase Order FTP".qty);
            PurchLine.VALIDATE("Direct Unit Cost", "Purchase Order FTP".unit_cost);
            IF "Purchase Order FTP".unit_cost <> 0 THEN
                PurchLine.VALIDATE("Indirect Cost %", ROUND(("Purchase Order FTP".freight_cost / "Purchase Order FTP".unit_cost) * 100, 0.0001));
            PurchLine."Location Code" := PurchHeader."Location Code";
            PurchLine.buying_po_nr := "Purchase Order FTP".buying_po_nr;
            PurchLine.po_shipment_nr := "Purchase Order FTP".po_shipment_nr;
            PurchLine.qc_status := "Purchase Order FTP".qc_status;
            PurchLine.putaway_nr := "Purchase Order FTP".putaway_nr;
            PurchLine.document_nr := "Purchase Order FTP".document_nr;
            PurchLine.INSERT(TRUE);
            LineNo += 10;
        end;
    end;

    local procedure FindOrCreateItem()
    var
        ItemVendor: Record "Item Vendor";
    begin
        if recItem.get("Purchase Order FTP".bidc) then begin
            ItemModified := FALSE;
            IF recItem."Inventory Posting Group" = '' THEN BEGIN
                recItem."Inventory Posting Group" := 'OUTRIGHT';
                ItemModified := TRUE;
            END;
            IF recItem."Gen. Prod. Posting Group" = '' THEN BEGIN
                recItem."Gen. Prod. Posting Group" := 'OUTRIGHT';
                ItemModified := TRUE;
            END;
            IF ItemModified THEN
                recItem.MODIFY;
            exit;
        end;

        recItem.INIT;
        recItem."No." := "Purchase Order FTP".bidc;
        recItem."Base Unit of Measure" := 'PCS';
        recItem."Sales Unit of Measure" := 'PCS';
        recItem."Purch. Unit of Measure" := 'PCS';

        IF "Purchase Order FTP".inventory_posting_group <> '' THEN
            recItem.validate("Inventory Posting Group", "Purchase Order FTP".inventory_posting_group)
        ELSE
            recItem.validate("Inventory Posting Group", 'OUTRIGHT');
        IF "Purchase Order FTP".product_posting_group <> '' THEN
            recItem.validate("Gen. Prod. Posting Group", "Purchase Order FTP".product_posting_group)
        ELSE
            recItem.validate("Gen. Prod. Posting Group", 'OUTRIGHT');
        recItem.Validate("Return Prod. Posting Group", 'R' + recItem."Gen. Prod. Posting Group");
        recItem."Item Category Code" := "Purchase Order FTP".item_category_code;

        recItem."Costing Method" := recItem."Costing Method"::Average;
        recItem.Description := COPYSTR(DELCHR("Purchase Order FTP".description, '=', '!|@|#|$|%|&|"'), 1, 49);
        recItem."HS Code" := "Purchase Order FTP".hs_code;
        recItem."Country of Origin" := "Purchase Order FTP".country_of_origin;
        recItem.Category := "Purchase Order FTP".category;
        recItem."Sub Category" := "Purchase Order FTP".sub_category;
        recItem."Retail Price" := "Purchase Order FTP".retail_price;
        recItem."Supplier SKU" := "Purchase Order FTP".supplier_sku;

        IF COPYSTR("Purchase Order FTP".buying_po_nr, 1, 2) <> 'ND' THEN BEGIN
            IF "Purchase Order FTP".currency <> '' THEN
                recItem."Unit Cost" := CurrExchangeRate.ExchangeAmount("Purchase Order FTP".unit_cost, "Purchase Order FTP".currency,
                                                  GLSetup."LCY Code", DT2DATE("Purchase Order FTP".posted_at))
            ELSE
                recItem."Unit Cost" := "Purchase Order FTP".unit_cost;
        END;

        IF ("Purchase Order FTP".hs_code <> '') AND (NOT HSCodes.GET("Purchase Order FTP".hs_code)) THEN BEGIN
            HSCodes.INIT;
            HSCodes."HS Code" := "Purchase Order FTP".hs_code;
            HSCodes.Description := "Purchase Order FTP".hs_code;
            HSCodes.INSERT;
        END;
        recItem.INSERT;

        ItemUnitOfMeasure.RESET;
        IF NOT ItemUnitOfMeasure.GET(recItem."No.", 'PCS') THEN BEGIN
            ItemUnitOfMeasure.INIT;
            ItemUnitOfMeasure."Item No." := recItem."No.";
            ItemUnitOfMeasure.Code := 'PCS';
            ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
            ItemUnitOfMeasure.INSERT;
        END;

        if not ItemVendor.get("Purchase Order FTP".vendor_code, PurchaseOrderFTP.bidc, '') then begin
            ItemVendor.Init();
            ItemVendor."Item No." := PurchaseOrderFTP.bids;
            ItemVendor."Vendor No." := "Purchase Order FTP".vendor_code;
            ItemVendor."Vendor Item No." := "Purchase Order FTP".supplier_sku;
            ItemVendor.Insert();
        end;
    end;

    local procedure ReleasePI(OrderNo: code[20])
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.get(PurchHeader."Document Type"::Invoice, OrderNo);
        if PurchHeader.Status <> PurchHeader.Status::Released then
            ReleaseDoc.PerformManualRelease(PurchHeader);
    end;

    var
        PurchHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        recItem: Record Item;
        PurchLine: Record "Purchase Line";
        recPurchHdr1: Record "Purchase Header";
        LineNo: Integer;
        recCount: Integer;
        LocationCodeFilter: Code[30];
        recLocation: Record Location;
        WarehouseActiviated: Boolean;
        FirstLineRecord: Boolean;
        ReleaseDoc: Codeunit "Release Purchase Document";
        IsPostWhseReceipt: Boolean;
        ItemModified: Boolean;
        CurrExchangeRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        TmpPurchLine: Record "Purchase Line" temporary;
        HSCodes: Record "HS Codes";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        OldDocumentNr: Code[20];
        PurchaseOrderFTP: Record "Purchase Order FTP";
}

