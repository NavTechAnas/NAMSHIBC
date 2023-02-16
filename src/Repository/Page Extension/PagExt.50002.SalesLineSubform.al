pageextension 50002 "Sales Order Subform Ext" extends "Sales Order Subform"
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