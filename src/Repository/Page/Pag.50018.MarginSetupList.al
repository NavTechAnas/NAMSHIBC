page 50018 "Margin Setup List"
{
    PageType = List;
    SourceTable = "Margin Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; rec."Location Code")
                {
                }
                field("Effective Date"; rec."Effective Date")
                {
                }
                field("Margin Type"; rec."Margin Type")
                {
                }
                field(Code; rec.Code)
                {
                }
                field("Margin %"; rec."Margin %")
                {
                }
                field("Overhead %"; rec."Overhead %")
                {
                }
                field("Freight %"; rec."Freight %")
                {
                }
            }
        }
    }
}

