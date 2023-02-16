table 50004 "Sales Return FTP"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; web_order_id; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; order_item_id; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; return_order_no; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; return_order_date; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(12; bidc; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; unit_price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; currency; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(16; bids; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(32; location_code; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52; sales_return_type; enum "Sales Return Type")
        {
            DataClassification = ToBeClassified;
        }
        field(54; quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(55; reason; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(56; item_category_code; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59; vat_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; crossborder_amt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        FIELD(81; return_fee_amt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; web_order_id, order_item_id)
        {
            Clustered = true;
        }
    }
}