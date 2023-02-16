table 50002 "Purchase Return FTP"
{
    fields
    {
        field(1; rtv_nr; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; line_nr; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(6; pack_order_no; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; vendor_code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; bidc; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; bids; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; location_code; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(21; quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; unit_cost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; currency; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; rtv_nr, line_nr)
        {
            Clustered = true;
        }
    }
}

