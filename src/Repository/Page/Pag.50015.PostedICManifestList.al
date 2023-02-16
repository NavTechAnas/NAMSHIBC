page 50015 "Posted IC Manifest List"
{
    UsageCategory = Lists;
    CardPageID = "Posted IC Manifest";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Intercompany Manifest Header";
    SourceTableView = WHERE("Document Type" = CONST("Posted Manifest"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Posted DateTime"; rec."Posted DateTime")
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
                field("No. of GRN"; rec."No. of GRN")
                {
                    ApplicationArea = All;
                }
                field("Pending GRN Count"; rec."Pending GRN Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
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
                    SalesInvErr: Label 'Posted Sales Invoice does not exist.';
                    ManifestLine: Record "Intercompany Manifest Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    /* // todo
                    SalesInvoiceHeader.RESET();
                    SalesInvoiceHeader.SETRANGE("InterCompany Manifest No.", "Manifest No.");
                    IF NOT SalesInvoiceHeader.FINDFIRST() THEN
                        ERROR(SalesInvErr);

                    ManifestHeader.RESET;
                    ManifestHeader.SETRANGE("Manifest No.", "Manifest No.");
                    IF ManifestHeader.FINDFIRST THEN
                        REPORT.RUN(50069, TRUE, TRUE, ManifestHeader);
                    */
                end;
            }
        }
        area(Processing)
        {
            action("Reset Retry Counter")
            {
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    CurrPage.SetSelectionFilter(ICManifestHeader);
                    if ICManifestHeader.FindSet() then
                        repeat
                            ICManifestHeader."Retry Count" := 0;
                            ICManifestHeader."Error Message" := '';
                            ICManifestHeader.Modify();
                        until ICManifestHeader.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        ICManifestHeader: Record "Intercompany Manifest Header";
}