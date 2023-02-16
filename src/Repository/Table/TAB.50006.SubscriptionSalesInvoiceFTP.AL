table 50006 "Subscription Sales Invoice FTP"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; invoice_id; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; subscription_id; text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; subscription_date; date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; subscription_type; text[5])
        {
            DataClassification = ToBeClassified;
        }
        field(12; subscription_value; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; subscription_vat_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; subscription_discount_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; subscription_net_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; country_code; code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(21; order_reference; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(31; sales_invoice_created; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; invoice_id, subscription_id)
        {
            Clustered = true;
        }
    }
}