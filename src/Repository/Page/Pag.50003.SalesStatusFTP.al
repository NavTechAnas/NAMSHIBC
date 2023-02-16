page 50003 "Sales Status FTP"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Sales Status FTP";
    UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(order_no; Rec.order_no)
                {
                    ApplicationArea = All;
                }
                field(order_item_id; Rec.order_item_id)
                {
                    ApplicationArea = All;
                }
                field(status; Rec.status)
                {
                    ApplicationArea = All;
                }
                field(web_invoice_no; Rec.web_invoice_no)
                {
                    ApplicationArea = All;
                }
                field(status_date; Rec.status_date)
                {
                    ApplicationArea = All;
                }
                field(carrier; Rec.carrier)
                {
                    ApplicationArea = All;
                }
                field(shipment_no; Rec.shipment_no)
                {
                    ApplicationArea = All;
                }
                field(awb_no; Rec.awb_no)
                {
                    ApplicationArea = All;
                }
                field(shipping_handling_charges; Rec.shipping_handling_charges)
                {
                    ApplicationArea = All;
                }
                field(shipping_amount; Rec.shipping_amount)
                {
                    ApplicationArea = All;
                }
                field(order_updated; Rec.order_updated)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Clear update")
            {
                ApplicationArea = All;
                Caption = 'Clear update';
                Image = ClearLog;

                trigger OnAction()
                begin
                    ClearUpdate();
                    CurrPage.Update();
                end;
            }
        }
    }

    local procedure ClearUpdate()
    var
        SalesStatusFTP: Record "Sales Status FTP";
    begin
        SalesStatusFTP.Reset();
        SalesStatusFTP.SetRange(order_no, Rec.order_no);
        SalesStatusFTP.ModifyAll(order_updated, false);
    end;
}
