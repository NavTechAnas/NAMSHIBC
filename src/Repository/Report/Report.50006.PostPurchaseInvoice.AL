report 50006 "Post Purchase Invoice JOB"
{
    ProcessingOnly = true;
    ShowPrintStatus = false;
    //UseRequestPage = false;
    Caption = 'Post Purchase Invoice JOB';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = WHERE("Document Type" = filter(Invoice | "Credit Memo"),
                                Status = FILTER(Released),
                                "Retry Count" = filter(0));

            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Counter > PurchSetup."Purchase Posting Threshold" then
                    CurrReport.Break();

                if NOT PurchPost.Run("Purchase Header") then begin
                    "Purchase Header"."Error Message" := copystr(GetLastErrorText(), 1, 100);
                    "Purchase Header"."Retry Count" += 10;
                    "Purchase Header".Modify();
                end;
                Counter += 1;
            end;
        }
    }

    trigger OnPreReport()
    begin
        PurchSetup.Get();
    end;

    var
        PurchPost: Codeunit "Purch.-Post";
        PurchSetup: Record "Purchases & Payables Setup";
        Counter: Integer;
}