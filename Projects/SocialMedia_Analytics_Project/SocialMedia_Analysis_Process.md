# Social Media Analytics Workflow

This directory supports the **Social Media Analytics** project, replicating a top-tier multi-platform web dashboard.

## 1. Context
The digital marketing team tracks cross-platform brand performance (Facebook, Instagram, LinkedIn, YouTube) combined with bottom-of-funnel website analytics. A daily raw export (`Raw_Social_Data.csv`) is generated.

Issues to resolve:
- **Null Revenue**: Certain posts don't track revenue, leaving blanks that break aggregations.
- **Negative Impressions**: Data extraction bugs resulting in negative reach bounds.
- **Uncalculated Rates**: Engagement rates and Session acquisition data aren't natively provided by the raw export.

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We format platform names strictly (`Text.Proper`).
- Handled negative impressions using `Number.Abs`.
- Filled null revenue to `$0`.
- Built custom `EngagementRate` and `SessionEngRate` formulas.

## 3. Power BI JSON Theme
The `PowerBI_Theme.json` is a new addition to ensure all visualizations loaded into standard desktop environments default strictly to the dashboard's blue/indigo corporate palette (e.g., `#3b82f6` and `#8b5cf6`).

## 4. Power BI Data Modeling / DAX
```dax
Total Impressions = SUM('Social'[Impressions])
Total Engagements = SUM('Social'[Engagements])

Avg Engagement Rate = DIVIDE([Total Engagements], [Total Impressions], 0)

Platform Reach % = DIVIDE(
    SUM('Social'[Reach]),
    CALCULATE(SUM('Social'[Reach]), ALL('Social'[Platform]))
)
```

## 5. Aesthetic Dashboard Mock
Open `dashboard.html`. The UI perfectly replicates an all-in-one social analytics framework showing:
- Left KPI Bar: Total Users, Purchases, Revenue, Sessions.
- Web Traffic trendline below KPIs.
- 4 individualized Platform panels (Facebook, Instagram, LinkedIn, YouTube) providing dedicated tabular data layered above sparkline area charts.
