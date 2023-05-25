# Stack Overflow 2022 Developer Survey Data Exploration
This project aims to explore the Stack Overflow 2022 Developer Survey data using SQL. The dataset contains information about various aspects of developers, including their employment status, compensation, programming languages, learning methods, development types, databases, version control systems, age, gender, and work experience.
## Skills Used
* Data manipulation
* Subqueries
* String functions
* Conditional statements
* Arithmetic calculations
* Aggregate Functions
* Creating Views
* Creating Procedures
* Converting Data Types

## Project Code
The project code includes SQL queries that perform various data exploration tasks. Here is an overview of the code sections:
##### 1. Data Selection: The initial query selects all data from the survey_results table.
##### 2. Data Normalization: The code normalizes the "CompTotal" column based on the frequency specified in the "CompFreq" column. It calculates the annual compensation and stores it in the "NormalizedAnnualCompensation" column.
##### 3. The following questions were explored in this project:
  * What are the most popular programming languages that respondents have worked with?
  * What are the most popular programming languages that respondents have worked with and want to continue working with?
  * What are the most common types of employment for respondents?
  * What is the Median Annual Salary for respondents?
  * What are the most popular online platforms for respondents to learn to code?
  * What are the most popular development types for respondents?
  * What are the most popular databases for respondents?
  * What are the most popular version control systems for respondents?
  * What is the average age of respondents?
  * What is the gender breakdown of respondents?
  * What is the average amount of work experience for respondents?
  * What is the impact of work experience on annual compensation?
## Results
![image](https://github.com/khaledtarek99/SQL-Data-Exploration-of-the-Stack-Overflow-Developer-Survey/assets/53887110/ad393a5b-3940-4a45-93c3-bd37133bdac5)
##### [Dashboard](https://public.tableau.com/views/StackOverflow2022DeveloperSurvey/StackOverflow2022DeveloperSurveyDashboard?:language=en-US&:display_count=n&:origin=viz_share_link)
## Usage
To use this project, follow these steps:
1. Set up a SQL database and import the Stack Overflow 2022 Developer Survey data.
2. Run the provided code in your SQL environment or client against the imported data.
3. Explore the results of the different queries to gain insights into the survey data.<br /> <br />
Feel free to modify or enhance the code to suit your specific analysis requirements.<br />
Note: The code assumes the presence of the survey_results table containing the Stack Overflow Developer Survey data.
## Acknowledgments
The Stack Overflow Developer Survey data used in this project is sourced from Stack Overflow. For more information about the survey and data, please visit the Stack Overflow website.
[Full Data Set](https://insights.stackoverflow.com/survey/)
## License
This project is licensed under the MIT License.
