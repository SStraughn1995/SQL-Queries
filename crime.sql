select
	  year
    , sum(rape)
    , sum(population)
    , sum(rape)/sum(population)*100 as rape_rate
from
	crime
where
	year in ('1975','2016') AND jurisdiction = 'Baltimore City'
group by
	year
order by
	year
;

select
	  year
	, sum(rape)as total_rape
from
	crime
group by
	year
;

select
	  *
	, lag(total_rape) over (order by year) as previous_year
    , (lag(total_rape) over (order by year) - total_rape) as YoY_rape
    , ((total_rape-lag(total_rape) over (order by year))/lag(total_rape) over (order by year))*100 as percent_change
from (select
	  year
	, sum(rape)as total_rape
from
	crime
group by
	year) as lag_table
order by
	percent_change desc;
    
    
select
	  year
	, sum(murder)as total_murder
from
	crime
group by
	year
;

select
	  *
	, lag(total_murder) over (order by year) as previous_year
    , (lag(total_murder) over (order by year) - total_murder) as YoY_rape
    , round(((total_murder-lag(total_murder) over (order by year))/lag(total_murder) over (order by year))*100,2) as percent_change
from (select
	  year
	, sum(murder)as total_murder
from
	crime
group by
	year) as lag_table
order by
	percent_change desc;
    
select
	*
from
	crime
;

select
	  jurisdiction
	, sum(murder)
    , sum(rape)
    , sum(robbery)
    , sum(`agg. assault`)
    , sum(`B & E`)
    , sum(`larceny theft`)
    , sum(`m/v theft`)
from
	crime
group by
	jurisdiction
;

select distinct jurisdiction from crime;

update crime
set jurisdiction = 'Allegany County'
where jurisdiction = 'Allegany County '

update crime
set jurisdiction = 'Anne Arundel County'
where jurisdiction = 'Anne Arundel County '
;

select
	  jurisdiction
	, year
    , sum(murder)
    , lag(sum(murder)) over (order by year) as previous_year
    , round(if(((sum(murder) - lag(sum(murder)) over (order by year))/lag(sum(murder)) over (order by year))*100 IS NULL, 0, ((sum(murder) - lag(sum(murder)) over (order by year))/lag(sum(murder)) over (order by year))*100),0) as percent_change
from
	crime
where
	jurisdiction = 'Allegany County'
group by
	  jurisdiction
	, year
;

select
	  jurisdiction
	, avg(percent_change)
from
	(select
		  jurisdiction
		, year
		, sum(murder)
		, lag(sum(murder)) over (order by year) as previous_year
		, round(if(((sum(murder) - lag(sum(murder)) over (order by year))/lag(sum(murder)) over (order by year))*100 IS NULL, 0, ((sum(murder) - lag(sum(murder)) over (order by year))/lag(sum(murder)) over (order by year))*100),0) as percent_change
	from
		crime
	where
		jurisdiction = 'Allegany County'
	group by
		  jurisdiction
		, year) as pct_chng_tbl
group by
	jurisdiction
;


select
	  jurisdiction
	, year
    , sum(murder)
    , lag(sum(murder)) over (partition by jurisdiction order by year) as previous_year
    , round(if(((sum(murder) - lag(sum(murder)) over (partition by jurisdiction order by year))/lag(sum(murder)) over (order by year))*100 IS NULL, 0, ((sum(murder) - lag(sum(murder)) over (partition by jurisdiction order by year))/lag(sum(murder)) over (partition by jurisdiction order by year))*100),0) as percent_change
from
	crime
group by
	  jurisdiction
	, year
order by
	  jurisdiction
	, year
;

select
	  jurisdiction
	, avg(percent_change)
from
	(select
	  jurisdiction
	, year
    , sum(murder)
    , lag(sum(murder)) over (partition by jurisdiction order by year) as previous_year
    , round(if(((sum(murder) - lag(sum(murder)) over (partition by jurisdiction order by year))/lag(sum(murder)) over (order by year))*100 IS NULL, 0, ((sum(murder) - lag(sum(murder)) over (partition by jurisdiction order by year))/lag(sum(murder)) over (partition by jurisdiction order by year))*100),0) as percent_change
	from
		crime
	group by
		  jurisdiction
		, year
	order by
		  jurisdiction
	, year) as pct_cng_tbl
group by
	jurisdiction
order by
	avg(percent_change) desc;

select
	  jurisdiction
	, year
    , sum(murder)
    , lag(sum(murder)) over (partition by jurisdiction order by year) as 1975_murders
    , (sum(murder) - lag(sum(murder)) over (partition by jurisdiction order by year))/(lag(sum(murder)) over (partition by jurisdiction order by year))*100 as percent_change
from
	crime
where
	year in (1975, 2016)
group by
	  jurisdiction
	, year
;

select
	  jurisdiction
	, percent_change as 'Percent Change from 1975 to 2016'
from (select
	  jurisdiction
	, year
    , sum(murder)
    , lag(sum(murder)) over (partition by jurisdiction order by year) as previous_year
    , (sum(murder) - lag(sum(murder)) over (partition by jurisdiction order by year))/(lag(sum(murder)) over (partition by jurisdiction order by year))*100 as percent_change
	from
		crime
	where
		year in (1975, 2016)
	group by
		  jurisdiction
		, year) as 1975_pct_cng_tbl
where
	percent_change is not null
order by
	percent_change desc
;