-- What languages are spoken in the United States? (12) Brazil? (not Spanish...) Switzerland? (6)
SELECT
  cl.countrycode,
  c.name,
  cl.language
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  code = 'USA';

SELECT
  cl.countrycode,
  c.name,
  cl.language
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  code = 'BRA';

SELECT
  cl.countrycode,
  c.name,
  cl.language
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  code = 'CHE';

-- What are the cities of the US? (274) India? (341)
SELECT
  ci.name,
  c.name
FROM
  country c JOIN
  city ci ON c.code = ci.countrycode
WHERE
  code = 'USA';

SELECT
  ci.name,
  c.name
FROM
  country c JOIN
  city ci ON c.code = ci.countrycode
WHERE
  code = 'IND';

-- What are the official languages of Switzerland? (4 languages)
SELECT
  cl.language,
  c.name,
  cl.isofficial
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  isofficial = 't'
  AND
  code = 'CHE';

  -- Which country or contries speak the most languages? (12 languages) Hint: Use GROUP BY and COUNT(...)
SELECT
  c.name,
  count(cl.language) AS language_count
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
GROUP BY
  name
ORDER BY
  language_count DESC;

  -- Which country or contries have the most offficial languages? (4 languages) Hint: Use GROUP BY and ORDER BY
SELECT
  c.name,
  count(cl.isofficial) AS official_count
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  isofficial = 't'
GROUP BY
  name
ORDER BY
  official_count DESC;


-- Which languages are spoken in the ten largest (area) countries? Hint: Use WITH to get the countries and join with that table
WITH largest_area AS
  (SELECT
    surfacearea,
    name,
    code
  FROM
    country
  ORDER BY
    surfacearea DESC
    LIMIT 10)

SELECT
  largest_area.name,
  cl.language
FROM
  largest_area JOIN
  countrylanguage cl ON largest_area.code = cl.countrycode
ORDER BY
  name;

-- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0) Hint: Use WITH to get the countries, and SELECT DISTINCT to remove duplicates
WITH poorest AS
  (SELECT
    gnp,
    name,
    code,
    population,
    gnp / population AS gnp_per_capita
  FROM
    country
  WHERE
    population > 0
    AND
    gnp > 0
  ORDER BY
    gnp_per_capita ASC
    LIMIT 20)

SELECT DISTINCT on (cl.language)
  cl.language,
  poorest.name
FROM
  poorest JOIN
  countrylanguage cl ON poorest.code = cl.countrycode
ORDER BY
  language;
-- select distinct and order by needs to match

-- Are there any countries without an official language? Hint: Use NOT IN with a SELECT
SELECT
  c.name,
  cl.*
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  countrycode NOT IN
    (SELECT
      countrycode
    FROM
      countrylanguage
    WHERE
      isofficial = 'TRUE')
ORDER BY
  countrycode ASC;

-- What are the languages spoken in the countries with no official language? (49 countries, 172 languages, incl. English)
WITH distinct_no_official AS
  (SELECT
    c.name,
    cl.*
  FROM
    country c JOIN
    countrylanguage cl ON c.code = cl.countrycode
  WHERE
    countrycode NOT IN
      (SELECT
        countrycode
      FROM
        countrylanguage
      WHERE
        isofficial = 'TRUE')
  ORDER BY
    countrycode ASC)

SELECT DISTINCT on (language)
  c.name,
  distinct_no_official.countrycode,
  distinct_no_official.language
FROM
  distinct_no_official JOIN
  country c ON c.code = distinct_no_official.countrycode
ORDER BY
  language;

-- Which countries have the highest proportion of official language speakers? The lowest?
SELECT
  c.name,
  cl.*
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  countrycode NOT IN
    (SELECT
      countrycode
    FROM
      countrylanguage
    WHERE
      isofficial = 'FALSE')
ORDER BY
  percentage DESC;

SELECT
  c.name,
  cl.*,
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
WHERE
  countrycode NOT IN
    (SELECT
      countrycode
    FROM
      countrylanguage
    WHERE
      isofficial = 'FALSE')
ORDER BY
  percentage ASC;

-- What is the most spoken language in the world?
SELECT
  cl.language,
  count(cl.language) AS language_count
FROM
  country c JOIN
  countrylanguage cl ON c.code = cl.countrycode
GROUP BY
  language
ORDER BY
  language_count DESC;

-- What is the population of the United States? What is the city population of the United States?
SELECT
  SUM(ci.population) AS city_sum_pop
FROM
  country c JOIN
  city ci ON c.code = ci.countrycode
WHERE
  countrycode = 'USA';

  SELECT
    SUM(ci.population) AS city_sum_pop
  FROM
    country c JOIN
    city ci ON c.code = ci.countrycode
  WHERE
    countrycode = 'IND';

-- Which countries have no cities? (7 not really contries...)
SELECT
  c.name
FROM
  city ci RIGHT JOIN
  country c ON ci.countrycode = c.code
WHERE
  countrycode IS NULL;

-- What is the total population of cities where English is the offical language? Spanish? Hint: The official language of a city is based on country.
SELECT
  SUM(ci.population) AS city_sum_pop
FROM
  countrylanguage cl JOIN
  city ci ON cl.countrycode = ci.countrycode
WHERE
  isofficial = 't'
  AND
  language = 'English';

SELECT
  SUM(ci.population) AS city_sum_pop
FROM
  countrylanguage cl JOIN
  city ci ON cl.countrycode = ci.countrycode
WHERE
  isofficial = 't'
  AND
  language = 'Spanish';

-- Which countries have the 100 biggest cities in the world?
WITH biggest_cities AS
  (SELECT
    name,
    population,
    countrycode
  FROM
    city
  ORDER BY
    population DESC
    LIMIT 100)

SELECT
  c.name
FROM
  biggest_cities JOIN
  country c ON biggest_cities.countrycode = c.code
GROUP BY
  c.name
ORDER BY
  c.name;

-- What languages are spoken in the countries with the 100 biggest cities in the world?
WITH biggest_cities AS
  (SELECT
    name,
    population,
    countrycode
  FROM
    city
  ORDER BY
    population DESC
    LIMIT 100)

SELECT
  cl.language
FROM
  biggest_cities JOIN
  countrylanguage cl ON biggest_cities.countrycode = cl.countrycode
GROUP BY
  cl.language
ORDER BY
  cl.language;
