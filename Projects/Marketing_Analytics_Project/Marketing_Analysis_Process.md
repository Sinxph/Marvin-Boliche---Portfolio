# Marketing Campaign Performance Workflow

This directory contains the files for the **Marketing Campaign Performance** project.

## 1. Scenario
The CMO wants to track Return on Ad Spend (ROAS) and campaign performance metrics. We obtained an unstructured export (`Raw_Marketing_Data.csv`) aggregated from various ad platforms (Google Ads, Meta, native emails). 

Common issues in the raw file:
- **Missing Spend**: Platform API timeouts resulted in missing spend values for a few campaigns.
- **Inconsistent Capitalization**: 'Social Media' vs ' social media '.
- **Raw Metrics Only**: The file only contains Impressions, Clicks, and Conversions. It lacks critical calculated ratios like CTR (Click-Through Rate) and CVR (Conversion Rate).

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We used `Table.ReplaceValue` to replace null Spend values with `0` so we don't encounter errors when summing total marketing expenditures.
- We used `Text.Proper(Text.Trim())` to normalize Channel values.
- **Calculated Columns**: Natively built `CTR` (Clicks/Impressions) and `CVR` (Conversions/Clicks) directly in the Power Query M Editor using conditional division (`if [Impressions] > 0 then...`).

## 3. Formatting (VBA)
Using `CleanDataMacro.vba`:
- Formats the dataset into a vibrant Orange heading (`#f97316`) representing a bold marketing aesthetic.
- Highlights `Active` campaigns in bold Green and greys out `Paused` campaigns, enabling campaign managers to instantly filter priority rows visually.

## 4. Power BI Data Modeling / DAX
To power the Dashboard, we created specific DAX measures to calculate performance efficiencies:
```dax
Total Spend = SUM('Marketing'[SpendAmount])
Total Conversions = SUM('Marketing'[Conversions])

Cost Per Click (CPC) = DIVIDE([Total Spend], SUM('Marketing'[Clicks]), 0)

Cost Per Acquisition (CPA) = DIVIDE([Total Spend], [Total Conversions], 0)
```

## 5. Aesthetic Dashboard
Open `dashboard.html` in your browser. This custom interactive visualization matches premium BI aesthetics utilizing a bright orange accent palette, showcasing Spend vs Conversions over time, Channel breakdown Doughnut charts, and an Audience performance matrix.
