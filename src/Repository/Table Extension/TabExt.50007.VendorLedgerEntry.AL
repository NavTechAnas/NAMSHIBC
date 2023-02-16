tableextension 50007 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "POP Code"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "HSBC Payment Type"; Enum "HSBC Payment Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "HSBC Reference No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "HSBC Primary No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "HSBC Error Line"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "HSBC Charge Bearer"; Enum "HSBC Charge Bearer")
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}