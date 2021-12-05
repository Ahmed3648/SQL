-- Total Cases vs Total Deaths
--with CTE_deaths as (select location, sum(cast(new_deaths as int)) as new_deaths from dbo.deaths where continent is not null group by location)
--select dbo.cases.location, sum(new_cases) 
--from dbo.cases
--group by dbo.cases.location
--inner join CTE_deaths on dbo.cases.location = CTE_deaths.location;

create table #grouped_new_cases (
location varchar (100),
new_cases int
)

insert into #grouped_new_cases
select location, sum(new_cases) as NEW
from dbo.cases
group by location


create table #grouped_new_deaths (
location varchar (100),
new_deaths int
)

insert into #grouped_new_deaths
select location, sum(cast(new_deaths as int)) as NEW_DEATHS
from dbo.deaths
group by location


select #grouped_new_cases.location, #grouped_new_cases.new_cases, #grouped_new_deaths.new_deaths
from #grouped_new_cases
inner join #grouped_new_deaths on #grouped_new_cases.location = #grouped_new_deaths.location
order by #grouped_new_cases.new_cases desc

