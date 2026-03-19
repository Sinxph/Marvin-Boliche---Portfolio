# Healthcare Revenue Cycle Analytics Workflow

This directory contains the files for the **Healthcare Revenue Cycle Analytics** project.

## 1. Scenario
The hospital's billing department is struggling to track claim denials and Days in Accounts Receivable (AR). We obtained raw billing data (`Raw_Health_Data.csv`) exported from their Electronic Health Record (EHR) system. 

Common issues in the raw file:
- **Date Formatting Errors**: Mix of `MM/DD/YYYY` and `YYYY-MM-DD`.
- **Text Casing**: ` medicare ` instead of `Medicare`.
- **Duplicate Claims**: Claims submitted multiple times by error.
- **Null Fields**: Empty Billed amounts.

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We format payer names and denial reasons utilizing `Text.Proper(Text.Trim())` to ensure standard grouping.
- Null billed amounts are replaced with `0` using `Table.ReplaceValue` to prevent calculation errors.
- We natively calculate `DaysInAR` directly in M by subtracting the `ServiceDate` from the `CollectionDate` (or the Current Date for Unpaid claims).

## 3. Formatting (VBA)
Using `CleanDataMacro.vba`:
- Automates formatting to a clean, readable spreadsheet utilizing a Forest Green header scheme typical for medical facilities.
- Implements conditional formatting to explicitly turn **DENIED** claims bold red, and **PAID** claims green, for rapid audits.

## 4. Power BI Data Modeling / DAX
To power the final dashboard, the following core DAX measures were constructed:
```dax
Total Charges = SUM('Billing'[BilledAmount])
Total Collected = SUM('Billing'[CollectedAmount])

Collection Rate = DIVIDE([Total Collected], [Total Charges], 0)

Denial Rate = DIVIDE(
    CALCULATE(COUNTROWS('Billing'), 'Billing'[ClaimStatus] = "Denied"),
    COUNTROWS('Billing')
)
```

## 5. Aesthetic Dashboard
Open `dashboard.html` in your browser. This custom interactive visualization matches the complex layout of the premium Power BI design reference, utilizing teal headers, line-and-area composites for collections vs charges, and horizontal bar charts highlighting the primary reasons claims are denied.
