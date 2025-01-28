SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_sal,
    COUNT(skills_job_dim.job_id) AS skill_count
FROM 
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE  
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_sal DESC
LIMIT 25