-- Exploring Countries with their population, total cases, total deaths, total vaccinations, infected percentage, death percentage and vaccinated percentage

SELECT d.continent, d.location, d.population, SUM(v.new_vaccinations) AS TotalVaccinations,  SUM(d.new_cases) AS TotalCases , SUM(d.new_deaths) AS TotalDeaths, 
ROUND(SUM(v.new_vaccinations)/d.population*100,2) AS PopulationVaccinatedPercentage , ROUND(SUM(d.new_cases)/d.population*100,2) AS InfectedPercentage, 
ROUND(SUM(d.new_deaths)/SUM(d.new_cases)*100,2) AS DeathPercentage
FROM coviddeaths d
JOIN covidvaccinations v 
ON d.location = v.location 
AND d.date = v.date 
WHERE d.continent <> ""
GROUP BY d.location
ORDER BY TotalCases DESC;


-- Total population, cases, deaths and vaccinations in each continent. 

WITH CTE (continent, population, totalvaccinations, totalcases, totaldeaths ) AS
(SELECT d.continent, d.population, SUM(v.new_vaccinations), SUM(d.new_cases), SUM(d.new_deaths)
FROM coviddeaths d
JOIN covidvaccinations v 
ON d.location = v.location 
AND d.date = v.date 
WHERE d.continent <> ""
GROUP BY d.location
ORDER BY continent)

SELECT Continent, SUM(population) AS TotalPopulation, SUM(totalvaccinations) AS TotalVaccinations, SUM(totalcases) AS TotalCases, SUM(totaldeaths) AS TotalDeath 
FROM CTE
GROUP BY continent;


-- Exploring daily and cummulative deaths, cases and vaccinations in each country.

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS CummulativeVaccinations,  
d.new_Cases, SUM(new_cases ) OVER (PARTITION BY location ORDER BY location, date) AS CummulativeCases,  
d.new_deaths , SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS CummulativeDeaths
FROM coviddeaths d
JOIN covidvaccinations v 
ON d.location = v.location 
AND d.date = v.date 
WHERE d.continent <> ""
ORDER BY continent,  location, date;


-- Global death, cases and vaccinations.

SELECT d.TotalCases AS TotalCases, d.TotalDeaths AS TotalDeaths, v.TotalVaccinations AS TotalVaccinations 
FROM (SELECT sum(new_cases) AS TotalCases, sum(new_Deaths) AS TotalDeaths FROM coviddeaths WHERE continent <> "")d 
JOIN (SELECT sum(new_vaccinations) AS TotalVaccinations FROM covidvaccinations WHERE continent <> "")v;


-- Exploring population, total vaccinations, total cases, total deaths, percentage of population vaccinated, percentage of population infected, and percentage of cases resulting in death in India

SELECT d.location, d.population, SUM(v.new_vaccinations) AS TotalVaccinations,  SUM(d.new_cases) AS TotalCases , SUM(d.new_deaths) AS TotalDeaths, 
ROUND(SUM(v.new_vaccinations)/d.population*100,2) AS PopulationVaccinatedPercentage , ROUND(SUM(d.new_cases)/d.population*100,2) AS InfectedPercentage, 
ROUND(SUM(d.new_deaths)/SUM(d.new_cases)*100,2) AS DeathPercentage
FROM coviddeaths d
JOIN covidvaccinations v 
ON d.location = v.location 
AND d.date = v.date 
WHERE d.location = 'india'
GROUP BY d.location;


-- Exploring daily and cummulative cases, deaths and vaccinations in India 

SELECT d.location, d.date, d.population, v.new_vaccinations, SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location, date) AS CummulativeVaccinations, 
d.new_Cases, SUM(new_cases ) OVER (PARTITION BY location ORDER BY location, date) AS CummulativeCases,
d.new_deaths , SUM(new_deaths) OVER (PARTITION BY location ORDER BY location, date) AS CummulativeDeaths
FROM coviddeaths d
JOIN covidvaccinations v 
ON d.location = v.location 
AND d.date = v.date 
WHERE d.location = 'India'
ORDER BY d.date;


-- Countries with Highest Death Count 

SELECT Location, MAX(Total_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE continent <> ""
GROUP BY Location
ORDER BY TotalDeathCount DESC;



