# Customer Support Analytics Workflow

This directory supports the **Customer Support & Helpdesk Analytics** project, tracking agent efficiency and customer satisfaction.

## 1. Context
The customer success team needs to track operational volume and ticketing SLA metrics. We obtained a raw extract (`Raw_Support_Data.csv`) simulating a Zendesk or Jira Service Desk dump.

Issues to resolve:
- **Missing Feedback**: Closed tickets arbitrarily missing CSAT scores due to users ignoring the automated email surveys.
- **Negative Resolution Times**: Calculation bugs originating when timezone conversions misfire during daylight savings adjustments.
- **Inconsistent Capitalization**: Manual tag entry creating variations like `BILLING` vs `Billing`.

## 2. Power Query Data Cleaning (M Code)
Using `PowerQuery_M_Code.m`:
- We used boolean logic to conditionally inject a baseline CSAT (`3`) only if the ticket was explicitly marked as Closed, preventing null aggregation crashes.
- Fixed negative resolution times utilizing `Number.Abs`.
- Normalized strings across priority and category bands natively.

## 3. Power BI JSON Theme
Implemented `PowerBI_Theme.json`, which governs a warm amber & red operational dashboard theme typically mapped to real-time service environments.

## 4. Power BI Data Modeling / DAX
```dax
Total Tickets = COUNTROWS('Support')
Open Tickets = CALCULATE(COUNTROWS('Support'), 'Support'[IsClosed] = "No")
Closed Tickets = CALCULATE(COUNTROWS('Support'), 'Support'[IsClosed] = "Yes")

Avg Resolution Time (Hrs) = AVERAGE('Support'[ResolutionTimeHrs])
Avg CSAT Score = AVERAGE('Support'[CSAT_Score])

CSAT % (Top 2 Boxes) = DIVIDE(
    CALCULATE(COUNTROWS('Support'), 'Support'[CSAT_Score] >= 4),
    [Closed Tickets]
)
```

## 5. Aesthetic Dashboard Mock
Open `dashboard.html`. The UI perfectly replicates a high-urgency Service Desk wallboard:
- Live KPI status counters indicating queue pressure.
- Bar charts slicing ticket creation by Category.
- A horizontal ranking chart illustrating Agent Performance (Tickets closed vs Avg CSAT).
