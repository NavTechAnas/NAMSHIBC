tableextension 50009 "Item  Ext" extends Item
{
    fields
    {
        field(50000; "HS Code"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Country of Origin"; code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Category; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Sub Category"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Retail Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Supplier SKU"; code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Return Prod. Posting Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        modify("Vendor No.")
        {
            trigger OnAfterValidate()
            var
                ItemVendor: Record "Item Vendor";
            begin
                ItemVendor.Reset();
                ItemVendor.SetRange("Item No.");
                if ItemVendor.FindFirst() then
                    ItemVendor.DeleteAll();
                ItemVendor.Init();
                ItemVendor."Vendor No." := "Vendor No.";
                ItemVendor."Item No." := "No.";
                ItemVendor.Insert();
            end;
        }
    }

    var
        myInt: Integer;
}