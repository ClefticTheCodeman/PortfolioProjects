Select * from PortfolioProject..CovidDeaths;


Select Location, date, total_cases,new_cases,total_deaths,population 
from PortfolioProject..coviddeaths 
order by 1,2;


-- looking at the total cases vs total death percentage
--Likelihood of dying if you contract covid in your country;
Select Location, date, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS 'Death Percentage'
from PortfolioProject..coviddeaths 
Where location like '%states%'
order by 1,2                                  

-- Total cases vs population
-- Shows the population of people who got covid

Select Location, date,population,total_cases,(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 AS 'Death Percentage'
from PortfolioProject..coviddeaths 
Where location like '%states%'
order by 1,2


-- Looking at countries with highest infection rate compared to population


Select Location, population,MAX(total_cases) AS 'highest infectionCount', MAX(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 AS 'Death Percentage'
from PortfolioProject..coviddeaths   
--Where location like '%states%'
Where continent is not null
Group by Location, population, total_cases
order by 'Death Percentage' Desc
																																																																								Select Location, date, total_cases,total_deaths,Population (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS 'Death Percentage'
																																																																								from PortfolioProject..coviddeaths 
-- Looking at the total death cases of the population

Select Location, date, population,MAX(total_deaths) AS 'Total Death', MAX(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, population), 0))*100 AS 'Death Percentage'
from PortfolioProject..coviddeaths 
Where location like '%Nigeria%'
Group by Location, date, population, total_cases
order by 1,2																																																														order by 1,2

-





Select Location, population,MAX(total_cases) AS 'highest infectionCount', MAX(CONVERT(float, total_cases) / (CONVERT(float, population))*100) AS DeathPercentage
from PortfolioProject..coviddeaths 
Where location like '%states%'
Group by Location, population, total_cases
order by 1,2



select location, 
MAX(cast(total_deaths as int)) As percentageDeaths
from PortfolioProject..coviddeaths
where location is not null
Group by location
order by percentageDeaths desc





-- Showing the continents with higest death count.


select Continent, Max(total_deaths) AS TotaldeathsInContinents, Max(cast(total_deaths as int)) AS '%OfTotalDeaths',
MAX(continent) As ContinentDeathCount
from PortfolioProject..coviddeaths
where continent is not null
Group by continent
order by 1,2


-- Global Numbers 





select date, sum(new_deaths) as totaldeaths, sum(cast(new_deaths as int)) / sum(new_cases) * 100
from PortfolioProject..coviddeaths
--where continent is not null
Group by date
order by 1,2



select dea.continent, count(dea.continent) from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac on dea.location = vac.location
where dea.continent = 'oceania' OR dea.continent ='Africa' OR dea.continent ='North America'
group by dea.continent


select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated, 
--(RollingpeopleVaccination/Population)
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT null
order by 2,3


-- USING A CTE TABLE

with PopVsVac ( continent, Location, Date, Population,new_vaccinations, RolingPeoplevaccinated)
As (
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated 
--(RollingpeopleVaccination/Population)
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT null
--order by 2,3
)
Select * ,Floor(RAND()*(RolingPeoplevaccinated/Population)) * 100
from popvsvac


-- USING TEMP TABLE
Drop Table if exists #percentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated

(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated
--with PopVsVac ( continent, Location, Date, Population,new_vaccinations, RolingPeoplevaccinated)
--As (
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated 
--(RollingpeopleVaccination/Population)
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT null
--order by 2,3
--)
Select *, Floor(RAND()*(RollingPeoplevaccinated/Population)) * 100
from #PercentPopulationVaccinated




--- Creating views to store data later for visualization


DROP View if exists PercentPopulationVaccinated
Create view PercentPopulationVaccinated as 
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS RollingPeopleVaccinated 
--(RollingpeopleVaccination/Population)
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT null
--order by 2,3
--)

Select * from PercentPopulationVaccinated










