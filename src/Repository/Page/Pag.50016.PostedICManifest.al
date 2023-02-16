page 50016 "Posted IC Manifest"
{
    // version SM

    Caption = 'InterCompany Manifest';
    Editable = false;
    PageType = Document;
    SourceTable = "Intercompany Manifest Header";
    SourceTableView = SORTING("Manifest No.")
                      WHERE("Document Type" = CONST("Posted Manifest"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Manifest No."; rec."Manifest No.")
                {
                    ApplicationArea = All;
                }
                field("Manifest Date"; rec."Manifest Date")
                {
                    ApplicationArea = All;
                }
                field(Location; rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Posted DateTime"; rec."Posted DateTime")
                {
                    ApplicationArea = All;
                }
                field("InterCompany SO Created"; rec."InterCompany SO Created")
                {
                    ApplicationArea = All;
                }
                field("Manifest Received"; rec."Manifest Received")
                {
                    ApplicationArea = All;
                }
                field("InterCompany PO Created"; rec."InterCompany PO Created")
                {
                    ApplicationArea = All;
                }
                field("Error Message"; rec."Error Message")
                {
                    ApplicationArea = All;
                }
                field("Retry Count"; rec."Retry Count")
                {
                    ApplicationArea = All;
                }
            }
            part(ManifestLines; "Posted IC Manifest Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Manifest No." = FIELD("Manifest No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                action("Sales Orders")
                {
                    /* // todo
                    Caption = 'Sales Orders';
                    Image = Orders;
                    RunObject = Page 50104;
                    RunPageLink = InterCompany Manifest No.=FIELD(Manifest No.);
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                    trigger OnAction();
                    var
                        Handled : Boolean;
                    begin
                    end;
                    */
                }
                action("Posted Invoices")
                {
                    /* // todo
                    Image = Invoices;
                    RunObject = Page 50105;
                                    RunPageLink = InterCompany Manifest No.=FIELD(Manifest No.);
                                    */
                }
                action("Print Manifest")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        /* // todo
                        ManifestHeader.RESET;
                        ManifestHeader.SETRANGE("Manifest No.", "Manifest No.");
                        IF ManifestHeader.FINDFIRST THEN
                            REPORT.RUN(50257, TRUE, TRUE, ManifestHeader);
                            */
                    end;
                }
                action("Packing List")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        ManifestLine: Record "Intercompany Manifest Line";
                    begin
                        /* // todo
                        ManifestLine.RESET;
                        ManifestLine.SETRANGE("Manifest No.", Rec."Manifest No.");
                        IF ManifestLine.FINDFIRST THEN
                            REPORT.RUN(50093, TRUE, TRUE, ManifestLine);
                            */
                    end;
                }
                action("Commercial Invoice")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        ManifestHeader: Record "Intercompany Manifest Header";
                        ManifestLine: Record "Intercompany Manifest Line";
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        SalesInvErr: Label 'Posted Sales Invoice does not exist.';
                    begin
                        /* // todo
                        SalesInvoiceHeader.RESET();
                        SalesInvoiceHeader.SETRANGE("InterCompany Manifest No.", "Manifest No.");
                        IF NOT SalesInvoiceHeader.FINDFIRST() THEN
                            ERROR(SalesInvErr);

                        ManifestHeader.RESET;
                        ManifestHeader.SETRANGE("Manifest No.", Rec."Manifest No.");
                        IF ManifestHeader.FINDFIRST THEN
                            REPORT.RUN(50069, TRUE, TRUE, ManifestHeader);
                        */
                    end;
                }
            }
        }
    }

    var
        Text001: Label 'Do you want to change %1 in all related records in the warehouse?';
        Text002: Label 'The update has been interrupted to respect the warning.';
        OpenPostedSalesOrderQst: Label 'The order has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';
        EmptyShipToCodeErr: Label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';
        GRNNo: Code[20];
        ManifestHeader: Record "Intercompany Manifest Header";
}

