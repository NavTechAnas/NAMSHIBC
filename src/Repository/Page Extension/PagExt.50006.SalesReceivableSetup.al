pageextension 50006 "Sales Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Job Queue Category Code")
        {
            field("Payment Gateway"; Rec."Intercompany Manifest No")
            {
                ApplicationArea = All;
            }
            field("Wallet Sales A/c"; Rec."Wallet Sales A/c")
            {
                ApplicationArea = All;
            }
            field("Posting Date Filter"; Rec."Posting Date Filter")
            {
                ApplicationArea = All;
            }
            field("Sales Inv. Creation Threshold"; Rec."Sales Inv. Creation Threshold")
            {
                ApplicationArea = All;
            }
            field("Sales Posting Threshold"; Rec."Sales Posting Threshold")
            {
                ApplicationArea = All;
            }
            field("Wallet Posting Threshold"; Rec."Wallet Posting Threshold")
            {
                ApplicationArea = All;
            }
            field("Crossborder Charges Account"; Rec."Crossborder Charges Account")
            {
                ApplicationArea = All;
            }
            field("Shipping Charges Account"; Rec."Shipping Charges Account")
            {
                ApplicationArea = All;
            }
            field("Return Fee A/C"; Rec."Return Fee A/C")
            {
                ApplicationArea = All;
            }
            field("Wallet Gen Journal Template"; Rec."Wallet Gen Journal Template")
            {
                ApplicationArea = All;
            }
            field("Subscription Customer No."; Rec."Subscription Customer No.")
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