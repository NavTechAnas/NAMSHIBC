page 50007 "Sales Return FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'SalesReturnFTP';
    EntitySetCaption = 'SalesReturnFTP';
    EntityName = 'salesReturnFTP';
    EntitySetName = 'salesReturnFTP';
    SourceTable = "Sales Return FTP";
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(web_order_id; Rec.web_order_id)
                {
                    ApplicationArea = All;
                }
                field(order_item_id; Rec.order_item_id)
                {
                    ApplicationArea = All;
                }
                field(return_order_no; Rec.return_order_no)
                {
                    ApplicationArea = All;
                }
                field(return_order_date; Rec.return_order_date)
                {
                    ApplicationArea = All;
                }
                field(bidc; Rec.bidc)
                {
                    ApplicationArea = All;
                }
                field(unit_price; Rec.unit_price)
                {
                    ApplicationArea = All;
                }
                field(amount; Rec.amount)
                {
                    ApplicationArea = All;
                }
                field(currency; Rec.currency)
                {
                    ApplicationArea = All;
                }
                field(bids; Rec.bids)
                {
                    ApplicationArea = All;
                }
                field(location_code; Rec.location_code)
                {
                    ApplicationArea = All;
                }
                field(sales_return_type; Rec.sales_return_type)
                {
                    ApplicationArea = All;
                }
                field(quantity; Rec.quantity)
                {
                    ApplicationArea = All;
                }
                field(reason; Rec.reason)
                {
                    ApplicationArea = All;
                }
                field(item_category_code; Rec.item_category_code)
                {
                    ApplicationArea = All;
                }
                field(vat_amount; Rec.vat_amount)
                {
                    ApplicationArea = All;
                }
                field(crossborder_amt; Rec.crossborder_amt)
                {
                    ApplicationArea = All;
                }
                field(return_fee_amt; Rec.return_fee_amt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
