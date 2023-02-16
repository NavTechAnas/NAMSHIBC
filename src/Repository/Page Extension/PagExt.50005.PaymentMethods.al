pageextension 50005 "Payment Methods Ext" extends "Payment Methods"
{
    layout
    {
        addafter(Description)
        {
            field("Payment Gateway"; Rec."Payment Gateway")
            {
                ApplicationArea = All;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
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