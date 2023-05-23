/*
Stack Overflow 2022 Developer Survey Data Exploration 

Skills used: Data manipulation,Subqueries,String functions,Conditional statements,Arithmetic calculations, Aggregate Functions, Creating Views,Creating Procedures, Converting Data Types

*/
USE survey;
Select * From survey_results ;

/* Normalize the "CompTotal" column based on the frequency specified
 in the "CompFreq" column. It provides a calculated value for the annual compensation
 in the "NormalizedAnnualCompensation" column.*/
UPDATE survey_results
SET NormalizedAnnualCompensation = 
    CASE
        WHEN CompFreq = 'Yearly' THEN CompTotal
        WHEN CompFreq = 'Monthly' THEN CompTotal * 12
        WHEN CompFreq = 'Weekly' THEN CompTotal * 52
        ELSE NULL
    END
    WHERE CompTotal != 'NA';

-- Select Data that we are going to be starting with
Select Employment,NormalizedAnnualCompensation,LearnCodeCoursesCert,DevType,LanguageHaveWorkedWith,
LanguageWantToWorkWith,DatabaseHaveWorkedWith,DatabaseWantToWorkWith,
VersionControlSystem,Age,Gender,WorkExp From survey_results
order by 2;

-- What are the most popular programming languages that respondents have worked with?
CREATE VIEW popular_languages_worked_with AS
SELECT SUBSTRING_INDEX(LanguageHaveWorkedWith, ';', 1) AS LanguageWorkedWith, COUNT(*) AS Frequency
FROM survey_results
WHERE LanguageHaveWorkedWith <> 'NA'
GROUP BY LanguageWorkedWith
ORDER BY Frequency DESC
LIMIT 10;

-- What are the most popular programming languages that respondents have worked with and want to continue working with?
CREATE VIEW popular_languages_worked_and_want_to_continue AS
SELECT SUBSTRING_INDEX(LanguageHaveWorkedWith, ';', 1) AS LanguageWorkedWith,
SUBSTRING_INDEX(LanguageWantToWorkWith, ';', 1) AS LanguageWantToWorkWith, COUNT(*) AS Frequency
FROM survey_results
WHERE LanguageHaveWorkedWith <> 'NA' and LanguageWantToWorkWith <> 'NA'
GROUP BY LanguageWorkedWith, LanguageWantToWorkWith
ORDER BY Frequency DESC;

-- What are the most common types of employment for respondents?
CREATE VIEW common_employment_types AS
SELECT TRIM(SUBSTRING_INDEX(Employment, ';', 1)) AS Employment, COUNT(*) AS Frequency
FROM survey_results
WHERE Employment <> 'NA'
GROUP BY TRIM(SUBSTRING_INDEX(Employment, ';', 1))
ORDER BY Frequency DESC
LIMIT 10;

-- What is the Median Annual Salary for respondents?
-- I didn't use Mean because of outliers
DELIMITER //
CREATE PROCEDURE calculate_median(OUT median DECIMAL(10,2))
BEGIN
  SET @rownum := 0;
  SET @total_rows := 0;
  
  SELECT COUNT(*) INTO @total_rows FROM survey_results WHERE NormalizedAnnualCompensation IS NOT NULL;
  SELECT AVG(NormalizedAnnualCompensation)
  INTO median
  FROM (
    SELECT NormalizedAnnualCompensation,
           @rownum := @rownum + 1 AS row_numbers,
           @total_rows AS total_rows
    FROM survey_results
    WHERE NormalizedAnnualCompensation IS NOT NULL
    ORDER BY NormalizedAnnualCompensation
  ) AS subquery
  WHERE row_numbers IN (FLOOR((total_rows + 1) / 2), CEIL((total_rows + 1) / 2));
END //
DELIMITER ;
CALL calculate_median(@median_value);
SELECT @median_value AS MedianCompensation;

-- What are the most popular ways for respondents to learn to code?
CREATE VIEW popular_learning_methods AS
SELECT TRIM(SUBSTRING_INDEX(LearnCodeCoursesCert, ';', 1)) AS LearnCodeCoursesCert, COUNT(*) AS Frequency
FROM survey_results
WHERE LearnCodeCoursesCert <> 'NA'
GROUP BY TRIM(SUBSTRING_INDEX(LearnCodeCoursesCert, ';', 1))
ORDER BY Frequency DESC
LIMIT 10;

-- What are the most popular development types for respondents?
CREATE VIEW popular_development_types AS
SELECT TRIM(SUBSTRING_INDEX(DevType, ';', 1)) AS DevType, COUNT(*) AS Frequency
FROM survey_results
WHERE DevType <> 'NA'
GROUP BY TRIM(SUBSTRING_INDEX(DevType, ';', 1))
ORDER BY Frequency DESC
LIMIT 10;

-- What are the most popular databases for respondents?
CREATE VIEW popular_databases AS
SELECT TRIM(SUBSTRING_INDEX(DatabaseHaveWorkedWith, ';', 1)) AS DatabaseHaveWorkedWith, COUNT(*) AS Frequency
FROM survey_results
WHERE DatabaseHaveWorkedWith <> 'NA'
GROUP BY TRIM(SUBSTRING_INDEX(DatabaseHaveWorkedWith, ';', 1))
ORDER BY Frequency DESC
LIMIT 10;

-- What are the most popular version control systems for respondents?
CREATE VIEW popular_version_control_systems AS
SELECT TRIM(SUBSTRING_INDEX(VersionControlSystem, ';', 1)) AS VersionControlSystem, COUNT(*) AS Frequency
FROM survey_results
WHERE VersionControlSystem <> 'NA'
GROUP BY TRIM(SUBSTRING_INDEX(VersionControlSystem, ';', 1))
ORDER BY Frequency DESC
LIMIT 5;

-- What is the average age of respondents?
CREATE VIEW average_age AS
SELECT FLOOR(AVG(
    CASE
        WHEN Age = 'Under 18 years old' THEN 16
        WHEN Age = '18-24 years old' THEN 21
        WHEN Age = '25-34 years old' THEN 30
        WHEN Age = '35-44 years old' THEN 40
        WHEN Age = '45-54 years old' THEN 50
        WHEN Age = '55-64 years old' THEN 60
        WHEN Age = '65 years or older' THEN 70
        ELSE NULL
    END
)) AS AverageAge
FROM survey_results
WHERE Age <> 'NA';

-- What is the gender breakdown of respondents?
CREATE VIEW gender_breakdown AS
SELECT 
    CASE 
		WHEN Gender LIKE '%Woman%' THEN 'Woman'
        WHEN Gender LIKE '%Man%' THEN 'Man'
        ELSE 'Unknown'
    END AS GenderCategory,
    COUNT(*) AS Frequency
FROM survey_results
WHERE Gender <> 'NA'
GROUP BY GenderCategory;

-- What is the average amount of work experience for respondents?
CREATE VIEW average_workexperience AS
SELECT FLOOR(AVG(WorkExp)) AS AverageWorkExperience
FROM survey_results;

-- What is the impact of work experience on annual compensation?
CREATE VIEW workexperience_impact AS
SELECT WorkExp, floor(AVG(NormalizedAnnualCompensation)) AS AverageCompensation
FROM survey_results
WHERE WorkExp IS NOT NULL
  AND TRIM(WorkExp) <> ''
  AND (WorkExp NOT LIKE 'NA%' OR WorkExp IS NULL)
GROUP BY WorkExp
ORDER BY CAST(WorkExp AS UNSIGNED) DESC;