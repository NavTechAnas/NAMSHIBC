table 50000 "Sales Order FTP"
{
    fields
    {
        field(1; customer_no; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; order_date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; order_no; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; order_item_id; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; payment_terms_code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(21; bidc; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; bids; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; unit_price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; vat_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; discount_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; sales_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; paid_price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52; order_time; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(61; coupon_code; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(62; coupon_money; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(63; coupon_percent; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; payment_gateway; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(71; special_price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(72; wallet_item_amt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73; shipping_charge; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(74; ship_to_country; code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(75; currency; code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(76; cross_border_charges; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(81; destination; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(82; location; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(83; promo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(101; boxid; Code[50])
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
        key(Key3; order_item_id)
        {
        }
    }
}

