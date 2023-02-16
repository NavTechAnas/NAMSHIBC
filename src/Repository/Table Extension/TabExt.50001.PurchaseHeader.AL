tableextension 50001 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50000; "IC Manifest No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; qc_status; ENUM "QC Status")
        {
            DataClassification = ToBeClassified;
        }
        field(50002; PO_ShipmentNr; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50501; "Retry Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50502; "Error Message"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50900; "Completely Allow Posting"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Min("Purchase Line"."Allow Posting" WHERE("Document Type" = FIELD("Document Type"),
                                                                        "Document No." = FIELD("No."),
                                                                        Type = FILTER(<> ' '),
                                                                        "Location Code" = FIELD("Location Filter")));
            Editable = false;
        }
    }

    var
        myInt: Integer;
}