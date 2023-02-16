page 50020 "Item API"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'namshi';
    APIGroup = 'FTP';

    EntityCaption = 'ItemFTP';
    EntitySetCaption = 'ItemFTP';
    EntityName = 'itemFTP';
    EntitySetName = 'itemFTP';
    SourceTable = Item;
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(item_no; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(inventory_posting_group; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                }
                field(product_posting_group; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field(item_category_code; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field(hs_code; Rec."HS Code")
                {
                    ApplicationArea = All;
                }
                field(country_of_origin; Rec."Country of Origin")
                {
                    ApplicationArea = All;
                }
                field(category; Rec.Category)
                {
                    ApplicationArea = All;
                }
                field(sub_category; Rec."Sub Category")
                {
                    ApplicationArea = All;
                }
                field(retail_price; Rec."Retail Price")
                {
                    ApplicationArea = All;
                }
                field(supplier_sku; Rec."Supplier SKU")
                {
                    ApplicationArea = All;
                }
                field(unit_cost; Rec."Unit Cost")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        HSCodes: Record "HS Codes";
                        ItemUoM: Record "Item Unit of Measure";
                        ItemVendor: Record "Item Vendor";
                    begin
                        rec."Base Unit of Measure" := 'PCS';
                        rec."Sales Unit of Measure" := 'PCS';
                        rec."Purch. Unit of Measure" := 'PCS';

                        rec.Validate("Return Prod. Posting Group", 'R' + rec."Gen. Prod. Posting Group");
                        rec."Costing Method" := rec."Costing Method"::Average;

                        IF (rec."HS Code" <> '') AND (NOT HSCodes.GET(rec."HS Code")) THEN BEGIN
                            HSCodes.INIT;
                            HSCodes."HS Code" := rec."HS Code";
                            HSCodes.Description := rec."HS Code";
                            HSCodes.INSERT;
                        END;

                        IF NOT ItemUoM.GET(rec."No.", rec."Base Unit of Measure") THEN BEGIN
                            ItemUoM.INIT;
                            ItemUoM."Item No." := rec."No.";
                            ItemUoM.Code := rec."Base Unit of Measure";
                            ItemUoM."Qty. per Unit of Measure" := 1;
                            ItemUoM.INSERT;
                        END;

                        //if not ItemVendor.Get() // todo
                    END;
                }
            }
        }
    }
}
