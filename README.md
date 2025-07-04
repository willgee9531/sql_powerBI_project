# Job Market Analysis

📊 This project explores the data job market trends, focusing on 🔥 in-demand skills, 💰 salary benchmarks, 📈 remote work trends, and 🎓 degree requirements for data analysts roles.

🔍SQL queries? Check them out here: [project_queries](/project_queries/)

## Project Motivation / Background 💡

The rapid evolution of the data industry has made it essential for job seekers, employers, and educators to stay updated on current market trends. This project was inspired by the need to understand which skills, qualifications, and roles are most valued in the remote data analyst job market, and to provide actionable insights for career and curriculum development.

## The Questions I Answered 🧐

1. **Which specific skills are most in demand for remote Data Analyst positions?**
2. **Which roles and locations offer the highest average yearly compensation?**
3. **Which companies posted the most remote job openings in 2023?**
4. **Do jobs that do not mention a degree requirement offer different average salaries compared to those that do?**

---

## Tools I Used 🛠️

- **SQL (PostgreSQL):** Data querying and analysis
- **Power BI:** Interactive dashboards and visualizations
- **VS Code:** Code editing and documentation
- **Git & GitHub:** Version control and collaboration

---

# The Analysis 📊
1. [In-Demand Skills for Remote Data Analyst Roles](#1-in-demand-skills-for-remote-data-analyst-roles-)
2. [Average Yearly Salary by Role and Country](#2-average-yearly-salary-by-role-and-country-)
3. [Top Remote Employers by Year](#3-top-remote-employers-by-year-)
4. [Degree Requirement and Salary Analysis](#4-degree-requirement-and-salary-analysis-)

## 1. In-Demand Skills for Remote Data Analyst Roles 🚀

**What it does:**
- Joins job postings with their required skills.
- Filters for jobs that are remote (`job_work_from_home = 'Yes'`) and have the exact title "Data Analyst".
- Counts how many times each skill appears in these postings.
- Lists the top 5 most in-demand skills for remote Data Analyst jobs, along with their type (e.g., technical, soft skill).

**Insights:**
- Identify which skills (e.g., SQL, Python, Excel) are most frequently requested for remote Data Analyst roles.
- Understand whether technical or analytical are more valued in remote settings.
- Spot trends in remote work and the skills associated with these opportunities.

**Use cases:**
- **Job Seekers:** Focus on acquiring or highlighting the top-listed skills in your resume and interviews for remote Data Analyst roles.
- **Employers:** Ensure job descriptions include the most sought-after skills to attract qualified candidates.
- **Educators/Trainers:** Tailor curriculum to emphasize the most in-demand skills for remote Data Analyst positions.

**Note:**
- To broaden the analysis, consider including hybrid/onsite roles for comparison.

**SQL Query:**
````sql
SELECT DISTINCT
    sd.skills,
    sd.type AS skill_type,
    COUNT(sjd.job_id) AS demand_count,
    jf.job_work_from_home
FROM 
    skills_job_dim sjd
INNER JOIN 
    skills_dim sd ON sjd.skill_id = sd.skill_id
INNER JOIN 
    job_postings_fact jf ON sjd.job_id = jf.job_id
WHERE
    jf.job_work_from_home = 'Yes'
    AND jf.job_title_short = 'Data Analyst'
GROUP BY 
    sd.skills, sd.type, jf.job_work_from_home
ORDER BY 
    demand_count DESC
LIMIT 5;

````

| Skills     | Skill Type    | Demand Count |
|------------|---------------|--------------|
| SQL        | Programming   | 7291         |
| Excel      | Analyst Tools | 4611         |
| Python     | Programming   | 4330         |
| Tableau    | Analyst Tools | 3745         |
| Power BI   | Analyst Tools | 2609         |

*Table of the demand for the top 5 skills in remote data analyst job postings*

---

## 2. Average Yearly Salary by Role and Country 💵🌍

**What it does:**
- Aggregates job postings by job title and country.
- Calculates the average yearly salary for each group, rounding up to the nearest integer.
- Filters out postings where the yearly salary is missing.
- Orders the results by the highest average yearly salary.

**Insights:**
- See which job titles and countries offer the highest average yearly salaries.
- Identify geographic or role-based trends in yearly salary offerings.

**Use cases:**
- **Job Seekers:** Target roles and locations with higher average yearly salaries.
- **Employers:** Benchmark your yearly salary offerings against market averages.
- **Educators/Trainers:** Advise students on lucrative career paths and locations.

**Note:**
- The query only considers postings with a specified yearly salary (`salary_year_avg IS NOT NULL`).

**SQL Query:**
````sql
SELECT 
    job_title_short,
    job_country,
    CEIL(AVG(salary_year_avg)) AS avg_yearly_salary
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY 
    job_title_short, job_country
ORDER BY 
    avg_yearly_salary DESC;
````
---

## 3. Top Remote Employers by Year 🏢🌐

**What it does:**
- Joins job postings with company information.
- Filters for jobs that are remote (`job_work_from_home = TRUE`).
- Groups results by company name and the year the job was posted.
- Counts the number of remote jobs posted by each company per year.
- Orders the results to show companies with the most remote jobs at the top.

**Insights:**
- See which companies are leading in offering remote job opportunities.
- Track how remote job postings by company change over time.

**Use cases:**
- **Job Seekers:** Identify companies with strong remote work cultures to target in your job search.
- **Employers:** Benchmark your remote hiring activity against competitors.
- **Researchers:** Analyze the growth and distribution of remote work opportunities by company and year.

**Note:**
- The query only considers jobs explicitly marked as remote (`job_work_from_home = TRUE`).
- Companies with hybrid or flexible arrangements not marked as remote may be underrepresented.

**SQL Query:**
````sql
SELECT 
    cd.name AS company_name,
    COUNT(jf.job_id) AS remote_jobs,
    EXTRACT(YEAR FROM jf.job_posted_date) AS year
FROM 
    job_postings_fact jf
LEFT JOIN 
    company_dim cd ON jf.company_id = cd.company_id
WHERE 
    jf.job_work_from_home = TRUE
GROUP BY 
    cd.name, year
ORDER BY 
    remote_jobs DESC;
````

---

## 4. Degree Requirement and Salary Analysis 🎓💸

**What it does:**
- Groups job postings based on whether a degree is mentioned as a requirement (`job_no_degree_mention`).
- Calculates the average yearly salary for each group, considering only postings with a non-null yearly salary.
- Counts the number of job postings in each group.

**Insights:**
- See if jobs that do not require a degree tend to offer higher or lower average salaries.
- Understand how common it is for jobs to omit degree requirements and how that relates to compensation.

**Use cases:**
- **Job Seekers:** Assess whether pursuing roles that do not require a degree impacts potential earnings.
- **Employers:** Benchmark your job requirements and salary offerings against market trends.
- **Educators/Trainers:** Advise students on the value of a degree in relation to salary expectations.

**Note:**
- The analysis only includes jobs with a specified yearly salary (`salary_year_avg IS NOT NULL`).

**SQL Query:**
````sql
SELECT 
    job_no_degree_mention,
    AVG(salary_year_avg) AS avg_salary,
    COUNT(job_id) AS job_count
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY 
    job_no_degree_mention;
````

## What I Learnt 📚✨

- **Skill Demand Patterns:**  
  Gained insights into which technical skills are most valued for remote Data Analyst roles, helping to understand current industry expectations.

- **Salary Benchmarks:**  
  Learned how compensation varies by job title and country, and identified regions and roles with the highest earning potential.

- **Remote Work Trends:**  
  Discovered which companies are leading in remote hiring and how remote opportunities have evolved over time.

- **Degree Requirements Impact:**  
  Understood the relationship between degree requirements and salary, and how omitting degree requirements can affect job availability and compensation.

- **Data Analysis & Visualization:**  
  Enhanced my ability to use SQL for complex data analysis and Power BI for creating interactive, insightful dashboards.

- **Practical Application:**  
  Developed actionable recommendations for job seekers, employers, and educators based on real

## Conclusion 🏁

This project provided a comprehensive analysis of the data job market, revealing key trends in skill demand, salary benchmarks, remote work opportunities, and the impact of degree requirements. By leveraging SQL for data extraction and Power BI for visualization, I was able to generate actionable insights for job seekers, employers, and educators. These findings can guide career development, hiring strategies, and curriculum design, ensuring alignment with current industry needs and future workforce.

## Contact / Feedback 📬

Have questions, suggestions, or want to collaborate?  
Feel free to reach out via [GitHub Issues](https://github.com/willgee9531/sql_powerBI_project/issues) or email me at **willgee9531@gmail.com**.