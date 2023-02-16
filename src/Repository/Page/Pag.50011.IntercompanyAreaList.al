page 50011 "Intercompany Area List"
{
    ApplicationArea = All;
    Caption = 'Intercompany Area List';
    PageType = List;
    SourceTable = "Intercompany Area";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Area Code"; Rec."Area Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
