# Financial Performance Analytics Workflow

This directory contains the files for the **Financial Performance Dashboard** project.

## 1. Scenario
The finance team needs a unified view of Income vs Expenses across multiple departments. We obtained an unstructured export (`Raw_Financial_Data.csv`) exported from a legacy accounting system. 

Common issues in the raw file:
- **Date Formatting Errors**: Mix of `MM/DD/YYYY` and `YYYY-MM-DD`.
- **Accounting Typology Errors**: Some 'Income' entries were logged as negative numbers by mistake.
- **Null Fields**: Missing transaction amounts that break sum aggregations.
- **Duplicate Rows**: A system glitch causing identical transactions to post twice.

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We used `Table.Distinct` to eliminate the duplicated lines immediately.
- We handled the negative income error by applying a `Number.Abs` transformation across the Amount column, converting negatives to absolute positives.
- Null amounts were replaced with `0` utilizing `Table.ReplaceValue`, ensuring DAX measures don't fail.
- We natively calculated `Variance` directly in M (Budget vs Actuals) using an `if/then` clause depending on whether the record type was Income or Expense.

## 3. Formatting (VBA)
Using `CleanDataMacro.vba`:
- Automates formatting to a clean, readable financial statement utilizing an Emerald Green theme (`#10b981`).
- Implements conditional accounting syntax to highlight any remaining negative amounts in bold red for fast auditing.

## 4. Power BI Data Modeling / DAX
To power the Dashboard, we created specific DAX measures to split single-column aggregations:
```dax
Total Income = CALCULATE(SUM('Finance'[Amount]), 'Finance'[Type] = "Income")
Total Expenses = CALCULATE(SUM('Finance'[Amount]), 'Finance'[Type] = "Expense")

Net Profit = [Total Income] - [Total Expenses]

Margin % = DIVIDE([Net Profit], [Total Income], 0)

Budget Utilization = DIVIDE(
    [Total Expenses],
    CALCULATE(SUM('Finance'[Budget]), 'Finance'[Type] = "Expense")
)
```

## 5. Aesthetic Dashboard
Open `dashboard.html` in your browser. This custom interactive visualization matches the complex layout of the premium Power BI design reference, utilizing a dark green header, side-by-side grouped bar charts for Income vs Expense, an area chart for Net Profit trend, and a bottom row structured as a simulated Income Statement matrix.
