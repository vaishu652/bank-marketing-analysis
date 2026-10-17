# Term Deposit Campaign Analysis: Sundaram Trust Bank

> **Practice project** using the public [Bank Marketing Dataset](https://www.kaggle.com/datasets/janiobachmann/bank-marketing-dataset) from Kaggle. The client (Sundaram Trust Bank, Meera Iyer, Head of Marketing) is fictional and was created to simulate a real freelance brief.

## Business Problem

The bank ran a phone campaign to sell term deposits. Many calls were made, but it was unclear **who signed up and who did not**. The goal: find which customers to call next time, so the marketing team saves time and money.

**Data:** 11,162 customers, 17 columns (age, job, marital status, education, balance, contact type, call duration, number of calls, previous campaign outcome, and whether the customer opened a term deposit).

## Tools and Workflow

```
Google Sheets  ->  MySQL  ->  Power BI
(clean + groups)  (analysis)  (dashboard)
```

| Phase | Tool | What I did |
|---|---|---|
| 1. Data prep | Google Sheets | Checked duplicates, blanks, "unknown" values and `pdays = -1`; documented every decision in a Data Quality Log; added `age_group` and `balance_group` columns |
| 2. Analysis | MySQL | Wrote 7 queries using GROUP BY, CASE WHEN, CTEs, RANK() window function and AVG |
| 3. Dashboard | Power BI | Built a 3-page dashboard with KPI cards, charts, slicers and written insights |

## Data Quality Summary

| Check | Result | Decision |
|---|---|---|
| Duplicate rows | 0 | No action |
| Blank cells | 0 | No action |
| `job` unknown | 70 (0.6%) | Kept as a category |
| `education` unknown | 497 (4.5%) | Kept as a category |
| `contact` unknown | 2,344 (21.0%) | Kept as a category (removing would lose 1 in 5 customers) |
| `poutcome` unknown | 8,326 (74.6%) | Kept; means the customer was not part of an earlier campaign |
| `pdays = -1` | 8,326 | Means "not contacted before"; excluded when averaging `pdays` |

## SQL Analysis

All queries are in [`sql/bank_marketing_queries.sql`](sql/bank_marketing_queries.sql).

| # | Question | Techniques |
|---|---|---|
| 1 | Overall conversion rate | COUNT, SUM, CASE WHEN |
| 2 | Conversion by job, ranked | CTE, GROUP BY, RANK() |
| 3 | Conversion by age group and education | GROUP BY on two columns |
| 4 | Conversion by number of calls | CTE, CASE WHEN buckets |
| 5 | Top 3 months by conversion | Two CTEs, RANK(), filter on rank |
| 6 | Conversion by previous campaign outcome | GROUP BY |
| 7 | Average call duration and balance, yes vs no | AVG, GROUP BY |

## Dashboard

**Page 1: Overview**
![Overview](screenshots/page1_overview.png)

**Page 2: Who Converts**
![Who Converts](screenshots/page2_who_converts.png)

**Page 3: Campaign Efficiency**
![Campaign Efficiency](screenshots/page3_campaign_efficiency.png)

Slicers for age group, month and job work across the dashboard.

## Key Insights

1. **Some segments convert far better.** Students and retired customers convert at 69% (1,138 customers) and customers aged 61+ at 82.2% (611 customers), vs 47.4% overall.
2. **Past success predicts success.** Customers who said yes in the previous campaign convert at 91.3% (1,071 customers), vs 40.7% for those never contacted before (8,326).
3. **More calls, lower returns.** Conversion falls from 53.4% on the first call to 22.4% after 10+ calls. Of 210 customers called 10+ times, only 47 signed.
4. **Some months look strong, but volume is small.** December (91%), March (90%) and September (84%) lead, but each had only 110 to 319 customers.
5. **Customer profile matters.** Single customers convert at 54.3% vs 43.4% for married, and tertiary-educated at 54.1% vs 39.4% for primary. Customers who signed had a higher average balance (1,804 vs 1,280).

## Recommendations

1. **Build the call list by priority:** previous-success customers first, then students, retired and 61+ customers, then single and tertiary-educated customers.
2. **Cap calls at 3 per customer.** Conversion drops below 40% after the 3rd call, so extra calls add cost with little return.
3. **Pilot a larger campaign in March, September and December** before scaling, and track whether the high rates hold at higher volume.

## Limitations

- These are patterns in past data, not proof of cause.
- Some groups are small (for example, December has only 110 customers), so their rates may not hold at higher volume.
- Call duration is only known after the call, so it was used to describe customers, not to target them.

## Repository Structure

```
bank-marketing-analysis/
|-- README.md
|-- sql/
|   |-- bank_marketing_queries.sql
|-- dashboard/
|   |-- Bank_Marketing.pbix
|-- screenshots/
|   |-- page1_overview.png
|   |-- page2_who_converts.png
|   |-- page3_campaign_efficiency.png
```

## Author

**Vaishnavi M**, Data Analyst (fresher), Bengaluru, India
GitHub: [github.com/vaishu652](https://github.com/vaishu652)
