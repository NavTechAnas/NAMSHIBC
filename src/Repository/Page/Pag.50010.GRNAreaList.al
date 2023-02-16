page 50010 "GRN Area List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    Permissions = TableData "Purch. Inv. Header" = rim,
                  TableData "Intercompany Manifest Line" = rimd;
    SourceTable = "Purch. Inv. Header";
    SourceTableView = WHERE("Area Code" = FILTER(''));

    layout
    {
        area(content)
        {
            group(Input)
            {
                field(AreaCode; AreaCode)
                {
                    ApplicationArea = All;
                    Caption = 'Area Code';
                    QuickEntry = false;

                    trigger OnValidate();
                    begin
                        IntercompanyArea.RESET;
                        IntercompanyArea.SETRANGE("Area Code", AreaCode);
                        IntercompanyArea.FINDFIRST;
                    end;
                }
                field(GRNNo; GRNNo)
                {
                    ApplicationArea = All;
                    AccessByPermission = TableData "Purch. Inv. Header" = RIMD;
                    Caption = 'GRN No.';

                    trigger OnValidate();
                    begin
                        IntercompanyArea.RESET;
                        IntercompanyArea.SETRANGE("Area Code", AreaCode);
                        IntercompanyArea.FINDFIRST;

                        PurchInvHeader.RESET;
                        PurchInvHeader.SETRANGE("Location Code", IntercompanyArea."Location Code");
                        PurchInvHeader.SETRANGE("No.", GRNNo);
                        PurchInvHeader.FINDFIRST;

                        IF PurchInvHeader."Area Code" <> '' THEN
                            ERROR('Area code already assigned');

                        PurchInvHeader."Area Code" := AreaCode;
                        PurchInvHeader."Scanned By" := USERID;
                        PurchInvHeader."Scanned DateTime" := CURRENTDATETIME;
                        PurchInvHeader.MODIFY;
                        GRNNo := '';
                        Counter += 1;
                        CurrPage.UPDATE;
                    end;
                }
                field("Count GRN"; Counter)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            repeater(Group)
            {
                field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Pay-to Name"; rec."Pay-to Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Area Code"; rec."Area Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PO_ShipmentNr; rec.PO_ShipmentNr)
                {
                    ApplicationArea = All;
                    Caption = 'Shipment No.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        AreaCode: Code[20];
        GRNNo: Code[20];
        IntercompanyArea: Record "Intercompany Area";
        PurchInvHeader: Record "Purch. Inv. Header";
        Counter: Integer;
}