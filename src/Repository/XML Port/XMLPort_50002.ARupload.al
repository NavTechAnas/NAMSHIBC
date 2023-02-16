xmlport 50096 "Import AR File"
{
    // version Avin Gtfs

    Direction = Import;
    Format = VariableText;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'GenJournalLine';
                fieldelement(A; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement(A1; "Gen. Journal Line"."Document Date")
                {
                }
                textelement(lineno)
                {
                    MinOccurs = Zero;
                    XmlName = 'B';
                }
                fieldelement(C; "Gen. Journal Line"."Document Type")
                {
                    MinOccurs = Zero;
                }
                fieldelement(D; "Gen. Journal Line"."Document No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(E; "Gen. Journal Line"."AWB No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(F; "Gen. Journal Line"."External Document No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(G; "Gen. Journal Line"."Account Type")
                {
                    MinOccurs = Zero;
                }
                fieldelement(H; "Gen. Journal Line"."Account No.")
                {
                    MinOccurs = Zero;
                }
                fieldelement(I; "Gen. Journal Line".Description)
                {
                    MinOccurs = Zero;
                }
                fieldelement(J; "Gen. Journal Line"."Currency Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(K; "Gen. Journal Line".Amount)
                {
                }
                fieldelement(L; "Gen. Journal Line"."Amount (LCY)")
                {
                }
                fieldelement(M; "Gen. Journal Line"."Debit Amount")
                {
                    MinOccurs = Zero;
                }
                fieldelement(N; "Gen. Journal Line"."Credit Amount")
                {
                    MinOccurs = Zero;
                }
                fieldelement(O; "Gen. Journal Line"."Bal. Account Type")
                {
                    MinOccurs = Zero;
                }
                fieldelement(P; "Gen. Journal Line"."Bal. Account No.")
                {
                    MinOccurs = Zero;

                    trigger OnAfterAssignField();
                    begin
                        "Gen. Journal Line"."Journal Template Name" := 'AR-CRCTN';
                        IF Type = Type::Prepaid THEN
                            "Gen. Journal Line"."Journal Batch Name" := 'AR-PREPAID';
                        IF Type = Type::Postpaid THEN
                            "Gen. Journal Line"."Journal Batch Name" := 'AR-COD';
                        /*
                        GenJnlLineNew.RESET;
                        GenJnlLineNew.SETRANGE("Journal Template Name","Gen. Journal Line"."Journal Template Name");
                        GenJnlLineNew.SETRANGE("Journal Batch Name","Gen. Journal Line"."Journal Batch Name");
                        IF GenJnlLineNew.FINDLAST THEN
                          LineNoRec := GenJnlLineNew."Line No." + 10;
                        IF LineNoRec <> 0 THEN
                          LineNo := FORMAT(LineNoRec);
                        */
                        EVALUATE("Gen. Journal Line"."Line No.", LineNo);
                        /*
                        IF Type = Type::Postpaid THEN BEGIN
                          IF ("Gen. Journal Line"."Bal. Account Type" = "Gen. Journal Line"."Bal. Account Type"::Customer) AND ("Gen. Journal Line"."Bal. Account No." <> '') THEN BEGIN
                            CustLedgerEntry.RESET;
                            CustLedgerEntry.SETCURRENTKEY("Posting Date","Customer No.","Document Type","External Document No.","Remaining Amount");
                            CustLedgerEntry.SETRANGE("Customer No.","Gen. Journal Line"."Bal. Account No.");
                            //CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Manifest);//DXB
                            CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice); //KSA
                            CustLedgerEntry.SETRANGE("External Document No.","Gen. Journal Line"."External Document No.");
                            CustLedgerEntry.CALCFIELDS("Remaining Amount");
                            CustLedgerEntry.SETFILTER("Remaining Amount",'>=%1',"Gen. Journal Line".Amount);
                            IF CustLedgerEntry.FINDFIRST THEN BEGIN
                              IF "Gen. Journal Line"."Posting Date" >= CustLedgerEntry."Posting Date" THEN BEGIN
                                //"Gen. Journal Line"."Applies-to Doc. Type" := "Gen. Journal Line"."Applies-to Doc. Type"::Manifest; //DXB
                                "Gen. Journal Line"."Applies-to Doc. Type" := "Gen. Journal Line"."Applies-to Doc. Type"::Invoice; // KSA
                                "Gen. Journal Line".VALIDATE("Applies-to Doc. No.",CustLedgerEntry."Document No.");
                              END ELSE BEGIN
                                "Gen. Journal Line"."Applies-to Doc. Type" := "Gen. Journal Line"."Applies-to Doc. Type"::" ";
                                "Gen. Journal Line"."Applies-to Doc. No." := '';
                              END;
                            END;
                            IF "Gen. Journal Line"."Applies-to Doc. No." = '' THEN BEGIN
                              CustLedgerEntry.RESET;
                              CustLedgerEntry.SETCURRENTKEY("Posting Date","Customer No.","Document Type","External Document No.","Remaining Amount");
                              CustLedgerEntry.SETRANGE("Customer No.","Gen. Journal Line"."Bal. Account No.");
                              //CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Manifest);// DXB
                              CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice); // KSA
                              CustLedgerEntry.SETRANGE("External Document No.","Gen. Journal Line"."External Document No.");
                              CustLedgerEntry.CALCFIELDS("Remaining Amount");
                              CustLedgerEntry.SETFILTER("Remaining Amount",'<>%1',0);
                              IF CustLedgerEntry.FINDFIRST THEN BEGIN
                                IF "Gen. Journal Line"."Posting Date" >= CustLedgerEntry."Posting Date" THEN BEGIN
                                //  "Gen. Journal Line"."Applies-to Doc. Type" := "Gen. Journal Line"."Applies-to Doc. Type"::Manifest;// DXB
                                  "Gen. Journal Line"."Applies-to Doc. Type" := "Gen. Journal Line"."Applies-to Doc. Type"::Invoice; //KSA
                                  "Gen. Journal Line".VALIDATE("Applies-to Doc. No.",CustLedgerEntry."Document No.");
                                END ELSE BEGIN
                                  "Gen. Journal Line"."Applies-to Doc. Type" := "Gen. Journal Line"."Applies-to Doc. Type"::" ";
                                  "Gen. Journal Line"."Applies-to Doc. No." := '';
                                END;
                              END;
                            END;
                          END;
                        END;
                        */
                        IF ("Gen. Journal Line"."Credit Amount" < 0) OR ("Gen. Journal Line"."Debit Amount" < 0) THEN
                            ERROR('The amount fields cannot be negative');

                        RowNo += 1;
                        Window.UPDATE(1, 'Importing......' + ' ' + FORMAT(RowNo));

                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Type; Type)
                {
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort();
    begin
        Window.CLOSE;
        MESSAGE('Imported.');
    end;

    trigger OnPreXmlPort();
    begin
        IF Type = Type::" " THEN
            ERROR('Type Should not be blank.');

        Window.OPEN('#1#################');
    end;

    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Window: Dialog;
        RowNo: Integer;
        Type: Option " ",Prepaid,Postpaid;
        GenJnlLine: Record "Gen. Journal Line";
        LineNoRec: Integer;
}

