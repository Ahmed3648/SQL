-- Total Cases vs Total Deaths
-- created two sub-tables: 1) location & new cases, 2) location & new deaths. Then I merged both tables based on location using inner join

create table #grouped_new_cases (
location varchar (100),
new_cases float)

insert into #grouped_new_cases
select location, sum(new_cases) as NEW
from dbo.cases
where continent is not null
group by location

select *
from #grouped_new_cases

create table #grouped_new_deaths (
location varchar (100),
new_deaths float)

insert into #grouped_new_deaths
select location, sum(cast(new_deaths as int)) as NEW_DEATHS
from dbo.deaths
where continent is not null
group by location

select #grouped_new_cases.location, #grouped_new_cases.new_cases, #grouped_new_deaths.new_deaths,
	round(#grouped_new_deaths.new_deaths/#grouped_new_cases.new_cases,4)*100  as Death_rate
from #grouped_new_cases
inner join #grouped_new_deaths on #grouped_new_cases.location = #grouped_new_deaths.location
where #grouped_new_deaths.new_deaths is not null
order by Death_rate

-- Death% & cases% out of population
-- Created additional table that show each country population
-- Used two inner joins to get new_cases and new_deaths data to join the with countires, then performed reuired calculations based on that.
create table #population (
location varchar (100),
population float)

insert into #population
select location, avg(population) as Total_population
from dbo.covid
where continent is not null
group by location

select #population.population, #grouped_new_cases.new_cases, #grouped_new_deaths.new_deaths,
	round(#grouped_new_cases.new_cases/#population.population,5) as Cases_percentage,
	round(#grouped_new_deaths.new_deaths/#population.population,5) as Death_Percentage
from #population
inner join #grouped_new_cases on #population.location = #grouped_new_cases.location
inner join #grouped_new_deaths on #population.location = #grouped_new_deaths.location
where #grouped_new_deaths.new_deaths is not null



