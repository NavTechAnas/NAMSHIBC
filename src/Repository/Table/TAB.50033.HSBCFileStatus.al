table 50033 "HSBC File Status"
{



    fields
    {
        field(1; "File ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "File Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Is Sucess"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "File Send to HSBC"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Transfered Date and Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Transfered By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Ready to Transfer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Acknowledge File1"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Acknowledge File2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Acknowledgement; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Error Message"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "File Message ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "File ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

