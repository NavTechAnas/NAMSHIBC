tableextension 50015 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
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