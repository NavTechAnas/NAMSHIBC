tableextension 50005 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(50000; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Created DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Approved DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }

        field(50004; "AWB No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
    }

    var
        myInt: Integer;
}