pageextension 50008 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Job Queue Category Code")
        {
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("No VAT Bus. Posting Group"; Rec."No VAT Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("No VAT Prod. Posting Group"; Rec."No VAT Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Allow IC inbound transfer"; Rec."Allow IC inbound transfer")
            {
                ApplicationArea = All;
            }
            field("Allow IC outbound transfer"; Rec."Allow IC outbound transfer")
            {
                ApplicationArea = All;
            }
            field("Def. Pmt. Trf. Template"; Rec."Def. Pmt. Trf. Template")
            {
                ApplicationArea = All;
            }
            field("Def. Pmt. Trf. Batch"; Rec."Def. Pmt. Trf. Batch")
            {
                ApplicationArea = All;
            }
            field("Def. IC Trf. G/L Account"; Rec."Def. IC Trf. G/L Account")
            {
                ApplicationArea = All;
            }
            field("Def. IC Vendor Account"; Rec."Def. IC Vendor Account")
            {
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
}