WITH skill_demand AS (  
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
         skills_dim.skill_id
), 

avg_sal AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 2) AS avg_sal
    FROM 
        job_postings_fact
    INNER JOIN
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE  
        salary_year_avg IS NOT NULL AND
        job_title_short = 'Data Analyst'AND
         job_work_from_home = TRUE
    GROUP BY
         skills_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_sal
FROM
    skill_demand
INNER JOIN 
    avg_sal ON skill_demand.skill_id = avg_sal.skill_id
WHERE   
    demand_count > 10
ORDER BY
    avg_sal DESC,
    demand_count DESC
LIMIT 25


-- In one query bc yeah we can lol

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand,
    ROUND(AVG(salary_year_avg), 2) AS avg_sal
FROM job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE AND
    job_title_short = 'Data Analyst' 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    avg_sal DESC,
    demand DESC
LIMIT 25