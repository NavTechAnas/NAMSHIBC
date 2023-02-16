codeunit 50001 "InterCompany Posting"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        CASE rec."Parameter String" OF
            'Post IC Vendor Transaction':
                PostICVendorTransaction();
            'Create IC SI':
                CreateIntercompanySI();
            'Create IC SI Internal':
                CreateIntercompanySIInternal(Rec);
            'Post IC SI':
                PostIntercompanySI();
            'Post IC SI Internal':
                PostIntercompanySIInternal(Rec);
            'Create IC PI':
                CreateIntercompanyPI();
            'Create IC PI Internal':
                CreateIntercompanyPIInternal(Rec);
        end;
    end;

    procedure CreateAndPostVendJnl(lVendorLedgerEntry: Record "Vendor Ledger Entry"; lGLSetup: Record "General Ledger Setup";
                            TransferToCompany: text[30]; VendorCode: code[20])
    var
        VendorLedgerTransferData: Record "Vendor Ledger Transfer Data";
        GenJnlLine: Record "Gen. Journal Line";
        LineNumber: Integer;
        ICVendLedgerEntry: Record "Vendor Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", lGLSetup."Def. Pmt. Trf. Template");
        GenJnlLine.SETRANGE("Journal Batch Name", lGLSetup."Def. Pmt. Trf. Batch");
        IF GenJnlLine.FINDLAST THEN
            LineNumber := GenJnlLine."Line No." + 10
        ELSE
            LineNumber := 10;

        GenJournalBatch.GET(lGLSetup."Def. Pmt. Trf. Template", lGLSetup."Def. Pmt. Trf. Batch");
        GenJournalBatch.TESTFIELD("Posting No. Series");

        lVendorLedgerEntry.CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");

        //----------- Post vendor Credit Note 
        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", lGLSetup."Def. Pmt. Trf. Template");
        GenJnlLine.VALIDATE("Journal Batch Name", lGLSetup."Def. Pmt. Trf. Batch");
        GenJnlLine."Line No." := LineNumber;
        GenJnlLine."Document Type" := lVendorLedgerEntry."Document Type"::"Credit Memo";
        GenJnlLine."Source Code" := 'PURCHJNL';
        GenJnlLine.SetUpNewLine(GenJnlLine, 0, TRUE);

        CLEAR(NoSeriesMgt);
        GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(GenJournalBatch."Posting No. Series", lVendorLedgerEntry."Posting Date", TRUE);

        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", lVendorLedgerEntry."Vendor No.");
        GenJnlLine.VALIDATE("Posting Date", TODAY);
        GenJnlLine."Document Date" := lVendorLedgerEntry."Document Date";
        GenJnlLine.VALIDATE("Payment Terms Code", lVendorLedgerEntry."Payment Method Code");
        GenJnlLine.VALIDATE("Due Date", TODAY);
        GenJnlLine."External Document No." := lVendorLedgerEntry."External Document No.";
        GenJnlLine.VALIDATE("Currency Code", lVendorLedgerEntry."Currency Code");
        if lVendorLedgerEntry."Currency Code" <> '' then
            GenJnlLine.VALIDATE("Currency Factor", lVendorLedgerEntry."Original Currency Factor");
        GenJnlLine.VALIDATE(Amount, lVendorLedgerEntry."Remaining Amount" * -1);
        GenJnlLine.VALIDATE("Amount (LCY)", lVendorLedgerEntry."Remaining Amt. (LCY)" * -1);
        GenJnlLine.VALIDATE("Applies-to Doc. Type", lVendorLedgerEntry."Document Type");
        GenJnlLine.VALIDATE("Applies-to Doc. No.", lVendorLedgerEntry."Document No.");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", lGLSetup."Def. IC Trf. G/L Account");

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        // ------ Post IC vendor Purchase Invoice 
        LineNumber += 10;
        GenJnlLine.INIT;
        GenJnlLine.VALIDATE("Journal Template Name", lGLSetup."Def. Pmt. Trf. Template");
        GenJnlLine.VALIDATE("Journal Batch Name", lGLSetup."Def. Pmt. Trf. Batch");
        GenJnlLine."Line No." := LineNumber;
        GenJnlLine."Document Type" := lVendorLedgerEntry."Document Type"::Invoice;
        GenJnlLine."Source Code" := 'PURCHJNL';
        GenJnlLine.SetUpNewLine(GenJnlLine, 0, TRUE);

        CLEAR(NoSeriesMgt);
        GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(GenJournalBatch."Posting No. Series", lVendorLedgerEntry."Posting Date", TRUE);

        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", lGLSetup."Def. IC Vendor Account");
        GenJnlLine.VALIDATE("Posting Date", TODAY);
        GenJnlLine."Document Date" := lVendorLedgerEntry."Document Date";
        GenJnlLine.VALIDATE("Payment Terms Code", lVendorLedgerEntry."Payment Method Code");
        GenJnlLine.VALIDATE("Due Date", TODAY);
        GenJnlLine."External Document No." := lVendorLedgerEntry."External Document No.";
        GenJnlLine.VALIDATE("Currency Code", lVendorLedgerEntry."Currency Code");
        if lVendorLedgerEntry."Currency Code" <> '' then
            GenJnlLine.VALIDATE("Currency Factor", lVendorLedgerEntry."Original Currency Factor");
        GenJnlLine.VALIDATE(Amount, lVendorLedgerEntry."Remaining Amount");
        GenJnlLine.VALIDATE("Amount (LCY)", lVendorLedgerEntry."Remaining Amt. (LCY)");
        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.VALIDATE("Bal. Account No.", lGLSetup."Def. IC Trf. G/L Account");

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        // insert record in staging for another company
        VendorLedgerTransferData.INIT;
        VendorLedgerTransferData."Transfer-From Company" := lGLSetup.CURRENTCOMPANY;
        VendorLedgerTransferData."Transfer-From VLE No." := lVendorLedgerEntry."Entry No.";
        VendorLedgerTransferData."Transfer-To Company" := TransferToCompany;
        VendorLedgerTransferData."Document Type" := lVendorLedgerEntry."Document Type";
        VendorLedgerTransferData."Document No." := lVendorLedgerEntry."Document No.";
        VendorLedgerTransferData."Posting Date" := TODAY;
        VendorLedgerTransferData."Document Date" := TODAY;
        VendorLedgerTransferData."External Document No." := lVendorLedgerEntry."External Document No.";
        VendorLedgerTransferData."Currency Code" := lVendorLedgerEntry."Currency Code";
        if lVendorLedgerEntry."Currency Code" <> '' then
            VendorLedgerTransferData."Currency Factor" := lVendorLedgerEntry."Original Currency Factor";
        VendorLedgerTransferData."Original Amount" := lVendorLedgerEntry."Original Amount";
        VendorLedgerTransferData."Original Amt. (LCY)" := lVendorLedgerEntry."Original Amt. (LCY)";
        VendorLedgerTransferData."Transfered Amount" := lVendorLedgerEntry."Remaining Amount";
        VendorLedgerTransferData."Transfered Amt. (LCY)" := lVendorLedgerEntry."Remaining Amt. (LCY)";
        VendorLedgerTransferData."Due Date" := TODAY;
        VendorLedgerTransferData."Vendor No." := VendorCode;
        VendorLedgerTransferData.INSERT;
        // rsw-nam-016 <<        
    end;

    procedure PostICVendorTransaction()
    var
        VendorLedgerTransferData: Record "Vendor Ledger Transfer Data";
        VendorLedgerTransferData2: Record "Vendor Ledger Transfer Data";
        GenJnlLine: Record "Gen. Journal Line";
        LineNumber: Integer;
        GenJournalBatch: Record "Gen. Journal Batch";
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GLSetup.GET();
        GLSetup.TESTFIELD("Def. Pmt. Trf. Template");
        GLSetup.TESTFIELD("Def. Pmt. Trf. Batch");
        GLSetup.TESTFIELD("Def. IC Trf. G/L Account");
        GLSetup.TESTFIELD("Def. IC Vendor Account");

        VendorLedgerTransferData.RESET;
        VendorLedgerTransferData.SETCURRENTKEY("Transfer-To Company", "IC Document Created");
        VendorLedgerTransferData.SETRANGE("Transfer-To Company", COMPANYNAME);
        VendorLedgerTransferData.SETRANGE("IC Document Created", FALSE);
        IF VendorLedgerTransferData.FINDSET THEN
            REPEAT
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", GLSetup."Def. Pmt. Trf. Template");
                GenJnlLine.SETRANGE("Journal Batch Name", GLSetup."Def. Pmt. Trf. Batch");
                IF GenJnlLine.FINDLAST THEN
                    LineNumber := GenJnlLine."Line No." + 10
                ELSE
                    LineNumber := 10;

                GenJournalBatch.GET(GLSetup."Def. Pmt. Trf. Template", GLSetup."Def. Pmt. Trf. Batch");

                // post invoice of actual vendor
                GenJnlLine.INIT;
                GenJnlLine.VALIDATE("Journal Template Name", GLSetup."Def. Pmt. Trf. Template");
                GenJnlLine.VALIDATE("Journal Batch Name", GLSetup."Def. Pmt. Trf. Batch");
                GenJnlLine."Line No." := LineNumber;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                GenJnlLine."Source Code" := 'PURCHJNL';
                GenJnlLine."Document No." := VendorLedgerTransferData."Document No.";
                GenJnlLine.SetUpNewLine(GenJnlLine, 0, TRUE);

                CLEAR(NoSeriesMgt);
                GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(GenJournalBatch."Posting No. Series", VendorLedgerTransferData."Posting Date", TRUE);

                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", VendorLedgerTransferData."Vendor No.");
                GenJnlLine.VALIDATE("Posting Date", VendorLedgerTransferData."Posting Date");
                GenJnlLine."Document Date" := VendorLedgerTransferData."Document Date";
                GenJnlLine.VALIDATE("Due Date", VendorLedgerTransferData."Due Date");
                GenJnlLine."External Document No." := VendorLedgerTransferData."External Document No.";
                GenJnlLine.VALIDATE("Currency Code", VendorLedgerTransferData."Currency Code");
                GenJnlLine.VALIDATE("Currency Factor", VendorLedgerTransferData."Currency Factor");
                GenJnlLine.VALIDATE(Amount, VendorLedgerTransferData."Transfered Amount");
                GenJnlLine.VALIDATE("Amount (LCY)", VendorLedgerTransferData."Transfered Amt. (LCY)");
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", GLSetup."Def. IC Trf. G/L Account");
                GenJnlLine."External Document No." := VendorLedgerTransferData."External Document No.";

                GenJnlPostLine.RunWithCheck(GenJnlLine);

                // post credit note of IC vendor
                LineNumber += 10;
                GenJnlLine.INIT;
                GenJnlLine.VALIDATE("Journal Template Name", GLSetup."Def. Pmt. Trf. Template");
                GenJnlLine.VALIDATE("Journal Batch Name", GLSetup."Def. Pmt. Trf. Batch");
                GenJnlLine."Line No." := LineNumber;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
                GenJnlLine."Document No." := VendorLedgerTransferData."Document No.";
                GenJnlLine.SetUpNewLine(GenJnlLine, 0, TRUE);

                CLEAR(NoSeriesMgt);
                GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(GenJournalBatch."Posting No. Series", VendorLedgerTransferData."Posting Date", TRUE);

                GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.VALIDATE("Account No.", GLSetup."Def. IC Vendor Account");
                GenJnlLine.VALIDATE("Posting Date", VendorLedgerTransferData."Posting Date");
                GenJnlLine."Document Date" := VendorLedgerTransferData."Document Date";
                GenJnlLine.VALIDATE("Due Date", VendorLedgerTransferData."Due Date");
                GenJnlLine."External Document No." := VendorLedgerTransferData."External Document No.";
                GenJnlLine.VALIDATE("Currency Code", VendorLedgerTransferData."Currency Code");
                GenJnlLine.VALIDATE("Currency Factor", VendorLedgerTransferData."Currency Factor");
                GenJnlLine.VALIDATE(Amount, VendorLedgerTransferData."Transfered Amount" * -1);
                GenJnlLine.VALIDATE("Amount (LCY)", VendorLedgerTransferData."Transfered Amt. (LCY)" * -1);
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", GLSetup."Def. IC Trf. G/L Account");
                GenJnlLine."External Document No." := VendorLedgerTransferData."External Document No.";

                GenJnlPostLine.RunWithCheck(GenJnlLine);

                VendorLedgerTransferData2.GET(VendorLedgerTransferData."Transfer-From Company", VendorLedgerTransferData."Document No.");
                VendorLedgerTransferData2."IC Document Created" := TRUE;
                VendorLedgerTransferData2.MODIFY;

                COMMIT;
            UNTIL VendorLedgerTransferData.NEXT = 0;
    end;

    procedure CreateIntercompanySI()
    var
        ICManifestHeader: Record "Intercompany Manifest Header";
        ICManifestHeader2: Record "Intercompany Manifest Header";
        TempJobQueueEntry: Record "Job Queue Entry" temporary;
        Counter: Integer;
        RecRef: RecordRef;
    begin
        ICManifestHeader.RESET;
        ICManifestHeader.SETCURRENTKEY("Document Type", "InterCompany PO Created", "Manifest No.", "Retry Count");
        ICManifestHeader.SETRANGE("Document Type", ICManifestHeader."Document Type"::"Posted Manifest");
        ICManifestHeader.SETRANGE("InterCompany SO Created", FALSE);
        ICManifestHeader.SETRANGE("Retry Count", 0, 2);
        IF ICManifestHeader.FINDSET THEN
            REPEAT
                RecRef.GETTABLE(ICManifestHeader);

                TempJobQueueEntry.INIT;
                TempJobQueueEntry.ID := CREATEGUID;
                TempJobQueueEntry."Record ID to Process" := RecRef.RECORDID;
                TempJobQueueEntry."Parameter String" := 'Create IC SI Internal';
                TempJobQueueEntry.INSERT;

                IF NOT CODEUNIT.RUN(CODEUNIT::"Intercompany Posting", TempJobQueueEntry) THEN BEGIN
                    ICManifestHeader2.gET(ICManifestHeader."Manifest No.");
                    ICManifestHeader2."Error Message" := COPYSTR('CREATE IC SI: ' + GETLASTERRORTEXT, 1, 250);
                    ICManifestHeader2."Retry Count" := ICManifestHeader2."Retry Count" + 1;
                    ICManifestHeader2.MODIFY;
                END;
                COMMIT;
            UNTIL ICManifestHeader.NEXT = 0;
    end;

    local procedure CreateIntercompanySIInternal(JobQueueEntry: Record "Job Queue Entry")
    var
        RecRef: RecordRef;
        ICManifestHeader: Record "Intercompany Manifest Header";
        ICManifestLine: Record "Intercompany Manifest Line";
        Location: Record Location;
        HeaderCreated: Boolean;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchInvLine: Record "Purch. Inv. Line";
        LineNo: Integer;
        EntryNo: Integer;
        InterCompanyEntry: Record "Intercompany Entry";
        MarginPer: Decimal;
        MarginSetup: Record "Margin Setup";
        UnitPrice: Decimal;
        CurrencyFactor: Decimal;
        PriceWithMargin: Decimal;
        OldSINumber: code[20];
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        Item: Record Item;
        OverheadPer: Decimal;
        MarginSetupFound: Boolean;
    begin
        JobQueueEntry.TESTFIELD(JobQueueEntry."Record ID to Process");
        RecRef.GET(JobQueueEntry."Record ID to Process");
        RecRef.SETTABLE(ICManifestHeader);
        ICManifestHeader.FIND;

        Location.RESET;
        Location.SETRANGE(Code, ICManifestHeader.Location);
        Location.FINDFIRST;
        Location.TestField("InterCompany Customer");

        InterCompanyEntry.Reset();
        IF InterCompanyEntry.FINDLAST THEN
            EntryNo := InterCompanyEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        ICManifestLine.RESET;
        ICManifestLine.SETRANGE("Manifest No.", ICManifestHeader."Manifest No.");
        IF ICManifestLine.FINDSET THEN
            REPEAT
                // ---------------------- Insert Sales Header --------------------
                IF (Location."Intercompany Invoice Per GRN") THEN
                    HeaderCreated := FALSE;

                CurrencyFactor := 1;
                IF NOT HeaderCreated THEN BEGIN
                    SalesHeader.RESET;
                    SalesHeader.INIT;
                    SalesHeader."No." := '';
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                    SalesHeader."Posting Date" := TODAY;
                    SalesHeader.VALIDATE("Sell-to Customer No.", Location."InterCompany Customer");
                    SalesHeader.VALIDATE("Bill-to Customer No.", Location."InterCompany Customer");
                    SalesHeader."IC Manifest No." := ICManifestHeader."Manifest No.";
                    SalesHeader."GRN No." := ICManifestLine."GRN No.";
                    SalesHeader.INSERT(TRUE);

                    SalesHeader.VALIDATE("Location Code", Location.Code);
                    SalesHeader.MODIFY;
                    HeaderCreated := TRUE;
                    if OldSINumber <> '' then begin
                        if SalesHeader.Status <> SalesHeader.Status::Released then
                            ReleaseSalesDoc.PerformManualRelease(SalesHeader);
                    end;

                    OldSINumber := SalesHeader."No.";
                    IF SalesHeader."Currency Factor" <> 0 THEN
                        CurrencyFactor := SalesHeader."Currency Factor";
                END;
                // ---------------------- Insert Sales Line --------------------
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", ICManifestLine."GRN No.");
                IF PurchInvLine.FINDSET THEN BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                    SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    IF SalesLine.FINDLAST THEN
                        LineNo := SalesLine."Line No." + 10
                    ELSE
                        LineNo := 10;
                    REPEAT
                        SalesLine.INIT;
                        SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
                        SalesLine.VALIDATE("Document No.", SalesHeader."No.");
                        SalesLine.VALIDATE("Line No.", LineNo);
                        SalesLine.VALIDATE("Location Code", SalesHeader."Location Code");
                        SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                        SalesLine.VALIDATE("No.", PurchInvLine."No.");
                        SalesLine.VALIDATE("Item Category Code", PurchInvLine."Item Category Code");
                        SalesLine.VALIDATE(Quantity, PurchInvLine.Quantity);

                        PriceWithMargin := 0;
                        UnitPrice := PurchInvLine."Unit Cost (LCY)";
                        IF UnitPrice = 0 THEN
                            ERROR('No invoice found for Grn No %1', PurchInvLine."Document No.");
                        Item.get(SalesLine."No.");
                        GetMargin(SalesHeader."Location Code", Item, SalesHeader."Order Date", MarginPer, OverheadPer, MarginSetupFound);

                        IF NOT MarginSetupFound then
                            ERROR('No Margin Setup found for Location %1 and Item %2 in Grn No %3', SalesHeader."Location Code", PurchInvLine."No.", PurchInvLine."Document No.");

                        IF (MarginPer <> 0) AND (UnitPrice <> 0) THEN
                            PriceWithMargin := UnitPrice + ROUND(((UnitPrice * MarginPer) / 100), 0.00001);
                        PriceWithMargin := PriceWithMargin / CurrencyFactor;
                        UnitPrice := UnitPrice / CurrencyFactor;
                        SalesLine.VALIDATE("Unit Price", PriceWithMargin);
                        SalesLine."IC Manifest No." := ICManifestLine."Manifest No.";
                        SalesLine."GRN No." := ICManifestLine."GRN No.";
                        SalesLine.INSERT(TRUE);
                        LineNo += 10;

                        // -------------------- Insert IntercompanyEntry --------------------
                        InterCompanyEntry."Entry No." := EntryNo;
                        InterCompanyEntry."Manifest No." := ICManifestHeader."Manifest No.";
                        InterCompanyEntry."GRN No." := ICManifestLine."GRN No.";
                        InterCompanyEntry."Location Code" := ICManifestHeader.Location;
                        InterCompanyEntry."SO No" := SalesHeader."No.";
                        InterCompanyEntry."Customer Code" := SalesHeader."Bill-to Customer No.";
                        InterCompanyEntry."Item No." := SalesLine."No.";
                        InterCompanyEntry.Quantity := SalesLine.Quantity;
                        InterCompanyEntry."Margin Per" := MarginPer;
                        InterCompanyEntry."Unit Cost" := UnitPrice;
                        InterCompanyEntry."Sales Price" := PriceWithMargin;
                        InterCompanyEntry."Invoice ID" := PurchInvLine.document_nr;
                        InterCompanyEntry."PO No." := PurchInvLine.po_shipment_nr;
                        InterCompanyEntry."Buying Po No." := PurchInvLine.buying_po_nr;
                        InterCompanyEntry.INSERT;
                        EntryNo += 1;
                    UNTIL PurchInvLine.NEXT = 0;
                END;
                ICManifestLine."Sales Order No." := SalesHeader."No.";
                ICManifestLine.MODIFY;
            UNTIL ICManifestLine.NEXT = 0;

        ICManifestHeader."InterCompany SO Created" := TRUE;
        ICManifestHeader."Manifest Received" := TRUE;
        ICManifestHeader."Error Message" := '';
        ICManifestHeader."Retry Count" := 0;
        ICManifestHeader.MODIFY;
        if SalesHeader.Status <> SalesHeader.Status::Released then
            ReleaseSalesDoc.PerformManualRelease(SalesHeader);
    end;

    procedure PostIntercompanySI()
    var
        SalesHeader: Record "Sales Header";
        RecRef: RecordRef;
        TempJobQueueEntry: Record "Job Queue Entry" temporary;
        ICManifestHeader: Record "Intercompany Manifest Header";
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("IC Manifest No.");
        SalesHeader.SETFILTER("IC Manifest No.", '<>%1', '');
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        IF SalesHeader.FINDSET THEN
            REPEAT
                RecRef.GETTABLE(SalesHeader);

                TempJobQueueEntry.INIT;
                TempJobQueueEntry.ID := CREATEGUID;
                TempJobQueueEntry."Record ID to Process" := RecRef.RECORDID;
                TempJobQueueEntry."Parameter String" := 'Post IC SI Internal';
                TempJobQueueEntry.INSERT;
                IF NOT CODEUNIT.RUN(CODEUNIT::"Intercompany Posting", TempJobQueueEntry) THEN BEGIN
                    ICManifestHeader.Get(SalesHeader."IC Manifest No.");
                    ICManifestHeader."Error Message" := COPYSTR('POST IC SI: ' + GETLASTERRORTEXT, 1, 250);
                    ICManifestHeader."Retry Count" := ICManifestHeader."Retry Count" + 1;
                    ICManifestHeader.MODIFY;
                END ELSE BEGIN
                    ICManifestHeader.Get(SalesHeader."IC Manifest No.");
                    ICManifestHeader."Error Message" := '';
                    ICManifestHeader."Retry Count" := 0;
                    ICManifestHeader.MODIFY;
                END;
                COMMIT;
            until SalesHeader.Next() = 0;
    end;

    local procedure PostIntercompanySIInternal(JobQueueEntry: Record "Job Queue Entry")
    var
        RecRef: RecordRef;
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        JobQueueEntry.TESTFIELD(JobQueueEntry."Record ID to Process");
        RecRef.GET(JobQueueEntry."Record ID to Process");
        RecRef.SETTABLE(SalesHeader);

        SalesHeader.FIND;

        CLEAR(SalesPost);
        SalesPost.RUN(SalesHeader);
    end;

    procedure CreateIntercompanyPI()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        ICManifestHeader: Record "Intercompany Manifest Header";
        ICManifestHeader2: Record "Intercompany Manifest Header";
        RecRef: RecordRef;
        TempJobQueueEntry: Record "Job Queue Entry" temporary;
    begin
        PurchSetup.GET();
        PurchSetup.TESTFIELD("IC Location Codes");

        ICManifestHeader.RESET;
        ICManifestHeader.SETCURRENTKEY("Document Type", "Manifest Received", "Manifest No.");
        ICManifestHeader.SETRANGE("Document Type", ICManifestHeader."Document Type"::"Posted Manifest");
        ICManifestHeader.SETRANGE("InterCompany PO Created", FALSE);
        ICManifestHeader.SETRANGE("InterCompany SO Created", TRUE);
        ICManifestHeader.SETRANGE(Location, PurchSetup."IC Location Codes");
        ICManifestHeader.SETRANGE("Retry Count", 0, 2);
        IF ICManifestHeader.FINDSET THEN
            REPEAT
                RecRef.GETTABLE(ICManifestHeader);

                TempJobQueueEntry.INIT;
                TempJobQueueEntry.ID := CREATEGUID;
                TempJobQueueEntry."Record ID to Process" := RecRef.RECORDID;
                TempJobQueueEntry."Parameter String" := 'Create IC PI Internal';
                TempJobQueueEntry.INSERT;

                IF NOT CODEUNIT.RUN(CODEUNIT::"Intercompany Posting", TempJobQueueEntry) THEN BEGIN
                    ICManifestHeader2.GET(ICManifestHeader."Manifest No.");
                    ICManifestHeader2."Error Message" := COPYSTR('CREATE IC PI: ' + GETLASTERRORTEXT, 1, 250);
                    ICManifestHeader2."Retry Count" := ICManifestHeader2."Retry Count" + 1;
                    ICManifestHeader2.MODIFY;
                END;
                COMMIT;
            UNTIL ICManifestHeader.NEXT = 0;
    end;

    local procedure CreateIntercompanyPIInternal(JobQueueEntry: Record "Job Queue Entry")
    var
        RecRef: RecordRef;
        ICManifestHeader: Record "Intercompany Manifest Header";
        ICManifestLine: Record "Intercompany Manifest Line";
        Location: Record Location;
        CreatePOPerGRN: Boolean;
        MarginSetup: Record "Margin Setup";
        HeaderCreated: Boolean;
        PurchHeader: Record "Purchase Header";
        LineNo: Integer;
        InterCompanyEntry: Record "Intercompany Entry";
        ItemRec: Record Item;
        OverheadPercent: Decimal;
        MarginSetupFound: Boolean;
        PurchLine: Record "Purchase Line";
        MarginPer: Decimal;
        OldPINumber: code[20];
        ReleasePurchaseDoc: Codeunit "Release Purchase Document";
    begin
        JobQueueEntry.TESTFIELD(JobQueueEntry."Record ID to Process");
        RecRef.GET(JobQueueEntry."Record ID to Process");
        RecRef.SETTABLE(ICManifestHeader);
        ICManifestHeader.FIND;
        ICManifestHeader."InterCompany PO Created" := TRUE;
        ICManifestHeader."Error Message" := '';
        ICManifestHeader."Retry Count" := 0;
        ICManifestHeader.MODIFY;

        Location.RESET;
        Location.SETRANGE("InterCompany Location Code", ICManifestHeader.Location);
        Location.FINDFIRST;
        Location.TestField("InterCompany Vendor");
        CreatePOPerGRN := (Location."Intercompany Invoice Per GRN" = TRUE);

        ICManifestLine.RESET;
        ICManifestLine.SETCURRENTKEY("Manifest No.", "Sales Order No.");
        ICManifestLine.SETRANGE("Manifest No.", ICManifestHeader."Manifest No.");
        IF ICManifestLine.FINDSET THEN begin
            REPEAT
                IF CreatePOPerGRN THEN
                    HeaderCreated := FALSE;

                IF NOT HeaderCreated THEN BEGIN
                    purchHeader.INIT;
                    purchHeader.VALIDATE("Document Type", purchHeader."Document Type"::Invoice);
                    IF CreatePOPerGRN THEN
                        purchHeader.VALIDATE("No.", ICManifestLine."WeBuy Document No.");

                    purchHeader.VALIDATE("Order Date", DT2DATE(ICManifestHeader."Posted DateTime"));
                    purchHeader.VALIDATE("Document Date", DT2DATE(ICManifestHeader."Posted DateTime"));
                    purchHeader.VALIDATE("Posting Date", DT2DATE(ICManifestHeader."Posted DateTime"));
                    purchHeader.VALIDATE("Buy-from Vendor No.", Location."InterCompany Vendor");
                    purchHeader.VALIDATE("Pay-to Vendor No.", Location."InterCompany Vendor");
                    purchHeader.VALIDATE("Vendor Order No.", ICManifestLine."WeBuy Document No.");
                    purchHeader.VALIDATE("Purchaser Code", 'BUYING');
                    purchHeader.VALIDATE("Posting No. Series", 'PPI');
                    purchHeader.VALIDATE("Vendor Invoice No.", ICManifestLine."Sales Order No.");
                    purchHeader."Your Reference" := 'INTERCOMPANY';
                    purchHeader."IC Manifest No." := ICManifestLine."Manifest No.";
                    purchHeader.INSERT(TRUE);

                    purchHeader."Location Code" := Location.Code;
                    purchHeader.Modify();
                    if OldPINumber <> '' then begin
                        if purchHeader.Status <> purchHeader.Status::Released then begin
                            CLEAR(ReleasePurchaseDoc);
                            ReleasePurchaseDoc.ReleasePurchaseHeader(purchHeader, TRUE);
                        end;
                    end;

                    OldPINumber := PurchHeader."No.";
                    HeaderCreated := TRUE;
                    LineNo := 0;
                END;

                InterCompanyEntry.RESET;
                InterCompanyEntry.SETCURRENTKEY("Manifest No.", "SO No");
                InterCompanyEntry.SETRANGE("Manifest No.", ICManifestLine."Manifest No.");
                InterCompanyEntry.SETRANGE("GRN No.", ICManifestLine."GRN No.");
                IF InterCompanyEntry.FINDSET THEN
                    REPEAT
                        ItemRec.RESET;
                        IF NOT ItemRec.GET(InterCompanyEntry."Item No.") THEN
                            CreateItem(InterCompanyEntry."Item No.", ItemRec);

                        ItemRec.TESTFIELD("No.", InterCompanyEntry."Item No.");

                        GetMargin(purchHeader."Location Code", ItemRec, purchHeader."Posting Date", MarginPer, OverheadPercent, MarginSetupFound);

                        IF NOT MarginSetupFound THEN
                            ERROR('No Overhead Setup found for Location %1 and Item %2 in Grn No %3', PurchHeader."Location Code",
                                      InterCompanyEntry."Item No.", InterCompanyEntry."GRN No.");
                        LineNo += 10;
                        PurchLine.INIT;
                        PurchLine.VALIDATE("Document Type", PurchHeader."Document Type");
                        PurchLine.VALIDATE("Document No.", PurchHeader."No.");
                        PurchLine.VALIDATE("Line No.", LineNo);
                        PurchLine.VALIDATE("Location Code", PurchHeader."Location Code");
                        PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                        PurchLine.VALIDATE("No.", InterCompanyEntry."Item No.");
                        PurchLine.VALIDATE(Quantity, InterCompanyEntry.Quantity);
                        PurchLine.VALIDATE("Direct Unit Cost", InterCompanyEntry."Sales Price");
                        PurchLine.VALIDATE("Indirect Cost %", OverheadPercent);
                        PurchLine.VALIDATE(putaway_nr, InterCompanyEntry."GRN No.");
                        PurchLine.VALIDATE(buying_po_nr, InterCompanyEntry."Buying Po No.");
                        PurchLine.VALIDATE(document_nr, InterCompanyEntry."Invoice ID");
                        PurchLine.VALIDATE(po_shipment_nr, InterCompanyEntry."PO No.");
                        PurchLine."Allow Posting" := TRUE;
                        PurchLine.INSERT(TRUE);
                    UNTIL InterCompanyEntry.NEXT = 0;
                ICManifestLine."Purchase Order No." := PurchHeader."No.";
                ICManifestLine.MODIFY;
            UNTIL ICManifestLine.NEXT = 0;
            if purchHeader.Status <> purchHeader.Status::Released then begin
                CLEAR(ReleasePurchaseDoc);
                ReleasePurchaseDoc.ReleasePurchaseHeader(purchHeader, TRUE);
            end;
        end;
    end;

    local procedure CreateItem(ItemCode: code[20]; var recItem: Record Item)
    var
        lItem: Record Item;
        HSCodes: Record "HS Codes";
        ItemUoM: Record "Item Unit of Measure";
    begin
        lItem.Reset();
        lItem.CHANGECOMPANY('NAMSHI DWC');
        lItem.Get(ItemCode);

        recItem.INIT;
        recItem.Copy(lItem);
        recItem.Insert();
        IF (recItem."HS Code" <> '') AND (NOT HSCodes.GET(recItem."HS Code")) THEN BEGIN
            HSCodes.INIT;
            HSCodes."HS Code" := recItem."HS Code";
            HSCodes.Description := recItem."HS Code";
            HSCodes.INSERT;
        END;

        IF NOT ItemUoM.GET(recItem."No.", recItem."Base Unit of Measure") THEN BEGIN
            ItemUoM.INIT;
            ItemUoM."Item No." := recItem."No.";
            ItemUoM.Code := recItem."Base Unit of Measure";
            ItemUoM."Qty. per Unit of Measure" := 1;
            ItemUoM.INSERT;
        END;
    end;

    procedure GetMargin(LocationCode: code[10]; lItem: Record Item; EffectiveDate: Date; var MarginPercent: Decimal
                            ; var OverheadPercent: Decimal; var MarginSetupFound: Boolean)
    var
        MarginSetup: Record "Margin Setup";
    begin
        MarginPercent := 0;
        OverheadPercent := 0;
        MarginSetupFound := FALSE;
        MarginSetup.RESET;
        MarginSetup.SETCURRENTKEY("Location Code", "Effective Date", "Margin Type", Code);//rsw-nam-007
        MarginSetup.SETRANGE("Location Code", LocationCode);
        MarginSetup.SETRANGE("Effective Date", 0D, EffectiveDate);
        MarginSetup.SETRANGE("Margin Type", MarginSetup."Margin Type"::"Item Category");
        MarginSetup.SETRANGE(Code, lItem."Item Category Code");
        IF MarginSetup.FINDLAST THEN begin
            MarginPercent := MarginSetup."Margin %";
            OverheadPercent := MarginSetup."Overhead %" + MarginSetup."Freight %";
            MarginSetupFound := TRUE;
        end ELSE BEGIN
            MarginSetup.SETRANGE("Margin Type", MarginSetup."Margin Type"::"HS Code");
            MarginSetup.SETRANGE(Code, lItem."HS Code");
            IF MarginSetup.FINDLAST THEN begin
                MarginPercent := MarginSetup."Margin %";
                OverheadPercent := MarginSetup."Overhead %" + MarginSetup."Freight %";
                MarginSetupFound := TRUE;
            end else begin
                MarginSetup.SETRANGE("Margin Type", MarginSetup."Margin Type"::All);
                MarginSetup.SETRANGE(Code);
                IF MarginSetup.FINDLAST THEN begin
                    MarginPercent := MarginSetup."Margin %";
                    OverheadPercent := MarginSetup."Overhead %" + MarginSetup."Freight %";
                    MarginSetupFound := TRUE;
                end;
            end;
        END;
    end;
}
