tableextension 50004 "Location Ext" extends Location
{
    fields
    {
        field(51100; "Intercompany Invoice Per GRN"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51101; "InterCompany Customer"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(51102; "InterCompany Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51103; "InterCompany Vendor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));
        }
        field(51104; "WAREHOUSE_CODE"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}