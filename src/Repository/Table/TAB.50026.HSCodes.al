table 50026 "HS Codes"
{


    DataPerCompany = false;
    // DrillDownPageID = 50139;
    // LookupPageID = 50139;

    fields
    {
        field(1; "HS Code"; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "HS Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

