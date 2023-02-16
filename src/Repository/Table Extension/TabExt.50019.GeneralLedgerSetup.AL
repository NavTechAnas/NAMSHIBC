tableextension 50019 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "VAT Bus. Posting Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(50001; "VAT Prod. Posting Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(50002; "No VAT Bus. Posting Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(50003; "No VAT Prod. Posting Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(50005; "Def. Pmt. Trf. Template"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(50006; "Def. Pmt. Trf. Batch"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Def. Pmt. Trf. Template"));
        }
        field(50007; "Def. IC Trf. G/L Account"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50008; "Def. IC Vendor Account"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = vendor."No.";
        }
        field(50051; "Allow IC inbound transfer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Allow IC outbound transfer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}