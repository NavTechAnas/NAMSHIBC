tableextension 50020 "Gen. Journal Line Ext" extends "Gen. Journal Line"
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