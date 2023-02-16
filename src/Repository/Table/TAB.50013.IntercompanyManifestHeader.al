table 50013 "Intercompany Manifest Header"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;
    Permissions = TableData "Purch. Inv. Header" = rm;

    fields
    {
        field(1; "Manifest No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Manifest No." <> xRec."Manifest No." THEN BEGIN
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Intercompany Manifest No");
                END;
            end;
        }
        field(2; "Manifest Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Location; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(6; "Document Type"; enum "Manifest Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(7; "InterCompany SO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "InterCompany PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Posted DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Error Message"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Retry Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(103; "Manifest Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(104; "No. of GRN"; Integer)
        {
            CalcFormula = Count("Intercompany Manifest Line" WHERE("Manifest No." = FIELD("Manifest No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Pending GRN Count"; Integer)
        {
            CalcFormula = Count("Intercompany Manifest Line" WHERE("Manifest No." = FIELD("Manifest No."),
                                                                    "GRN Received" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Manifest No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Intercompany Manifest No");
        NoSeriesMgt.InitSeries(SalesSetup."Intercompany Manifest No", SalesSetup."Intercompany Manifest No", TODAY, "Manifest No.", SalesSetup."Intercompany Manifest No");

        "Manifest Date" := TODAY;
    end;

    procedure InsertManifestLine(ManifestNo: Code[20]; GRN: Code[20]);
    var
        IntercompanyManifestHeader: Record "Intercompany Manifest Header";
        IntercompanyManifestLine: Record "Intercompany Manifest Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        IntercompanyManifestLine2: Record "Intercompany Manifest Line";
        LineNo: Integer;
        PurchHeader: Record "Purchase Header";
    begin
        IntercompanyManifestHeader.RESET;
        IntercompanyManifestHeader.SETRANGE("Manifest No.", ManifestNo);
        IF IntercompanyManifestHeader.FINDFIRST THEN;

        PurchInvHeader.RESET;
        PurchInvHeader.SETRANGE("No.", GRN);
        PurchInvHeader.FINDFIRST;

        IF PurchInvHeader."Location Code" <> IntercompanyManifestHeader.Location THEN
            ERROR('Location Code for GRN is different from Manifest');

        IntercompanyManifestLine2.RESET;
        IntercompanyManifestLine2.SETRANGE("GRN No.", GRN);
        IntercompanyManifestLine2.SETRANGE("Location Code", Location);
        IF IntercompanyManifestLine2.FINDFIRST THEN
            ERROR('GRN already scanned in Manifest No %1', IntercompanyManifestLine2."Manifest No.");

        // rsw-nam-006 >>
        IF PurchHeader.GET(PurchHeader."Document Type"::Invoice, PurchInvHeader."Order No.") THEN BEGIN
            PurchHeader.CALCFIELDS("Completely Allow Posting");
            IF PurchHeader."Completely Allow Posting" = FALSE THEN
                ERROR('There are still Discrepancy items exist in GRN %1', GRN);
        END;
        // rsw-nam-006 <<

        IntercompanyManifestLine.RESET;
        IntercompanyManifestLine.SETRANGE("Manifest No.", ManifestNo);
        IF IntercompanyManifestLine.FINDLAST THEN
            LineNo := IntercompanyManifestLine."Line No." + 10
        ELSE
            LineNo := 10;

        IntercompanyManifestLine.INIT;
        IntercompanyManifestLine."Manifest No." := ManifestNo;
        IntercompanyManifestLine."Line No." := LineNo;
        IntercompanyManifestLine."WeBuy Document No." := PurchInvHeader."Vendor Order No.";
        IntercompanyManifestLine."Location Code" := IntercompanyManifestHeader.Location;
        IntercompanyManifestLine."Manifest Date" := IntercompanyManifestHeader."Manifest Date";
        IntercompanyManifestLine."GRN No." := GRN;
        IntercompanyManifestLine."Area Code" := PurchInvHeader."Area Code";
        IntercompanyManifestLine."Out Scanned By" := USERID;
        IntercompanyManifestLine."Out Scanned DateTime" := CURRENTDATETIME;
        IntercompanyManifestLine.INSERT;
    end;

    procedure PostManifest(ManifestNo: Code[20]);
    var
        IntercompanyManifestHeader: Record "Intercompany Manifest Header";
        IntercompanyManifestLine: Record "Intercompany Manifest Line";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        IntercompanyManifestLine.RESET;
        IntercompanyManifestLine.SETRANGE("Manifest No.", ManifestNo);
        IF IntercompanyManifestLine.FINDSET THEN
            REPEAT
                PurchInvHeader.RESET;
                PurchInvHeader.GET(IntercompanyManifestLine."GRN No.");
                PurchInvHeader."IC Manifest No." := "Manifest No.";
                PurchInvHeader.MODIFY;
            UNTIL IntercompanyManifestLine.NEXT = 0;

        IntercompanyManifestHeader.RESET;
        IntercompanyManifestHeader.SETRANGE("Manifest No.", "Manifest No.");
        IF IntercompanyManifestHeader.FINDFIRST THEN BEGIN
            IntercompanyManifestHeader."Document Type" := IntercompanyManifestHeader."Document Type"::"Posted Manifest";
            IntercompanyManifestHeader."Posted DateTime" := CURRENTDATETIME;
            IntercompanyManifestHeader.MODIFY;
            MESSAGE('Manifest Posted Successfully');
        END;
    end;

    procedure AssistEdit(InterManifestHrd: Record "Intercompany Manifest Header"): Boolean;
    var
        InterManifestHrd2: Record "Intercompany Manifest Header";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        InterManifestHrd.COPY(Rec);
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Intercompany Manifest No");
        IF NoSeriesMgt.SelectSeries(SalesSetup."Intercompany Manifest No", SalesSetup."Intercompany Manifest No", SalesSetup."Intercompany Manifest No") THEN BEGIN
            NoSeriesMgt.SetSeries(SalesSetup."Intercompany Manifest No");
            Rec := InterManifestHrd;
            EXIT(TRUE);
        END;

    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
