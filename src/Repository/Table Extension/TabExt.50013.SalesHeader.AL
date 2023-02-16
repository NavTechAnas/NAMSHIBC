tableextension 50013 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50000; "Wallet Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Wallet Exist"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; awb_no; code[25])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; sales_return_type; enum "Sales Return Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "IC Manifest No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "GRN No."; code[20])
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
    }

    var
        myInt: Integer;
}