table 50008 "Gift Card Sales Invoice FTP"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; invoice_id; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; giftcard_id; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; giftcard_date; date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; country_code; code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(11; giftcard_netamount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; giftcard_vatamount; Decimal)
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
        key(Key1; invoice_id, giftcard_id)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}