table 50032 "HSBC Setup"
{



    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "HSBC No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; Authstn; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Grpg; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; BkPtyId; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; PmtMtd; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; ClrChanl; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; BIC; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Inf; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; ClrSysMmbId; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; RmtLctnMtd; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "HSBC Remote Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "NAV Local Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "File Mask"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Log File Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "HSBC Port Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "HSBC FTP Address"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "HSBC User Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "HSBC SSH Private Key Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

