tableextension 50018 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
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
        field(50101; "Area Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Scanned By"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Scanned DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}