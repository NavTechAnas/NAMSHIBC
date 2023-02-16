page 50012 "Intercompany Manifest List"
{
    UsageCategory = Lists;
    CardPageID = "Intercompany Manifest";
    Editable = false;
    PageType = List;
    Permissions = TableData "Purch. Inv. Header" = rm;
    RefreshOnActivate = true;
    SourceTable = "Intercompany Manifest Header";
    SourceTableView = WHERE("Document Type" = CONST(Manifest));

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
                field("InterCompany PO Created"; rec."InterCompany PO Created")
                {
                    ApplicationArea = All;
                }
                field("Posted DateTime"; rec."Posted DateTime")
                {
                    ApplicationArea = All;
                }
                field("Manifest Received"; rec."Manifest Received")
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
                field("Error Message"; rec."Error Message")
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
                    ManifestHeader.RESET;
                    ManifestHeader.SETRANGE("Manifest No.", rec."Manifest No.");
                    IF ManifestHeader.FINDFIRST THEN
                        REPORT.RUN(50257, TRUE, TRUE, ManifestHeader);
                end;
            }
        }
    }

    var
        ManifestHeader: Record "Intercompany Manifest Header";

}