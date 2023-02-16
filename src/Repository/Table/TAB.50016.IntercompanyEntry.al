table 50016 "Intercompany Entry"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Manifest No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "GRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "SO No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Customer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Margin Per"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Sales Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Invoice ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "PO No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Buying Po No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "TO No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

