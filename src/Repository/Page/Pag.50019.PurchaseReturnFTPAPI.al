page 50019 "Purchase Return FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'PurchaseReturnFTP';
    EntitySetCaption = 'PurchaseReturnFTP';
    EntityName = 'purchaseReturnFTP';
    EntitySetName = 'purchaseReturnFTP';
    SourceTable = "Purchase Return FTP";
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(rtv_nr; Rec.rtv_nr)
                {
                    ApplicationArea = All;
                }
                field(line_nr; Rec.line_nr)
                {
                    ApplicationArea = All;
                }
                field(pack_order_no; Rec.pack_order_no)
                {
                    ApplicationArea = All;
                }
                field(vendor_code; Rec.vendor_code)
                {
                    ApplicationArea = All;
                }
                field(bidc; Rec.bidc)
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
                field(quantity; Rec.quantity)
                {
                    ApplicationArea = All;
                }
                field(unit_cost; Rec.unit_cost)
                {
                    ApplicationArea = All;
                }
                field(currency; Rec.currency)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
