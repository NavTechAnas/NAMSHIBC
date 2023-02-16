table 50030 "IC Outbound DXB to BR"
{


    DataPerCompany = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Item No."; Code[20])
        {
        }
        field(4; Quantity; Decimal)
        {
        }
        field(5; "Unit Price"; Decimal)
        {
        }
        field(6; "Line Amount"; Decimal)
        {
        }
        field(7; "Indirect Cost %"; Decimal)
        {
        }
        field(8; "Markup %"; Decimal)
        {
        }
        field(9; "IC PO Created"; Boolean)
        {
        }
        field(10; "IC Vendor No."; Code[20])
        {
        }
        field(11; "IC Location Code"; Code[10])
        {
        }
        field(12; "Invoice Location Code"; Code[10])
        {
        }
        field(13; "IC Purch. Order No."; Code[20])
        {
        }
        field(14; "Manifest No."; Code[20])
        {
        }
        field(15; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Unit Price Incl MG %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Bob Order Item ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; WebOrderID; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "BR PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "BR PO Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "BR SO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "BR SO Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "IC Sales Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Bob Order Item ID")
        {
        }
        key(Key3; WebOrderID)
        {
        }
    }

    fieldgroups
    {
    }
}

