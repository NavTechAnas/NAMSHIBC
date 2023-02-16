pageextension 50010 "Vendor Ledger Entries Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore("&Navigate")
        {
            action("&Transfer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Transfer...';
                Image = TransferFunds;
                Scope = Repeater;
                //ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Transfer entry to another company.';

                trigger OnAction()
                var
                    ICPaymentTransfer: Report "IC Payment Transfer";
                    VendLedgerEntry: Record "Vendor Ledger Entry";
                begin
                    VendLedgerEntry.RESET;
                    CurrPage.SETSELECTIONFILTER(VendLedgerEntry);

                    ICPaymentTransfer.SETTABLEVIEW(VendLedgerEntry);
                    ICPaymentTransfer.RUNMODAL;
                end;
            }
        }
    }

    var
        myInt: Integer;
}