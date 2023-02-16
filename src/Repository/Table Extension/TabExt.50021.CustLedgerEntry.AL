tableextension 50021 "Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "AWB No."; code[20])
        {
            DataClassification = ToBeClassified;

        }

    }

    var
        myInt: Integer;
}