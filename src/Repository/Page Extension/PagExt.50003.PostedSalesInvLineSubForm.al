pageextension 50003 "Posted Sales Inv. Sub Form Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field("BOB Order Item ID"; Rec."BOB Order Item ID")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}