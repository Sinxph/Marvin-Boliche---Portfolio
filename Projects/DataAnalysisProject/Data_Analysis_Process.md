# Data Analysis Process: End-to-End Workflow

This document outlines the step-by-step process used to perform data analysis, modeling, cleaning, transformation, and visualization using Excel (VBA/Power Query) and Power BI. 

---

## 1. The Scenario & Sample Data

We begin with an imperfect sales dataset (`Raw_Sales_Data.csv`). Real-world data is rarely clean; this dataset contains intentional errors:
- **Missing Values**: Null revenues and missing customer names.
- **Inconsistent Text**: Categories ("electronics" vs "Electronics") and Regions (" north " vs "North").
- **Date Formatting**: Mixed date formats (MM/DD/YY vs YYYY-MM-DD).
- **Duplicates**: Order ID 1002 appears twice.
- **Logic Errors**: Negative quantities.

---

## 2. Data Cleaning & Transformation (Power Query)

Power Query is the most efficient tool for cleaning data in Excel and Power BI. We use "M Code" to transform the raw CSV.

### Steps Taken in Power Query:
1. **Load Data**: Imported the raw CSV file.
2. **Promote Headers**: Set the first row as the table header.
3. **Data Typing**: Assigned correct data types (Dates, Whole Numbers, Text, Decimal).
4. **Remove Duplicates**: Filtered out matching rows to keep data unique.
5. **Text Cleaning**: Applied `Text.Trim` to remove leading/trailing spaces and `Text.Proper` to capitalize the first letter of every word.
6. **Conditional Logic (Imputing Missing Data)**: For rows where Revenue was missing, we calculated it using a custom column formula: `Quantity * UnitPrice`.
7. **Filtering Errors**: Removed rows where `Quantity < 0`.

*(The exact M-Code used for this transformation is provided in `PowerQuery_M_Code.m`)*

---

## 3. Formatting Data in Excel (VBA Macro)

Before or after the Power Query transformation, analysts often need to present the data in Excel. We use a VBA Macro to automate cell formatting so it is instantly readable by stakeholders.

### VBA Automations:
- **Freeze Panes**: Locked the top row so headers remain visible when scrolling.
- **Header Styling**: Changed font to bold, background to blue, and text to white.
- **AutoFit Columns**: Automatically adjusted all columns to show full text.
- **Number Formatting**: Formatted currency columns to `$#,##0.00`.
- **Borders**: Added continuous borders around the dataset.

*(The VBA script is provided in `CleanDataMacro.vba`. To use it in Excel: `Alt + F11` > Insert Module > Paste code > Run.)*

---

## 4. Data Modeling (Power BI)

Once the data is cleaned in Power Query, it is loaded into the Data Model. For advanced analysis, we define relationships and write DAX (Data Analysis Expressions).

### Standard Modeling Steps:
1. **Star Schema**: In a larger project, we would split our single table into a Fact Table (`Fact_Sales`) and Dimension Tables (`Dim_Customers`, `Dim_Products`). 
2. **Key DAX Measures**:
   To build dynamic visual dashboards, we write explicit measures instead of relying on implicit summations.

   ```dax
   // Total Revenue Measure
   Total Revenue = SUM(Sales[Revenue])

   // Total Orders Measure
   Total Orders = DISTINCTCOUNT(Sales[OrderID])

   // Average Order Value (AOV)
   AOV = DIVIDE([Total Revenue], [Total Orders], 0)
   ```

---

## 5. Visualization (Dashboarding)

We translated the Data Model into a **Dashboard**.
In this project folder, I have created `dashboard.html`. This file leverages **Chart.js** to programmatically recreate the experience of a Power BI dashboard.

### Dashboard Key Features:
- **KPI Cards**: Instantly show top-level metrics (Total Revenue, Total Orders, AOV).
- **Bar Chart (Revenue by Category)**: Compares performance across categories (Electronics, Furniture, etc.).
- **Doughnut Chart (Revenue by Region)**: Shows the distribution of sales geographically.
- **Interactive UI**: Includes hover states, dark mode styling, and dynamic animations representing a modern BI interface.

## Next Steps for the User:
1. Open the `Raw_Sales_Data.csv` to see the dirty data.
2. Review the `PowerQuery_M_Code.m` to see how the mathematical/textual transformations happen.
3. Open `dashboard.html` in your web browser to view the final transformed data presented beautifully!
