page 50001 "Purchase Order FTP API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'PurchaseOrderFTP';
    EntitySetCaption = 'PurchaseOrderFTP';
    EntityName = 'purchaseOrderFTP';
    EntitySetName = 'purchaseOrderFTP';

    SourceTable = "Purchase Order FTP";

    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(bidc; Rec.bidc)
                { ApplicationArea = All; }
                field(bids; Rec.bids)
                { ApplicationArea = All; }
                field(brand; Rec.brand)
                { ApplicationArea = All; }
                field(buying_po_nr; Rec.buying_po_nr)
                { ApplicationArea = All; }
                field(category; Rec.category)
                { ApplicationArea = All; }
                field(cd_supp_id; Rec.cd_supp_id)
                { ApplicationArea = All; }
                field(color; Rec.color)
                { ApplicationArea = All; }
                field(country_of_origin; Rec.country_of_origin)
                { ApplicationArea = All; }
                field(created_by; Rec.created_by)
                { ApplicationArea = All; }
                field(currency; Rec.currency)
                { ApplicationArea = All; }
                field(description; Rec.description)
                { ApplicationArea = All; }
                field(document_nr; Rec.document_nr)
                { ApplicationArea = All; }
                field(freight_cost; Rec.freight_cost)
                { ApplicationArea = All; }
                field(gate_in_at; Rec.gate_in_at)
                { ApplicationArea = All; }
                field(hs_code; Rec.hs_code)
                { ApplicationArea = All; }
                field(inventory_posting_group; Rec.inventory_posting_group)
                { ApplicationArea = All; }
                field(item_category_code; Rec.item_category_code)
                { ApplicationArea = All; }
                field(line_nr; Rec.line_nr)
                { ApplicationArea = All; }
                field(location; Rec.location)
                { ApplicationArea = All; }
                field(payment_terms; Rec.payment_terms)
                { ApplicationArea = All; }
                field(po_shipment_nr; Rec.po_shipment_nr)
                { ApplicationArea = All; }
                field(posted_at; Rec.posted_at)
                { ApplicationArea = All; }
                field(product_posting_group; Rec.product_posting_group)
                { ApplicationArea = All; }
                field(qty; Rec.qty)
                { ApplicationArea = All; }
                field(retail_price; Rec.retail_price)
                { ApplicationArea = All; }
                field(size; Rec.size)
                { ApplicationArea = All; }
                field(sub_category; Rec.sub_category)
                { ApplicationArea = All; }
                field(supplier_sku; Rec.supplier_sku)
                { ApplicationArea = All; }
                field(unit_cost; Rec.unit_cost)
                { ApplicationArea = All; }
                field(vat_amt; Rec.vat_amount)
                { ApplicationArea = All; }
                field(vendor_code; Rec.vendor_code)
                { ApplicationArea = All; }
                field(vendor_invoice_nr; Rec.vendor_invoice_nr)
                { ApplicationArea = All; }
                field(vendor_invoice_qty; Rec.vendor_invoice_qty)
                { ApplicationArea = All; }
                field(vendor_invoice_value; Rec.vendor_invoice_value)
                { ApplicationArea = All; }

            }
        }
    }
}