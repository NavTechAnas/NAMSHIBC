table 50007 "Inventory FTP"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; entry_no; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; location_code; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; posting_date; date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; entry_type; enum "Inventory Entry Type")
        {
            DataClassification = ToBeClassified;
        }
        field(11; bids; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; bidc; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; unit_cost; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Unit cost per quantity in local currency';
        }
        field(21; inventory_source; enum "Inventory Source")
        {
            DataClassification = ToBeClassified;
        }
        field(22; source_code; code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; entry_no)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

}