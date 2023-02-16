table 50022 "Bulk Sales Import"
{


    DataPerCompany = false;

    fields
    {
        field(1; invoice_type; Code[30])
        {
        }
        field(2; mp_code; Code[30])
        {
        }
        field(3; partner_sales_nr; Code[30])
        {
        }
        field(4; partner_sku; Code[30])
        {
        }
        field(5; invoice_date; Date)
        {
        }
        field(6; external_ref_type; Code[30])
        {
        }
        field(7; external_ref; Code[30])
        {
        }
        field(8; trn; Code[30])
        {
        }
        field(9; from_entity_country; Code[10])
        {
        }
        field(10; to_entity_type; Code[30])
        {
        }
        field(11; to_entity_uid; Code[50])
        {
        }
        field(12; to_entity_group_uid; Code[50])
        {
        }
        field(13; to_entity_country; Code[10])
        {
        }
        field(14; invoice_nr; Code[30])
        {
        }
        field(15; line_nr; Integer)
        {
        }
        field(16; qty; Integer)
        {
        }
        field(17; vat_rate; Decimal)
        {
        }
        field(18; vat_supply; Decimal)
        {
        }
        field(19; vat_amount; Decimal)
        {
        }
        field(20; RetryCount; Integer)
        {
        }
        field(21; Error; Text[250])
        {
        }
        field(22; "Sales Order Created"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; partner_sales_nr, external_ref)
        {
            Clustered = true;
        }
        key(Key2; external_ref)
        {
        }
    }

    fieldgroups
    {
    }
}

