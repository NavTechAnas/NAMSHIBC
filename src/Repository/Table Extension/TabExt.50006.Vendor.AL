tableextension 50006 "Vendor Ext" extends Vendor
{
    fields
    {
        field(50000; "Is Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Modified By"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Beneficiary Name"; text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}