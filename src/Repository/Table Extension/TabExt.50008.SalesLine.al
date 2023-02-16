tableextension 50008 "Sales Line Ext" extends "Sales Line"
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
        field(50004; "IC Manifest No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "GRN No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}