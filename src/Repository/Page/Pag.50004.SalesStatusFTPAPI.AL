page 50004 "Sales Status FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'SalesStatusFTP';
    EntitySetCaption = 'SalesStatusFTP';
    EntityName = 'salesStatusFTP';
    EntitySetName = 'salesStatusFTP';

    SourceTable = "Sales Status FTP";

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(order_no; Rec.order_no)
                { ApplicationArea = All; }
                field(order_item_id; Rec.order_item_id)
                { ApplicationArea = All; }
                field(status; Rec.status)
                { ApplicationArea = All; }
                field(status_date; Rec.status_date)
                { ApplicationArea = All; }
                field(carrier; Rec.carrier)
                { ApplicationArea = All; }
                field(shipment_no; Rec.shipment_no)
                { ApplicationArea = All; }
                field(awb_no; Rec.awb_no)
                { ApplicationArea = All; }
                field(shipping_handling_charges; Rec.shipping_handling_charges)
                { ApplicationArea = All; }
                field(shipping_amount; Rec.shipping_amount)
                { ApplicationArea = All; }
                field(order_updated; Rec.order_updated)
                { ApplicationArea = All; }
                field(web_invoice_no; Rec.web_invoice_no)
                { ApplicationArea = All; }
                field(shipping_vat_amount; Rec.shipping_vat_amount)
                { ApplicationArea = All; }
                field(shipping_cross_border_charges; Rec.shipping_cross_border_charges)
                { ApplicationArea = All; }
            }
        }
    }
}