# E-Commerce Marketing Funnel Workflow

This directory supports the **Shopify Marketing Funnel** project, translating top-of-funnel ad spend into bottom-of-funnel customer acquisition.

## 1. Context
The performance marketing cohort requires deep visibility into Shopify checkout conversions matched against direct ad spends across multiple platforms (Facebook Ads, Google Ads, TikTok). The extract `Raw_Ecom_Data.csv` simulates this API ingestion.

Issues to resolve:
- **Null Spend Entries**: Occasional API failures from Ad networks resulting in missing week logs.
- **Negative Revenue**: Buggy store refund ingestion resulting in negative net revenues instead of separate lines.
- **Case Inconsistency**: Manual platform tags entered arbitrarily (e.g. ` tiktok `).

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- Forced strict title casing via `Text.Proper(Text.Trim(_))` on AdPlatform.
- Handled negative revenues seamlessly with `Number.Abs`.
- Filled null `AmountSpend` with 0 to repair missing DAX sum values.
- Established primary funnel calculated bounds natively: `CTR` (Clicks/Impressions), `ROI`, and `CostPerOrder`.

## 3. Power BI JSON Theme
Provided `PowerBI_Theme.json`, which sets the distinct array of purples, blue variants, greens, and pinks found in advanced e-commerce analytics models. Providing this predetermines the colors of every visual rendering from this dataset.

## 4. Power BI Data Modeling / DAX
```dax
Total Spend = SUM('Ecom'[AmountSpend])
Total Revenue = SUM('Ecom'[Revenue])
Total Orders = SUM('Ecom'[Orders])

Overall ROI = DIVIDE([Total Revenue] - [Total Spend], [Total Spend], 0)
Avg Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
Ad Cost per Order = DIVIDE([Total Spend], [Total Orders], 0)
```

## 5. Aesthetic Dashboard Mock
Open `dashboard.html`. The UI perfectly replicates the Shopify funnel layout:
- Colored KPI cards at the top tracking top-line efficiency.
- Dual-axis line charts parsing Spend vs Revenue and Orders vs AOV.
- A distinctive visual "Acquisition Funnel" representing Impressions -> Clicks -> Users -> Customers.
- A highly detailed conditional matrix grid tabulating standard row-by-row marketing performance over time.
