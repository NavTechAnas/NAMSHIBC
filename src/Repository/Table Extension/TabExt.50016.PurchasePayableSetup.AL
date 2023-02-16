tableextension 50016 "Purchases Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Purch. Inv. Creation Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Purchase Posting Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "IC Location Codes"; code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}