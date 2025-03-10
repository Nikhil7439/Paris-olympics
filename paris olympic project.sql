
-- 1 The Medals won by country  
-- Total Medals by Country: ;                                                                                             @nikhiljaiswal
SELECT country, SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold,
       SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver,
       SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze
FROM medallists
GROUP BY country;
-- Top Athletes by Medal Count:
SELECT name, country, COUNT(*) AS medal_count
FROM medallists
GROUP BY name, country
ORDER BY medal_count DESC
LIMIT 10;
-- LAST Athletes by Medal Count:
SELECT name, country, COUNT(*) AS medal_count
FROM medallists
GROUP BY name, country
ORDER BY medal_count ASC
LIMIT 10;
-- Medals by Discipline:
SELECT discipline, COUNT(*) AS total_medals
FROM medallists
GROUP BY discipline
ORDER BY total_medals DESC;
-- Team Performance:
SELECT t.team, t.country, COUNT(m.medal_type) AS total_medals
FROM teams t
LEFT JOIN medallists m ON t.country_code = m.country_code AND t.discipline = m.discipline
GROUP BY t.team, t.country
ORDER BY total_medals DESC;
-- The number of medals won by each country has changed over time. 
SELECT 
    medal_date, 
    country, 
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM 
    medallists
GROUP BY 
    medal_date, country
ORDER BY 
    medal_date, country;
    -- 2. Medal Conversion Efficiency 
    -- The efficiency of countries in converting their participation in events into medals.      @nikhiljaiswal
    
    SELECT 
    t.country,
    t.num_athletes,
    SUM(CASE WHEN m.medal_type IS NOT NULL THEN 1 ELSE 0 END) AS Medals_Won,
    (SUM(CASE WHEN m.medal_type IS NOT NULL THEN 1 ELSE 0 END) / t.num_athletes) * 100 AS Medal_Conversion_Rate
FROM 
    teams t
LEFT JOIN 
    medallists m ON t.country_code = m.country_code AND t.discipline = m.discipline
GROUP BY 
    t.country, t.num_athletes
HAVING 
    t.num_athletes > 0
ORDER BY 
    Medal_Conversion_Rate DESC;
    -- Top athletes in each discipline by the total number of medal they have won.
SELECT 
    discipline, 
    name, 
    country, 
    COUNT(*) AS total_medals,
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM 
    medallists
GROUP BY 
    discipline, name, country
ORDER BY 
    discipline,
    total_medals desc;
    -- 4. Dominance in a Specific Event.
    -- The countries that have dominated specific events by winning the most medals.
SELECT 
    event, 
    country, 
    COUNT(*) AS total_medals,
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM 
    medallists
GROUP BY 
    event, country  
HAVING
    total_medals > 1
ORDER BY 
    total_medals DESC, Gold_Medals DESC;
    -- 5. Gender Comparison in Medal Wins
--  compares the performance of male and female athletes in terms of medal wins across all disciplines.
SELECT 
    gender,
    discipline,
    COUNT(*) AS total_medals,
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM 
    medallists
GROUP BY 
    gender, discipline
    
ORDER BY 
    total_medals DESC, discipline;
    -- 6. Performance Analysis by Age Group
-- Athletes by age groups to see which age group is the most successful in winning medals.        @NIKHIL 
SELECT 
    CASE 
        WHEN YEAR(CURDATE()) - YEAR(STR_TO_DATE(birth_date, '%d-%m-%Y')) < 20 THEN '<20'
        WHEN YEAR (CURDATE()) - YEAR(STR_TO_DATE(birth_date, '%d-%m-%y')) BETWEEN 20 AND 29 THEN  '20-29'
        WHEN YEAR(CURDATE()) - YEAR(STR_TO_DATE(birth_date, '%d-%m-%Y')) BETWEEN 30 AND 39 THEN '30-39'
        ELSE '40+ '
    END AS age_group,
    COUNT(*) AS total_medals,
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM 
    medallists
GROUP BY 
    age_group
ORDER BY 
    total_medals DESC;
-- 7 Country's Best Disciplines
-- The disciplines in which each country excels by counting the number of gold medals won in each discipline.
SELECT 
    country, 
    discipline, 
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals
FROM 
    medallists
GROUP BY 
    country, discipline
ORDER BY 
    country, Gold_Medals DESC;
    -- 8. Medal Distribution by Event Type
-- Analyze how medals are distributed across different event types (e.g., individual vs. team events).
SELECT 
    event_type,
    COUNT(*) AS total_medals,
    SUM(CASE WHEN medal_type = 'Gold Medal' THEN 1 ELSE 0 END) AS Gold_Medals,
    SUM(CASE WHEN medal_type = 'Silver Medal' THEN 1 ELSE 0 END) AS Silver_Medals,
    SUM(CASE WHEN medal_type = 'Bronze Medal' THEN 1 ELSE 0 END) AS Bronze_Medals
FROM 
    medallists
GROUP BY 
    event_type
ORDER BY 
    total_medals DESC;
    
-- 9. Cross-Discipline Medalists
-- Identify athletes who have won medals in multiple disciplines.
SELECT 
    name, 
    country, 
    COUNT(DISTINCT discipline) AS disciplines_count,
    COUNT(*) AS total_medals
FROM 
    medallists
GROUP BY 
    name, country
HAVING 
    disciplines_count > 1
ORDER BY 
    total_medals DESC, disciplines_count DESC;
    
-- 10. Host Nation Performance
-- Compare the performance of the host nation against other nations.
SELECT 
    m.country, 
    SUM(CASE WHEN m.country = 'France' THEN 1 ELSE 0 END) AS host_country_medals,
    SUM(CASE WHEN m.country != 'France' THEN 1 ELSE 0 END) AS other_country_medals
FROM 
    medallists m
GROUP BY 
    m.country
ORDER BY 
    host_country_medals DESC, other_country_medals DESC;
    -- 11. indian nation performance
    -- compare the performance of the indian nation against other nation. 
    
    SELECT 
    m.country, 
    SUM(CASE WHEN m.country = 'india' THEN 1 ELSE 0 END) AS indian_country_medals,
    SUM(CASE WHEN m.country != 'india' THEN 1 ELSE 0 END) AS other_country_medals
FROM 
    medallists m
GROUP BY 
    m.country
ORDER BY 
    indian_country_medals DESC, other_country_medals DESC;
    
    -- 12. india's medals in olympic . 
SELECT 
    m.country, 
    SUM(CASE WHEN m.country = 'india' THEN 1 ELSE 0 END) AS india_country_medals,
    SUM(CASE WHEN m.country != 'india' THEN 1 ELSE 0 END) AS other_country_medals
FROM 
    medallists m
GROUP BY 
    m.country
ORDER BY 
    india_country_medals DESC, other_country_medals DESC;
lock table medallists write;
lock table medals_total write ;
lock table teams write ;

