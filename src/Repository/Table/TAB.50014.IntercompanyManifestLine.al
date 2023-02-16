table 50014 "Intercompany Manifest Line"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Manifest No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Manifest Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "GRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Area Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Sales Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "GRN Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "WeBuy Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Out Scanned By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Out Scanned DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "In Scanned By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "In Scanned DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Transfer Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Manifest No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

