
Use bank_marketing;

-- Q1: Overall conversion rate

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN deposit = 'yes' THEN 1 ELSE 0 END) AS yes_count,
    ROUND(sum(CASE WHEN deposit = 'yes' THEN 1 ELSE 0 END)*100 / count(*), 2) AS conversion_pct
FROM bank;

-- Q2: Job wise conversion rate with rank

With job_state as (
     select job,
            count(*) as total_customers,
            sum( case when deposit = 'yes' then 1 else 0 end) as yes_count
     from bank
     Group by job
)

  select job, total_customers, yes_count,
         round(yes_count * 100/ total_customers, 2) as conversion_pct,
         rank() over (order by yes_count* 1.0 / total_customers desc) as conversion_rank
 from job_state
 order by conversion_rank;
 
 -- Q3: Conversion by age group and education

SELECT
    age_group,
    education,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN deposit = 'yes' THEN 1 ELSE 0 END) AS yes_count,
    ROUND(SUM(CASE WHEN deposit = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS conversion_pct
FROM bank
GROUP BY age_group, education
ORDER BY age_group, education;

-- Q4: Conversion by number of calls

with call_buckets as (
     select campaign, deposit,
          case
               when campaign = 1 then '1 call'
               when campaign = 2 then '2 calls'
               when campaign = 3 then '3 calls'
               when campaign between 4 and 5 then '4-5'
               when campaign between 6 and 10 then '6-10'
               else '10+'
          end as call_group
     from bank
)

select call_group, count(*) as total_customers,
      sum(case when deposit='yes' then 1 else 0 end) as yes_count,
	 ROUND(SUM(CASE WHEN deposit = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS conversion_pct
from call_buckets
group by call_group
order by min(campaign);  

-- Q5: Top 3 months by conversion rate

with month_stats as (
    select month, count(*) as total_customers,
		   sum(case when deposit = 'yes' then 1 else 0 end) as yes_count
    from bank
    group by month
),

ranked as (
    select month, total_customers, yes_count, 
    round(yes_count*100.0/ total_customers ,2) as conversion_pct,
    rank() over( order by yes_count * 1.0/ total_customers desc) as month_rank
    from month_stats
)

select * from ranked where month_rank <=3;  

-- Q6: Conversion by previous campaign outcome

select poutcome, count(*) as total_customers,
      sum(case when deposit = 'yes' then 1 else 0 end) as yes_count, 
      ROUND(SUM(CASE WHEN deposit = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS conversion_pct
from bank
group by poutcome
order by conversion_pct desc;  

-- Q7: Yes vs No, average duration and balance

select deposit, count(*) as total_customers,
	   round(avg(duration),2) as avg_duration,
       round(avg(balance), 2) as avg_balance
from bank
group by deposit ; 