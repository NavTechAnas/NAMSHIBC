tableextension 50017 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{
    fields
    {
        field(50001; buying_po_nr; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; po_shipment_nr; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; qc_status; ENUM "QC Status")
        {
            DataClassification = ToBeClassified;
        }
        field(50004; putaway_nr; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; document_nr; code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}