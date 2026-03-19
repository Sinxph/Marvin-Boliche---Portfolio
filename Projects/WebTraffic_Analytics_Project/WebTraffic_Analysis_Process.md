# Web Traffic Analytics Workflow

This directory supports the **Web Traffic Analytics** project, tracking session acquisition down to purchase conversion matching standard GA4 (Google Analytics) exports.

## 1. Context
The digital team relies on analyzing the relationship between Traffic Acquisition and E-commerce Revenue. We obtained a raw extract (`Raw_Web_Data.csv`).

Issues to resolve:
- **Null Revenue Bugs**: Some entries registered purchases but the revenue variable returned null from tracking blockers.
- **Negative Sessions**: Faulty mobile offline-sync events generated negative session bounds.
- **Text Formatting**: Mixing cases (`smart tv` vs `Desktop`, `email` vs `Email`).

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- Forced strict title casing via `Text.Proper(Text.Trim(_))` on Channels and Devices.
- Filled null revenue to `$0` utilizing `Table.ReplaceValue`.
- Handled negative sessions using `Number.Abs`.
- Created custom calculation bounds for `ConversionRate` (Purchases/Sessions) and `ARPU` (Average Revenue Per User).

## 3. Power BI JSON Theme
Provided `PowerBI_Theme.json` which governs the Power BI Desktop file with specific visual JSON rules, applying the exact Teal, Purple, and Blue hex codes modeled off the dashboard.

## 4. Power BI Data Modeling / DAX
```dax
Total Users = SUM('WebTraffic'[TotalUsers])
New Users = SUM('WebTraffic'[NewUsers])
Sessions = SUM('WebTraffic'[Sessions])
Purchases = SUM('WebTraffic'[Purchases])
Revenue = SUM('WebTraffic'[Revenue])

Conversion Rate = DIVIDE([Purchases], [Sessions], 0)
```

## 5. Aesthetic Dashboard Mock
Open `dashboard.html`. The UI perfectly replicates an all-in-one generic web analytics view:
- Top Header KPIs showcasing numbers using dynamic gradients (Purple, Blue, Teal, Green, Pink).
- Complex layered grid housing dual-axis line charts and stacked area channel analysis directly mimicking standard professional views.
