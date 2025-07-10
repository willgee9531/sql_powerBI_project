-- Active: 1751133673814@@localhost@5432@sql_course
/*
What it does:

    - Joins job postings with company information.
    - Filters for jobs that are remote (`job_work_from_home = TRUE`).
    - Groups results by company name and the year the job was posted.
    - Counts the number of remote jobs posted by each company per year.
    - Orders the results to show companies with the most remote jobs at the top.
*/

SELECT
    cd.name AS company_name,
    COUNT(jpf.company_id) AS remote_job_count,
    EXTRACT(YEAR FROM jpf.job_posted_date) AS year_posted
FROM
    job_postings_fact jpf
LEFT JOIN
    company_dim cd ON jpf.company_id = cd.company_id
WHERE
    jpf.job_work_from_home = 'true'
GROUP BY
    company_name, year_posted
ORDER BY
    remote_job_count DESC;