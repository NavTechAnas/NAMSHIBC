report 50100 "RSW Utilities"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        cuICPosting: Codeunit "InterCompany Posting";
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object ID to Run", 50001);
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Parameter String", 'Create IC PI');
        JobQueueEntry.FindFirst();
        cuICPosting.Run(JobQueueEntry);
    end;
}