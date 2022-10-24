/*

Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From portfolioproject.dbo.CovidDeath$
where continent is not null
Order by 3,4

--Select *
--From portfolioproject.dbo.CovidVaccinations$
--Order by 3,4

--select Dat that I am going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolioproject.dbo.CovidDeath$
where continent is not null
order by 1,2

--I will be looking at Total cases vs Total deaths
--shows the likelihood of dying contacting Covid 19 in a aprticular country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as  Deathpercentage
From portfolioproject.dbo.CovidDeath$
where location like '%Canada%'
and continent is not null
order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population have tested positive for covid 19

Select Location, date, population, total_cases, total_deaths, population, (total_cases/population)*100 as PercentagePopulationInfected
From portfolioproject.dbo.CovidDeath$
where location like '%Canada%'
and continent is not null
order by 1,2

--Looking at countries  with highest infection rate compared to population 

Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From portfolioproject.dbo.CovidDeath$
--where location like '%Canada%'
where continent is not null
Group by Location, Population
order by PercentagePopulationInfected desc

--Showing the countries with the highest Death Count per population


Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject.dbo.CovidDeath$
--where location like '%Canada%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--I want to break things down by continent now

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject.dbo.CovidDeath$
--where location like '%Canada%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing the continent with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject.dbo.CovidDeath$
--where location like '%Canada%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast (new_deaths as int)) as total_deaths,  SUM(cast(new_deaths as int))/SUM (New_Cases)*100  Deathpercentage
From portfolioproject.dbo.CovidDeath$
--where location like '%Canada%'
where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast (new_deaths as int)) as total_deaths,  SUM(cast(new_deaths as int))/SUM (New_Cases)*100  Deathpercentage
From portfolioproject.dbo.CovidDeath$
--where location like '%Canada%'
where continent is not null
--Group by date
order by 1,2
   

   --COVID VACCINATION

   --Looking at Total population  Vs Vaccinations

   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
  dea.Date) as RollingpeopleVaccinated
  --, (RollingpeopleVaccinated/population)*100
   From portfolioproject.dbo.CovidDeath$ dea
   Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

	
	--USE CTE
	with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
	as
	(
	 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
  dea.Date) as RollingpeopleVaccinated
  --, (RollingpeopleVaccinated/population)*100
   From portfolioproject..CovidDeath$ dea
   Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	)
	select *, (RollingpeopleVaccinated/population)*100
	from PopvsVac


	--	TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingpeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
  dea.Date) as RollingpeopleVaccinated
  --, (RollingpeopleVaccinated/population)*100
   From portfolioproject.dbo.CovidDeath$ dea
   Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

	select *, (RollingpeopleVaccinated/population)*100
	from #PercentPopulationVaccinated


	--Creating view to store data for later visualizations


	Create View PercentPopulationVaccinated as
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
  dea.Date) as RollingpeopleVaccinated
  --, (RollingpeopleVaccinated/population)*100
   From portfolioproject.dbo.CovidDeath$ dea
   Join PortfolioProject..CovidVaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3


select *
From PercentPopulationVaccinated



















