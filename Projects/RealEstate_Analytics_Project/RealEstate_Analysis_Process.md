# Real Estate Property Management Analytics Workflow

This directory supports the **Real Estate Portfolio Analytics** project, tracking occupancy, tenant churn, and net yields across a multi-city property portfolio.

## 1. Context
The property management firm requires tracking unit capacity vs operating income. We obtained a raw extract (`Raw_RealEstate_Data.csv`) aggregating properties in Texas.

Issues to resolve:
- **Null Rent Entries**: Vacant units missing base rent configurations, reading as nulls.
- **Negative Maintenance Contracts**: Contract credit reimbursements artificially creating negative maintenance bounds.
- **String Parsing Errors**: Human-entered property types generating duplicates like ` apartment ` vs `Apartment`.

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- Imposed `Text.Proper(Text.Trim(_))` on property types.
- Fixed null base rents to `0` using `ReplaceValue`.
- Converted negative reimbursements to absolute expenses to avoid artificially inflating yield computations.
- Added DAX-precursors: `RentPerSqFt` and `NetMonthlyIncome`.

## 3. Power BI JSON Theme
Implemented `PowerBI_Theme.json`, instilling a sophisticated Teal & Amber aesthetic representing a mature, professional real-estate firm interface.

## 4. Power BI Data Modeling / DAX
```dax
Total Properties = COUNTROWS('Properties')
Occupied Units = CALCULATE([Total Properties], 'Properties'[IsOccupied] = "Yes")
Occupancy Rate = DIVIDE([Occupied Units], [Total Properties], 0)

Total Rental Yield = SUM('Properties'[MonthlyRent])
Total Maintenance = SUM('Properties'[MaintenanceCosts])
Net Operating Income = [Total Rental Yield] - [Total Maintenance]
```

## 5. Aesthetic Dashboard Mock
Open `dashboard.html`. The UI provides:
- Top-line portfolio summary KPIs (Occupancy Rate, Net Income, Churn Risk).
- A stacked bar delineating occupancy thresholds by City.
- A scatter plot correlating Square Footage against Premium Rent values.
