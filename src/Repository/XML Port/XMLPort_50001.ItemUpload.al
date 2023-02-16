xmlport 50001 "Bulk Items Import"
{
    Direction = Import;
    //Encoding = UTF16;
    Format = VariableText;
    Permissions = TableData 5404 = rimd;
    TextEncoding = WINDOWS;


    schema
    {
        textelement(root)
        {
            tableelement(Item; Item)
            {
                AutoUpdate = false;
                XmlName = 'ItemS';
                UseTemporary = true;
                fieldelement(A; Item."No.")
                {
                }
                fieldelement(D; Item.Description)
                {
                    MinOccurs = Zero;
                }
                fieldelement(H; Item."Base Unit of Measure")
                {
                }
                fieldelement(J; Item."Inventory Posting Group")
                {
                    MinOccurs = Zero;
                }
                fieldelement(K; Item."Gen. Prod. Posting Group")
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord();
                begin
                    //Item."Costing Method":=Item."Costing Method"::Average;
                    IF NOT tgItem.GET(Item."No.") THEN
                        ItemNew(Item."No.")
                    ELSE
                        currXMLport.SKIP;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort();
    begin
        MESSAGE('Done');
    end;

    var
        tgItemUnitofMsr: Record "Item Unit of Measure";
        BrandText: Text[50];
        ColorText: Text[50];
        SizeText: Text[50];
        cha: Char;
        tgItem: Record item;
        VendorItemLen: Integer;
        petSkuConfig: Code[20];
        chkItem: Record Item;

    procedure ItemNew(No: Code[50]);
    var
        recItem: Record Item;
    begin
        IF NOT recItem.GET(Item."No.") THEN BEGIN
            recItem.INIT;
            recItem."No." := Item."No.";
            recItem."Base Unit of Measure" := Item."Base Unit of Measure";
            recItem."Inventory Posting Group" := Item."Inventory Posting Group";
            recItem."Sales Unit of Measure" := 'PCS';
            recItem."Purch. Unit of Measure" := 'PCS';
            recItem.Description := Item.Description;
            recItem."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
            recItem."Inventory Posting Group" := Item."Inventory Posting Group";
            recItem."Costing Method" := Item."Costing Method"::Average;
            recItem.INSERT;
        END;

        IF NOT tgItemUnitofMsr.GET(Item."No.", Item."Base Unit of Measure") THEN BEGIN
            tgItemUnitofMsr.INIT;
            tgItemUnitofMsr."Item No." := Item."No.";
            tgItemUnitofMsr.Code := 'PCS';
            tgItemUnitofMsr."Qty. per Unit of Measure" := 1;
            tgItemUnitofMsr.INSERT;
        END ELSE
            currXMLport.SKIP;

        COMMIT;
    end;
}

