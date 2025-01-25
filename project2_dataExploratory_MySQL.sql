
select *
from dup_layoffs1
;

--select not null values;

select company, total_laid_off, percentage_laid_off
from dup_layoffs1
where total_laid_off is not null
order by total_laid_off desc
;

-- to find total employees using given data;

select company, total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off
from dup_layoffs1
;

select company, `date`, total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off as total_employee
from dup_layoffs1
where total_laid_off is not null
order by total_employee desc
;

select company, substring(`date` , 1,4) as `year`  , total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off as total_employee
from dup_layoffs1
where total_laid_off is not null
order by total_employee desc
;

select  max(total_laid_off)
from dup_layoffs1
;

select  min(total_laid_off)
from dup_layoffs1
;

select *
from dup_layoffs1
where percentage_laid_off = 1
;

select company, substring(`date` , 1,4) as `year`  , total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off as total_employee
from dup_layoffs1
where total_laid_off is not null and percentage_laid_off is not null
order by total_employee desc
;

--find total laid off less than 1000;

with cte_total_employee as 
(
select company, substring(`date` , 1,4) as year, total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off as total_employee
from dup_layoffs1
) 
select *
from cte_total_employee 
where total_employee < 1000
order by total_employee desc
;

with cte_total_employee1 as 
(
select company, substring(`date` , 1,4) as year, total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off as total_employee
from dup_layoffs1
) 
select *
from cte_total_employee1 
where total_employee < 1000 and percentage_laid_off = 1
order by company
;

with cte_total_employee2 as 
(
select company, substring(`date` , 1,4) as year, total_laid_off, percentage_laid_off,
total_laid_off div percentage_laid_off as total_employee
from dup_layoffs1
) 
select *, row_number () over (partition by company) as row_num
from cte_total_employee2 
where total_employee < 1000 and percentage_laid_off = 1
order by row_num desc
;

select Company, substring(`date` , 1,4) as `year`, 
substring(`date` , 6,2) as `month`,funds_raised_millions
from dup_layoffs1
order by funds_raised_millions desc
;

select *
from dup_layoffs1
where company = 'Netflix'
;
select country, sum(total_laid_off) as total
from dup_layoffs1
group by country
;

with CTE_no_laid_offs as
(
select country, sum(total_laid_off) as total
from dup_layoffs1
group by country
)
select country, total
from CTE_no_laid_offs
where total is null
;

select substring(`date`, 1,4) as `year`, sum(total_laid_off) as sum_laid_off
from dup_layoffs1
group by `year`
order by 2
;

select year(`date`), sum(total_laid_off)
from dup_layoffs1
group by year(`date`)
order by 2;

select country, sum(total_laid_off) as total
from dup_layoffs1
group by country
order by 2 desc; 

with cte_rolling_total_laid_off as
(
select substring(`date` , 1,7) as `month`, sum(total_laid_off) as sum_laid_off
from dup_layoffs1
where substring(`date` , 1,7) is not null
group by `month`
order by `month`
)
select `month` ,sum_laid_off, sum(sum_laid_off) over (order by `month`) as rolling_total
from cte_rolling_total_laid_off
;

select *
from dup_layoffs1
;

select company, sum(total_laid_off) 
from dup_layoffs1
where total_laid_off is not null
group by company
order by 2 desc
;

--companies that had more than one laid offs;


with cte_multiple_laid_company as
(
select company, total_laid_off, year (`date`) as YE,
row_number () over (partition by company) as row_num
from dup_layoffs1
where total_laid_off is not null
order by company 
)
select company,row_num
from cte_multiple_laid_company
where row_num >1
;


select company, year(`date`), sum(total_laid_off)
from dup_layoffs1
where total_laid_off is not null
group by company,year(`date`)
;

with cte_laid_off_order  as
(
select company, year(`date`) as years, sum(total_laid_off) as sum_laid_off
from dup_layoffs1
where total_laid_off is not null
group by company, year(`date`)
)
select *, 
dense_rank () over (partition by years order by sum_laid_off desc) as ranking
from cte_laid_off_order
where years is not null
;

with cte_laid_off_order  as
(
select company, year(`date`) as years, sum(total_laid_off) as sum_laid_off
from dup_layoffs1
where total_laid_off is not null
group by company, year(`date`)
) ,
cte_laid_off_ranking as 
(
select *, 
dense_rank () over (partition by years order by sum_laid_off desc) as ranking
from cte_laid_off_order
where years is not null
)
select * 
from cte_laid_off_ranking
where ranking <6
order by ranking
;












