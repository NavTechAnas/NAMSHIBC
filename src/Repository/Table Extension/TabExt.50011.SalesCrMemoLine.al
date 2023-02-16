tableextension 50011 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000; "BOB Order Item ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; boxid; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Web Order ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; WalletItemAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}