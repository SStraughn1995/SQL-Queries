#identify duplicate records
select 
	  count(*)
      , country
      , year
from
	world_life_expectancy
group by 
	  country
      , year
having count(*)>1;

#find the row numbers for duplicate records
select 
	  country
      , year
      , row_id
from 
	world_life_expectancy
where 
	country in ('Ireland','Senegal','Zimbabwe') 
		AND year in (2022,2009,2019)
;

#remove duplicate records from data
delete from 
	world_life_expectancy
where 
	row_id in (1252,2265,2929);

#find null values in 'Status'
select 
	*
from 
	world_life_expectancy
where 
	status = ''
;

select 
	distinct(country)
from 
	world_life_expectancy
where 
	status = 'Developing'
;

#update blank statuses in developing countries
update 
	world_life_expectancy t1
join 
	world_life_expectancy t2
		on t1.country=t2.country
set 
	t1.status = 'Developing'
		where 
			t1.status=''
			and t2.status<>''
			and t2.status='Developing'
;

#update blank statuses in developed countries
update 
	world_life_expectancy t1
join 
	world_life_expectancy t2
		on t1.country=t2.country
set 
	t1.status = 'Developed'
		where t1.status=''
			and t2.status<>''
			and t2.status='Developed'
;

select 
	  country
      , year
      , `life expectancy`
from 
	world_life_expectancy
where 
	`life expectancy`='';

#find average life expectancy for afghanistan and albania in 2017 and 2019 to calculate an average for 2018
select t1.country, t1.year, t1.`life expectancy`,
	t2.country, t2.year, t2.`life expectancy`,
    t3.country, t3.year, t3.`life expectancy`,
    round((t2.`life expectancy` + t3.`life expectancy`)/2,1)
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.country=t2.country
    and t1.year=t2.year-1
join world_life_expectancy t3
	on t1.country=t3.country
    and t1.year=t3.year+1
where t1.`life expectancy`=''
;

# update table to include average life expectancy calculated above
update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country=t2.country`world_life_expectancy`
    and t1.year=t2.year-1
join world_life_expectancy t3
	on t1.country=t3.country
    and t1.year=t3.year+1
set t1.`life expectancy`= round((t2.`life expectancy` + t3.`life expectancy`)/2,1)
where t1.`life expectancy` = '';