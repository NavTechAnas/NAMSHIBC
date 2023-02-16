pageextension 50004 "Posted S.Cr.Memo Subform Ext" extends "Posted Sales Cr. Memo Subform"
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