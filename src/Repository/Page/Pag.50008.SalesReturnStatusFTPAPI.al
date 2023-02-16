page 50008 "Sales Return Status FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'SalesReturnFTP';
    EntitySetCaption = 'SalesReturnFTP';
    EntityName = 'salesReturnFTP';
    EntitySetName = 'salesReturnFTP';
    SourceTable = "Sales Return Status FTP";
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
                field(received_date; Rec.received_date)
                {
                    ApplicationArea = All;
                }
                field(carrier; Rec.carrier)
                {
                    ApplicationArea = All;
                }
                field(sales_return_order_created; Rec.sales_return_order_created)
                {
                    ApplicationArea = All;
                }
                field(RAWB; Rec.RAWB)
                {
                    ApplicationArea = All;
                }
                field(qc_status; Rec.qc_status)
                {
                    ApplicationArea = All;
                }
                field(URAWB; Rec.URAWB)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
