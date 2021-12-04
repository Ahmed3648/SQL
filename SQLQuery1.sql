-- Total Cases vs Total Deaths
select Location, date, new_cases, cast(new_deaths as float) as New_Deaths, 
concat(round(((cast(total_deaths as float) / total_cases) *100),2), '%') as DeathPercentage
from dbo.covid
where location like '%Bahrain%' and continent is not null
order by 2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid each day
select location, date, population, new_cases,
concat(round(((new_cases / population) *100),2), '%') as InfectionPercentage
from dbo.covid
where location like '%bahrain%' and continent is not null
order by date


-- Countries with Highest Infection Rate compared to Population at their highest new cases date
select location, max(new_cases) as MaxCases, concat(max(new_cases/population)*100, '%') as NewCasesPercentage,
from dbo.covid
group by location 
order by NewCasesPercentage desc

-- Countries with Highest Death Count per Population
select location, max(population) as population, max(total_deaths) as Total_deaths, concat(max(Total_deaths/population)*100, '%') as TotalDeathsPercentage
from dbo.covid
where continent is not null
group by location 
order by TotalDeathsPercentage desc

-- Showing contintents with the highest death count
select continent, sum(cast(new_deaths as int)) as Deaths
from dbo.covid
where continent is not null
group by continent
order by Deaths desc


-- Showing contintents with the highest death count compared to population
with CTE_covid as (select location, continent, avg(population) as location_pop, sum(cast(new_deaths as int)) as New_Deaths
from dbo.covid group by location, continent)
select continent, sum(location_pop) as continent_population, sum(New_Deaths) as Total_Deaths, 
concat(round((sum(New_Deaths)/sum(location_pop)*100),2),'%') as Percentage
from CTE_covid
where continent is not null
group by continent
order by 2 desc


-- Shows Percentage of Population that has recieved at least one Covid Vaccine
select location, max(population) as Populaion, max(cast(people_vaccinated as int)) as People_vaccinated,
concat(round(((max(cast(people_vaccinated as int))/max(population))*100),2),'%') as Percentage_vaccincated
from dbo.covid
where continent is not null
group by location
order by round(((max(cast(people_vaccinated as int))/max(population))*100),2) desc


-- Shows Percentage of Population that has recieved Booster Vaccine
select location, max(population) as Populaion, max(cast(total_boosters as int)) as People_vaccinated,
concat(round(((max(cast(total_boosters as int))/max(population))*100),2),'%') as Percentage_vaccinated
from dbo.covid
where continent is not null
group by location
order by round(((max(cast(total_boosters as int))/max(population))*100),2) desc



