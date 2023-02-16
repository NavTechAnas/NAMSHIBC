codeunit 50000 EventSubscripton
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckExternalDocumentNumber', '', true, true)]

    local procedure OnBeforeCheckExternalDocumentNumber(DocType: Option; ExtDocNo: Text[35]; GenJnlLineDocNo: Code[20];
    GenJnlLineDocType: Enum "Gen. Journal Document Type"; PurchaseHeader: Record "Purchase Header"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var Handled: Boolean; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCheckPurchExtDocNoProcedure', '', true, true)]
    local procedure OnBeforeCheckPurchExtDocNoProcedure(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    var
        myInt: Integer;
}