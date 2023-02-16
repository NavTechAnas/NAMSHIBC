enum 50000 "HSBC Payment Type"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; " ") { Caption = ' '; }
    value(1; "Priority") { Caption = 'Priority'; }
    value(2; "ACH") { Caption = 'ACH'; }
}