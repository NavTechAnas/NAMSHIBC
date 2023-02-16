pageextension 50009 "Location Card Ext" extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field(WAREHOUSE_CODE; Rec.WAREHOUSE_CODE)
            {
                ApplicationArea = All;
            }
            field("Intercompany Invoice Per GRN"; Rec."Intercompany Invoice Per GRN")
            {
                ApplicationArea = All;
            }
            field("InterCompany Customer"; Rec."InterCompany Customer")
            {
                ApplicationArea = All;
            }
            field("InterCompany Vendor"; Rec."InterCompany Vendor")
            {
                ApplicationArea = All;
            }
            field("InterCompany Location Code"; Rec."InterCompany Location Code")
            {
                ApplicationArea = All;
            }

        }
    }
}