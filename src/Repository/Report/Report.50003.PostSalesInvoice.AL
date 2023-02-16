report 50003 "Post Sales Invoice JOB"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'Post Sales JOB';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = WHERE("Document Type" = filter(Invoice | "Credit Memo"),
                                Status = FILTER(Released),
                                "Retry Count" = filter(0));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Counter > SalesSetup."Sales Posting Threshold" then
                    CurrReport.Break();

                if NOT SalesPost.Run("Sales Header") then begin
                    "Sales Header"."Error Message" := copystr(GetLastErrorText(), 1, 100);
                    "Sales Header"."Retry Count" += 10;
                    "Sales Header".Modify();
                end;
                Counter += 1;
            end;
        }
    }

    trigger OnPreReport()
    begin
        SalesSetup.Get();
    end;

    var
        SalesBatchPost: Codeunit "Sales Batch Post Mgt.";
        SalesPost: Codeunit "Sales-Post";
        SalesSetup: Record "Sales & Receivables Setup";
        Counter: Integer;
}