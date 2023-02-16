page 50000 "Sales Order FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'SalesOrderFTP';
    EntitySetCaption = 'SalesOrderFTP';
    EntityName = 'salesOrderFTP';
    EntitySetName = 'salesOrderFTP';

    SourceTable = "Sales Order FTP";

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(customer_no; Rec.customer_no)
                { ApplicationArea = All; }
                field(order_no; Rec.order_no)
                { ApplicationArea = All; }
                field(order_date; Rec.order_date)
                { ApplicationArea = All; }
                field(order_item_id; Rec.order_item_id)
                { ApplicationArea = All; }
                field(payment_terms_code; Rec.payment_terms_code)
                { ApplicationArea = All; }
                field(bids; Rec.bids)
                { ApplicationArea = All; }
                field(bidc; Rec.bidc)
                { ApplicationArea = All; }
                field(quantity; Rec.quantity)
                { ApplicationArea = All; }
                field(unit_price; Rec.unit_price)
                { ApplicationArea = All; }
                field(tax_amount; Rec.vat_amount)
                { ApplicationArea = All; }
                field(discount_amount; Rec.discount_amount)
                { ApplicationArea = All; }
                field(sales_amount; Rec.sales_amount)
                { ApplicationArea = All; }
                field(order_time; Rec.order_time)
                { ApplicationArea = All; }
                field(coupon_code; Rec.coupon_code)
                { ApplicationArea = All; }
                field(coupon_money; Rec.coupon_money)
                { ApplicationArea = All; }
                field(coupon_percent; Rec.coupon_percent)
                { ApplicationArea = All; }
                field(payment_gateway; Rec.payment_gateway)
                { ApplicationArea = All; }
                field(special_price; Rec.special_price)
                { ApplicationArea = All; }
                field(wallet_item_amt; Rec.wallet_item_amt)
                { ApplicationArea = All; }
                field(shipping_charge; Rec.shipping_charge)
                { ApplicationArea = All; }
                field(ship_to_country; Rec.ship_to_country)
                { ApplicationArea = All; }
                field(currency; Rec.currency)
                { ApplicationArea = All; }
                field(cross_border_charges; Rec.cross_border_charges)
                { ApplicationArea = All; }
                field(destination; Rec.destination)
                { ApplicationArea = All; }
                field(location; Rec.location)
                { ApplicationArea = All; }
                field(promo; Rec.promo)
                { ApplicationArea = All; }
            }
        }
    }
}