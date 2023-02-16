pageextension 50011 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("Return Prod. Posting Group"; Rec."Return Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }


    var
        myInt: Integer;
}