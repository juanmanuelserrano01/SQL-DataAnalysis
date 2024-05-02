SELECT *
FROM CovidDeaths
WHERE continent is not null
ORDER BY 3, 4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY location, date

-- Total Cases vs Total Death
-- Probability of death for contracting COVID in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PorcentOfDeathForCases
FROM CovidDeaths
WHERE location = 'Argentina'
ORDER BY 1, 2

-- Total Cases vs Population
-- Percentage of population infested

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected
FROM CovidDeaths
-- WHERE location = 'Argentina'
WHERE continent is not null
ORDER BY 1, 2

-- Countries with the highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 as PercentOfPopulationInfected
FROM CovidDeaths
-- WHERE location = 'Argentina'
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentOfPopulationInfected DESC

-- Countries and Continents with Highest Death Count per Population

SELECT location, Max(total_deaths) as TotalDeathCount
FROM CovidDeaths
-- WHERE location = 'Argentina'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

SELECT location, Max(total_deaths) as TotalDeathCount
FROM CovidDeaths
-- WHERE location = 'Argentina'
WHERE continent is null AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global numbers

SELECT /*date,*/ SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases) as PorcentOfDeathForCases
FROM CovidDeaths
WHERE continent is not null AND new_cases NOT LIKE 0 AND new_deaths NOT LIKE 0
--GROUP BY date 
ORDER BY 1, 2


-- Total Population vs Vaccination
-- USING CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

-- USING TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
-- Make 4 more

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationVaccinated