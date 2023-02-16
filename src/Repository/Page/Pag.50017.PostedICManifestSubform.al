page 50017 "Posted IC Manifest Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Intercompany Manifest Line";

    layout
    {
        area(content)
        {
            repeater(lines)
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
                field("Area Code"; rec."Area Code")
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; rec."Sales Order No.")
                {
                    ApplicationArea = All;
                }
                field("GRN No."; rec."GRN No.")
                {
                    ApplicationArea = All;
                }
                field("Purchase Order No."; rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                }
                field("Manifest Date"; rec."Manifest Date")
                {
                    ApplicationArea = All;
                }
                field("GRN Received"; rec."GRN Received")
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
                field("In Scanned By"; rec."In Scanned By")
                {
                    ApplicationArea = All;
                }
                field("In Scanned DateTime"; rec."In Scanned DateTime")
                {
                    ApplicationArea = All;
                }
                field("WeBuy Document No."; rec."WeBuy Document No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

