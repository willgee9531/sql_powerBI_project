-- Active: 1751133673814@@localhost@5432@sql_course
/*
What it does:

    - Groups job postings based on whether a degree is mentioned as a requirement (`job_no_degree_mention`).
    - Calculates the average yearly salary for each group, considering only postings with a non-null yearly salary.
    - Counts the number of job postings in each group.
*/

SELECT
    job_no_degree_mention AS no_degree_mentioned,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary,
    COUNT(*) AS job_count
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
GROUP BY
    job_no_degree_mention;



/*
Further Query:
    - This query retrieves the specific companies that do not require a degree.
    - It can be used to analyze the job market for positions that do not require formal education.
*/
SELECT
    jpf.job_no_degree_mention AS no_degree_mentioned,
    cd.name AS company_name,
    COUNT(jpf.job_id) AS job_count
FROM 
    job_postings_fact jpf
LEFT JOIN
    company_dim cd ON jpf.company_id = cd.company_id
WHERE
    jpf.job_no_degree_mention = 'true'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    cd.name, jpf.job_no_degree_mention
ORDER BY
    job_count DESC;
