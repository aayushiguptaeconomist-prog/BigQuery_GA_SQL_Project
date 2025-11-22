
----- RETENTION SEGMENT ------
SELECT
  CASE
    WHEN m.visitNumber = 1 THEN 'New User'
    ELSE 'Existing User'
  END AS user_category,
  COUNT(m.visitId) AS sessions,
  ROUND(COUNT(m.visitId) / SUM(COUNT(m.visitId)) OVER() * 100, 2) AS pct_user_category
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY
  user_category;
/*
Row	user_category	sessions	pct_user_category
1	New User	1872	73.24
2	Existing User	684	26.76

=> Insight: Almost 27% of all sessions have returning users (visitNumber > 1), indicating strong short-term retention for a single day of traffic. It is a high retention rate for a random single day of data. A retention rate of this magnitude suggests that the site has a loyal core user base even without multi-day behavioral data.
*/