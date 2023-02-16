table 50003 "Sales Status FTP"
{
    fields
    {
        field(1; order_no; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; order_item_id; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; status; enum "Sales Status")
        {
            DataClassification = ToBeClassified;
        }
        field(4; status_date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; web_invoice_no; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; carrier; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(21; shipment_no; code[15])
        {
            DataClassification = ToBeClassified;
        }
        field(22; awb_no; code[25])
        {
            DataClassification = ToBeClassified;
        }
        field(23; shipping_handling_charges; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; shipping_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; order_updated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52; shipping_vat_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53; shipping_cross_border_charges; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; order_no, order_item_id)
        {
            Clustered = true;
        }
    }
}

