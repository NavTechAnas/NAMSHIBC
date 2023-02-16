page 50014 "Intercompany Manifest Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Intercompany Manifest Line";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Manifest No."; rec."Manifest No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Manifest Date"; rec."Manifest Date")
                {
                    ApplicationArea = All;
                }
                field("GRN No."; rec."GRN No.")
                {
                    ApplicationArea = All;
                }
                field("Area Code"; rec."Area Code")
                {
                    ApplicationArea = All;
                }
                field("Out Scanned By"; rec."Out Scanned By")
                {
                    ApplicationArea = All;
                }
                field("Out Scanned DateTime"; rec."Out Scanned DateTime")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}