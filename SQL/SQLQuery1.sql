select * from coviddeaths order by 3,4;

--select * from covidvaccines order by 3,4;

--Selecting data that are going to be used

 select location, date, total_cases, new_cases, total_deaths, population from coviddeaths order by 1,2;

 --Looking at Total cases vs Total Deaths

 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage from coviddeaths where location like '%state%' order by 1,2;

 --looking at total cases vs population
 
 select location, date, total_cases, population, (total_cases/population)*100 as Death_Percentage from coviddeaths where location like '%state%' order by 1,2;

 -- highesht Infection rate 

  select location, population, max(total_cases) as Infectioncount, max((total_cases/population)*100) as Death_Percentage from coviddeaths group by location, population order by Infectioncount desc;

  -- Highest death rate

  select location, max(cast(total_deaths as int)) as deathcount from coviddeaths WHERE continent is not null group by location order by deathcount desc;

--  

  select location, max(cast(total_deaths as int)) as deathcount from coviddeaths WHERE continent is null group by location order by deathcount desc;

  -- World
   select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/sum(new_cases))*100 as Death_Percentage from coviddeaths where continent is not null group by date order by 1,2;

      select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/sum(new_cases))*100 as Death_Percentage from coviddeaths where continent is not null order by 1,2;

-- looking at total population vs vaccinations

Select a.continent, a.location, a.date,a.population, b.new_vaccinations from coviddeaths a join covidvaccines b on a.location = b.location and a.date = b.date where a.continent is not null order by 2,3;

--
Select a.continent, a.location, a.date,a.population, b.new_vaccinations, SUM(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date ) as Total_vaccinated from coviddeaths a join covidvaccines b on a.location = b.location and a.date = b.date where a.continent is not null order by 2,3;

--
with vaccrate (continent, location, date, population, new_vaccinations, Total_vaccinated) as
(
Select a.continent, a.location, a.date,a.population, b.new_vaccinations, SUM(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date ) as Total_vaccinated from coviddeaths a join covidvaccines b on a.location = b.location and a.date = b.date where a.continent is not null 
)
select *, (Total_vaccinated/population)*100 as Vaccvspop from vaccrate

--temp table

create table vaccvspop
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Total_vaccinated numeric
)

insert into vaccvspop

Select a.continent, a.location, a.date,a.population, b.new_vaccinations, SUM(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date ) as Total_vaccinated from coviddeaths a join covidvaccines b on a.location = b.location and a.date = b.date where a.continent is not null 


select *, (Total_vaccinated/population)*100 as Vaccvspop from vaccvspop
 
 -- creating view
 create view percentpopulationvaccined as
 Select a.continent, a.location, a.date,a.population, b.new_vaccinations, SUM(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date ) as Total_vaccinated from coviddeaths a join covidvaccines b on a.location = b.location and a.date = b.date where a.continent is not null 
