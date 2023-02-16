pageextension 50001 "Item List Ext" extends "Item List"
{

    actions
    {
        addafter(Availability)
        {
            action(ImportItems)
            {
                Caption = 'Import Items';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Xmlport.Run(50001, false, true);
                    Message('Imported Sucessfully!!');
                end;
            }
        }
    }

    var
        myInt: Integer;
}