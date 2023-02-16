table 50005 "Sales Return Status FTP"
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
        field(3; received_date; datetime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; carrier; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(31; sales_return_order_created; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51; RAWB; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(53; qc_status; enum "Return QC Status")
        {
            DataClassification = ToBeClassified;
        }
        field(58; URAWB; code[30])
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