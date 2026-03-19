# HR Employee Attrition Analytics Workflow

This directory contains the files for the **HR Employee Attrition Analytics** project.

## 1. Scenario
The HR department wants to analyze employee turnover (attrition). We obtained dirty data (`Raw_HR_Data.csv`) exported from a legacy HR system. Errors include:
- Missing Salaries.
- Mixed capitalization in 'Department' (`R&D` vs `r&d`).
- Mixed formatting in 'Gender' (`M` vs `Male`).

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We clean `Department` and `Gender` values by trimming whitespace and normalizing cases.
- Missing Salaries are imputed with a baseline average of $60,000 using `Table.ReplaceValue`.
- We calculate employee **Tenure** natively in M by finding the difference between `HireDate` and `TerminationDate` (or Current Date for active employees).

## 3. Formatting (VBA)
Using `CleanDataMacro.vba`:
- Applies a professional purple theme customized for the HR department.
- Uses a macro conditional formatting loop to highlight `Yes` in the Attrition column in bold red font so HR reps can spot turnover instantly down the raw sheet.

## 4. Power BI Data Modeling / DAX
In the data model, we build DAX measures to feed our interactive dashboard:
```dax
Employee Headcount = CALCULATE(COUNTROWS('HR Data'), 'HR Data'[Attrition] = "No")
Attrition Rate = DIVIDE(
    CALCULATE(COUNTROWS('HR Data'), 'HR Data'[Attrition] = "Yes"),
    COUNTROWS('HR Data')
)
```

## 5. Aesthetic Dashboard
Open `dashboard.html` in your browser. This custom interactive visualization matches the complex layout of premium Power BI designs, utilizing top KPI indicators and categorical deep dives (stacked bars, doughnut charts) tailored for HR Attrition analytics.
