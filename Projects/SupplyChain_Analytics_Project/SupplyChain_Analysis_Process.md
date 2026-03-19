# Supply Chain & Inventory Analytics Workflow

This directory contains the files for the **Supply Chain & Inventory Analytics** project.

## 1. Scenario
The Logistics Director needs visibility into supplier fulfillment metrics. We obtained raw shipment data (`Raw_SupplyChain_Data.csv`) exported from the Warehouse Management System (WMS). 

Common issues in the raw file:
- **Missing Costs**: Unit costs drop off during data transfer.
- **Inconsistent Delivery Logs**: Orders marked as "In Transit" or "Delayed" falsely registering delivery dates.
- **Discrepancies**: Variance between Quantity Ordered vs Quantity Received (Short shipments).

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We format supplier names and data types to prevent aggregation corruption.
- Null Unit Costs are replaced with `0` using `Table.ReplaceValue`.
- **Calculated Columns**:
  - `TotalValue`: Multiplies Unit Cost * Quantity Received.
  - `LeadTimeDays`: Natively calculated in M by subtracting Order Date from Delivery Date, **only** for Delivered items.
  - `ShortShipment`: A conditional text column flagging "Yes" if `QuantityReceived < QuantityOrdered`.

## 3. Formatting (VBA)
Using `CleanDataMacro.vba`:
- Applies a Navy Blue/Industrial styling (`#1e3a8a`) preferred for logistics management reporting.
- Flags problematic logistics data utilizing conditional row formatting:
  - Highlights `Delayed` statuses in bold Red font.
  - Flags short shipments by turning the `QuantityReceived` cell background bright yellow if it is less than the `QuantityOrdered`.

## 4. Power BI Data Modeling / DAX
To power the Dashboard, we created specific DAX measures to calculate supply chain efficiencies:
```dax
Total Inventory Value = SUMX('SupplyChain', 'SupplyChain'[QuantityReceived] * 'SupplyChain'[UnitCost])

Avg Lead Time (Days) = AVERAGE('SupplyChain'[LeadTimeDays])

Shortship Rate = DIVIDE(
    CALCULATE(COUNTROWS('SupplyChain'), 'SupplyChain'[ShortShipment] = "Yes"),
    CALCULATE(COUNTROWS('SupplyChain'), 'SupplyChain'[Status] = "Delivered")
)

On-Time Delivery Rate = DIVIDE(
    CALCULATE(COUNTROWS('SupplyChain'), 'SupplyChain'[LeadTimeDays] <= 15),
    CALCULATE(COUNTROWS('SupplyChain'), 'SupplyChain'[Status] = "Delivered")
)
```

## 5. Aesthetic Dashboard
Open `dashboard.html` in your browser. This custom interactive visualization matches premium BI aesthetics utilizing a corporate Navy Blue palette, showcasing Supplier Performance (Lead time vs Volume), Location-based Inventory Doughnut charts, and an interactive trend tracker for fulfillment times.
