table 50001 "Purchase Order FTP"
{
    fields
    {
        field(1; vendor_code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; document_nr; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; vendor_invoice_nr; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; vendor_invoice_qty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; vendor_invoice_value; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; payment_terms; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; currency; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(10; bids; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; qty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; unit_cost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; location; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14; buying_po_nr; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; line_nr; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "order_updated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; po_shipment_nr; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; freight_cost; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; brand; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; color; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; size; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; item_category_code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(27; product_posting_group; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(28; inventory_posting_group; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(29; bidc; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; gate_in_at; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(31; created_by; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(32; posted_at; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(33; item_created; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; vat_amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(43; cd_supp_id; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(44; description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(45; country_of_origin; Code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(46; hs_code; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(47; category; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(48; sub_category; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(49; retail_price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50; supplier_sku; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51; expected_qty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52; received_qty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53; qc_status; ENUM "QC Status")
        {
            DataClassification = ToBeClassified;
        }
        field(54; wh_code; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(55; putaway_nr; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(60; boxid; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(61; gtin; Code[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; document_nr, line_nr)
        {
            Clustered = true;
        }
        key(Key5; order_updated)
        {
        }
        key(Key6; item_created)
        {
        }
    }
}

