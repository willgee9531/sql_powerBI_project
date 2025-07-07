/*
What it does:
- Joins job postings with their required skills.
- Filters for jobs that are remote (`job_work_from_home = 'Yes'`) and have the exact title "Data Analyst".
- Counts how many times each skill appears in these postings.
- Lists the top 5 most in-demand skills for remote Data Analyst jobs, along with their type (e.g., technical, soft skill).
*/

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