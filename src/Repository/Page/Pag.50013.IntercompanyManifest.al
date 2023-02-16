page 50013 "Intercompany Manifest"
{
    Caption = 'InterCompany Manifest';
    PageType = Document;
    Permissions = TableData "Purch. Inv. Header" = rm;
    RefreshOnActivate = true;
    SourceTable = "Intercompany Manifest Header";
    SourceTableView = SORTING("Manifest No.")
                      WHERE("Document Type" = CONST(Manifest));

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
                    Editable = false;

                    trigger OnAssistEdit();
                    begin
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Manifest Date"; rec."Manifest Date")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field(Location; rec.Location)
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("No. of GRN"; rec."No. of GRN")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("GRN No"; GRNNo)
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        rec.InsertManifestLine(rec."Manifest No.", GRNNo);
                        GRNNo := '';
                        CurrPage.UPDATE;
                    end;
                }
            }
            part(ManifestLines; "Intercompany Manifest Subform")
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
            group("O&rder")
            {
                Caption = 'O&rder';
                Image = "Order";
                action("Post Manifest")
                {
                    AccessByPermission = TableData 120 = RIMD;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Manifest';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                    trigger OnAction();
                    var
                        Handled: Boolean;
                    begin
                        rec.PostManifest(rec."Manifest No.");
                        CurrPage.UPDATE;
                    end;
                }
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
    }

    var
        GRNNo: Code[20];
        ManifestHeader: Record "Intercompany Manifest Header";
}