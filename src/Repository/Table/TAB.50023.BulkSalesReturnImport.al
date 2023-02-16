table 50023 "Bulk Sales Return Import"
{


    DataPerCompany = false;

    fields
    {
        field(1; invoice_type; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; mp_code; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; partner_sales_nr; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; partner_sku; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; sku; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; invoice_date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; creditnote_date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; creditnote_type; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; source_document; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; trn; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; creditnote_nr; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; creditnote_line_nr; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; invoice_nr; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; invoice_line_nr; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; qty; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; vat_rate; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; vat_supply; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; vat_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; total; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; RetryCount; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Error; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Sales Return Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(23; "Order No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; mp_code, partner_sales_nr)
        {
            Clustered = true;
        }
        key(Key2; "Order No")
        {
        }
    }

    fieldgroups
    {
    }
}

