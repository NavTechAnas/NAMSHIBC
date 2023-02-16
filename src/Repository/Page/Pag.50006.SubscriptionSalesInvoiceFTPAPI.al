page 50006 "Subscription Sales Inv FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'SubscriptionSalesFTP';
    EntitySetCaption = 'SubscriptionSalesFTP';
    EntityName = 'subscriptionSalesFTP';
    EntitySetName = 'subscriptionSalesFTP';

    SourceTable = "Subscription Sales Invoice FTP";
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(invoice_id; Rec.invoice_id)
                {
                    ApplicationArea = All;
                }
                field(subscription_id; Rec.subscription_id)
                {
                    ApplicationArea = All;
                }
                field(subscription_date; Rec.subscription_date)
                {
                    ApplicationArea = All;
                }
                field(subscription_type; Rec.subscription_type)
                {
                    ApplicationArea = All;
                }
                field(subscription_value; Rec.subscription_value)
                {
                    ApplicationArea = All;
                }
                field(subscription_vat_amount; Rec.subscription_vat_amount)
                {
                    ApplicationArea = All;
                }
                field(subscription_discount_amount; Rec.subscription_discount_amount)
                {
                    ApplicationArea = All;
                }
                field(subscription_net_amount; Rec.subscription_net_amount)
                {
                    ApplicationArea = All;
                }
                field(country_code; Rec.country_code)
                {
                    ApplicationArea = All;
                }
                field(order_reference; Rec.order_reference)
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
