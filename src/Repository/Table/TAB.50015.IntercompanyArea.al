table 50015 "Intercompany Area"
{
    fields
    {
        field(1; "Area Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Area Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

