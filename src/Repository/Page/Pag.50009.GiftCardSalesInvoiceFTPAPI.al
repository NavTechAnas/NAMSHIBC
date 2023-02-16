page 50009 "Gift Card Sales Inv FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'GiftCardSalesFTP';
    EntitySetCaption = 'GiftCardSalesFTP';
    EntityName = 'giftCardSalesFTP';
    EntitySetName = 'giftCardSalesFTP';
    SourceTable = "Gift Card Sales Invoice FTP";
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(invoice_id; Rec.invoice_id)
                {
                    ApplicationArea = All;
                }
                field(giftcard_id; Rec.giftcard_id)
                {
                    ApplicationArea = All;
                }
                field(giftcard_date; Rec.giftcard_date)
                {
                    ApplicationArea = All;
                }
                field(country_code; Rec.country_code)
                {
                    ApplicationArea = All;
                }
                field(giftcard_netamount; Rec.giftcard_netamount)
                {
                    ApplicationArea = All;
                }
                field(giftcard_vatamount; Rec.giftcard_vatamount)
                {
                    ApplicationArea = All;
                }
                field(sales_invoice_created; Rec.sales_invoice_created)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
