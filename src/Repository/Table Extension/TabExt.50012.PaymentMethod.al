tableextension 50012 "Payment Method Ext" extends "Payment Method"
{
    fields
    {
        field(50000; "Payment Gateway"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
    }

    var
        myInt: Integer;
}