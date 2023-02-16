table 50025 "Vendor Ledger Transfer Data"
{


    DataPerCompany = false;

    fields
    {
        field(1; "Transfer-From Company"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
        }
        field(2; "Transfer-From VLE No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Transfer-To Company"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company.Name;
        }
        field(9; "Document Type"; enum "Gen. Journal Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
        }
        field(15; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Original Amt. (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Transfered Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Transfered Amt. (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(300; "IC Document Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Transfer-From Company", "Document No.")
        {
            Clustered = TRUE;
        }
        key(Key2; "Transfer-To Company", "IC Document Created")
        {
        }
    }

    fieldgroups
    {
    }
}

