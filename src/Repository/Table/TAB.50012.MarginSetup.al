table 50012 "Margin Setup"
{
    fields
    {
        field(1; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(2; "Margin Type"; Enum "Margin Type")
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Margin Type" = CONST("Item Category")) "Item Category".Code
            ELSE
            IF ("Margin Type" = CONST("HS Code")) "HS Codes"."HS Code";
        }
        field(4; "Margin %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Overhead %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Freight %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Location Code", "Effective Date", "Margin Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

