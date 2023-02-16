tableextension 50000 "Sales & Receivable Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Intercompany Manifest No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50001; "Wallet Sales A/c"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50002; "Posting Date Filter"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Sales Posting Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Wallet Posting Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Crossborder Charges Account"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50006; "Shipping Charges Account"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50007; "Sales Inv. Creation Threshold"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Return Fee A/C"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50050; "Wallet Gen Journal Template"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50061; "Subscription Customer No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
    }

    var
        myInt: Integer;
}