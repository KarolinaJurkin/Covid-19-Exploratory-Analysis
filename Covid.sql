-- Exploration of data

SELECT 
	Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
FROM 
	CovidDeaths
WHERE
	continent IS NOT NULL 
	AND location NOT LIKE '%income%'
	AND location NOT IN ('World', 'European Union', 'South Africa') -- Ensures only countries are selected in Location field
ORDER BY 
	1, 2

-- Total Cases vs Total Deaths
-- Shows Case Fatality Rate in the world

SELECT 
	Location, Date, Total_Cases, Total_Deaths, 
	(total_deaths/total_cases)*100 Case_Fatality_Rate
FROM 
	CovidDeaths
WHERE 
	continent IS NOT NULL 
	AND location NOT LIKE '%income%'
	AND location NOT IN ('World', 'European Union', 'South Africa')
ORDER BY 
	1, 2

-- Total Cases vs Population
-- Shows what percentege of population got infected with Covid in in the world 
-- (numbers are underestimated as it considers only reported cases)

SELECT 
	Location, Date, Population, Total_Cases, 
	(total_cases/population)*100 Infection_Rate
FROM 
	CovidDeaths
WHERE 
	continent IS NOT NULL 
	AND location NOT LIKE '%income%'
	AND location NOT IN ('World', 'European Union', 'South Africa')
ORDER BY 
	1, 2

-- Shows what countries have the highest infection rate

SELECT 
	Location, Population, 
	MAX(total_cases) Total_Cases_Overall, 
	MAX((total_cases/population)*100) Infection_Rate
FROM 
	CovidDeaths
WHERE	
	continent IS NOT NULL 
	AND location NOT LIKE '%income%'
	AND location NOT IN ('World', 'European Union', 'South Africa')
GROUP BY 
	location, population
ORDER BY 
	4 DESC

-- Shows countries with highest Crude Mortality Rate 

SELECT 
	Location, Population, MAX(total_deaths) Total_Deaths, 
	MAX((total_deaths)/population)*100 Crude_Mortality_Rate
FROM 
	CovidDeaths
WHERE
	continent IS NOT NULL 
	AND location NOT LIKE '%income%'
	AND location NOT IN ('World', 'European Union', 'South Africa') 
GROUP BY 
	location, population
ORDER BY 
	4 DESC

-- Death Count by Continent

SELECT 
	Location, MAX(total_deaths) Death_Count
FROM 
	CovidDeaths
WHERE
	continent IS NULL 
	AND location NOT IN ('World', 'European Union')
	AND location NOT LIKE '%income%'
GROUP BY 
	location
ORDER BY 
	2 DESC

-- Sorts Continents by the highest CMR

SELECT 
	Location, Population, 
	(MAX(total_deaths)/population)*100 Crude_Mortality_Rate
FROM 
	CovidDeaths
WHERE
	continent IS NULL 
	AND location NOT IN ('World', 'European Union')
	AND location NOT LIKE '%income%'
GROUP BY 
	location, population
ORDER BY 
	3 DESC

-- Global numbers by date

SELECT 
	date, SUM(new_cases) new_cases_worldwide, 
	SUM(new_deaths) new_deaths_worldwide,
	SUM(total_cases) total_cases_worldwide, 
	SUM(total_deaths) total_deaths_worldwide
FROM 
	CovidDeaths
WHERE
	continent IS NOT NULL 
	AND location NOT IN ('World', 'European Union', 'South Africa')
	AND location NOT LIKE '%income%'
GROUP BY 
	date
ORDER BY 
	1

-- Summary of Total Cases and Deaths in the World

SELECT 
	Location,
	MAX(Total_Cases) Total_Cases,
	MAX(Total_Deaths) Total_Deaths
FROM 
	CovidDeaths
WHERE
	Location = 'World'
GROUP BY 
	Location

-- Joining tables

SELECT *
FROM 
	CovidDeaths dea
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Shows Total Population vs Vaccinations

SELECT
	dea.continent, dea.location, dea.date,
	dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations as bigint)) 
	OVER (PARTITION BY dea.location ORDER BY dea.date) total_vaccinations_to_date
FROM
	CovidDeaths dea 
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL  
	AND dea.location NOT IN ('World', 'European Union', 'South Africa')
	AND dea.location NOT LIKE '%income%'
ORDER BY 
	2, 3

-- Shows the difference between total number of vaccinations and people actually vaccinated

SELECT
	dea.Continent, dea.Location, dea.Date,
	dea.Population, vac.New_Vaccinations,
	SUM(CAST(vac.new_vaccinations as bigint)) 
	OVER (PARTITION BY dea.location ORDER BY dea.date) Total_Vaccinations_to_Date,
	vac.People_Vaccinated
FROM
	CovidDeaths dea 
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL 
	AND dea.location NOT IN ('World', 'European Union', 'South Africa')
	AND dea.location NOT LIKE '%income%'

-- Shows Summary of Vaccinations vs CRF and CMR

SELECT 
	dea.Location, dea.Population, 
	MAX(cast (vac.people_vaccinated as int)/population)*100 Percentage_of_Population_Vaccinated,
	(SUM(dea.new_deaths)/SUM(dea.new_cases))*100 Case_Fatality_Rate,
	SUM(dea.new_deaths/population)*100 Crude_Mortality_Rate
FROM 
	CovidDeaths dea
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL 
	AND dea.location NOT IN ('World', 'European Union', 'South Africa')
	AND dea.location NOT LIKE '%income%'
	AND dea.total_cases IS NOT NULL
GROUP BY
	dea.location, dea.population
ORDER BY
	3 DESC

-- Tests per Capita vs New Cases per Capita 
-- Creating CTE to look at a rate of positive tests

WITH TestsvsCases AS
(
SELECT 
	dea.Location, dea.Population, 
	MAX(cast (vac.total_tests as float)/dea.population) Tests_per_Capita,
	SUM((dea.new_cases)/dea.population) New_Cases_per_Capita
FROM 
	CovidDeaths dea
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL 
	AND dea.location NOT IN ('World', 'European Union', 'South Africa')
	AND dea.location NOT LIKE '%income%'
	AND dea.total_cases IS NOT NULL
GROUP BY
	dea.location, dea.population
)
SELECT 
	*,
	(New_Cases_per_Capita/Tests_per_Capita)*100 Percentage_of_Positive_Tests
FROM 
	TestsvsCases
ORDER BY
	3 DESC

-- Creating Views for later visualizations

-- 1. Infection Rate in different countries

CREATE VIEW CountriesInfectionRate AS
SELECT 
	Location, Population, 
	MAX(total_cases) Total_Cases_Overall, 
	MAX((total_cases/population)*100) Infection_Rate
FROM 
	CovidDeaths
WHERE	
	continent IS NOT NULL 
	AND location NOT LIKE '%income%'
	AND location NOT IN ('World', 'European Union', 'South Africa')
GROUP BY 
	location, population


-- 2. Summary of vaccinations vs CFR and CMR in different countries

CREATE VIEW SummaryVaccinationsvsPopulation AS
SELECT 
	dea.Location, dea.Population, 
	MAX(cast (vac.people_vaccinated as int)/population)*100 Percentage_of_Population_Vaccinated,
	(SUM(dea.new_deaths)/SUM(dea.new_cases))*100 Case_Fatality_Rate,
	SUM(dea.new_deaths/population)*100 Crude_Mortality_Rate
FROM 
	CovidDeaths dea
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL 
	AND dea.location NOT IN ('World', 'European Union', 'South Africa')
	AND dea.location NOT LIKE '%income%'
	AND dea.total_cases IS NOT NULL
GROUP BY
	dea.location, dea.population

--3. Tests per Capita vs New Cases per Capita in different countries

CREATE VIEW TestsvsCases AS
WITH TestsvCases AS
(
SELECT 
	dea.Location, dea.Population, 
	MAX(cast (vac.total_tests as float)/dea.population) Tests_per_Capita,
	SUM((dea.new_cases)/dea.population) New_Cases_per_Capita
FROM 
	CovidDeaths dea
	JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL 
	AND dea.location NOT IN ('World', 'European Union', 'South Africa')
	AND dea.location NOT LIKE '%income%'
	AND dea.total_cases IS NOT NULL
GROUP BY
	dea.location, dea.population
)
SELECT 
	*,
	(New_Cases_per_Capita/Tests_per_Capita)*100 Percentage_of_Positive_Tests
FROM 
	TestsvCases