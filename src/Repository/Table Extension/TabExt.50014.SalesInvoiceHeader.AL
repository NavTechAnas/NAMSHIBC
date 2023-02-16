tableextension 50014 "Sales Invoice Header Ext" extends "Sales Invoice Header"
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
        field(50005; "IC Manifest No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "GRN No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Wallet Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(MyKey01; "Wallet Exist", "Wallet Created")
        {
        }
    }
    var
        myInt: Integer;
}