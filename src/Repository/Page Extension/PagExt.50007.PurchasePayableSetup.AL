pageextension 50007 "Purchases Payables Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Job Queue Category Code")
        {
            field("Purch. Inv. Creation Threshold"; Rec."Purch. Inv. Creation Threshold")
            {
                ApplicationArea = All;
            }
            field("Purchase Posting Threshold"; Rec."Purchase Posting Threshold")
            {
                ApplicationArea = All;
            }
            field("IC Location Codes"; Rec."IC Location Codes")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
}