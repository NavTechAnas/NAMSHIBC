enum 50005 "Return QC Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; " ") { Caption = ' '; }
    value(1; "Pass") { Caption = 'Pass'; }
    value(2; "Fail") { Caption = 'Fail'; }
    value(3; "NotReceived") { Caption = 'NotReceived'; }
    value(4; "Mislabelled") { Caption = 'Mislabelled'; }
}