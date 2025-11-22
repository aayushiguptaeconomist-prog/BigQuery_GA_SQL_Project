
----- BEHAVIOR CONSISTENCY------
---  Since, now we know that visitNumber is the nth visit time of a user, we can figure out how many times a user visited the website using what device and through what traffic source. 
-- Let's see the visitNumber for heavy users, i.e., the ones whose visitNumber > 10 showcasing that they are returning to the website the 10th time. We can change this condition of 10.
-- THIS CTE BECOMES REDUNDANT AS I ADD THE HAVING CONDITION IN THE MAIN QUERY ITSELF. JUST USE THIS QUERY WHEN CHECKING FOR THE VISITNUMBER COUNT FOR DIFFERENT USERS.
-- WITH sample_table AS (  
--   SELECT
--       m.fullVisitorId,
--       COUNT(m.visitNumber) AS visit_cnt
--   FROM 
--     `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
--   -- INNER JOIN visitNumber_morethan10 AS v ON m.fullVisitorId = v.fullVisitorId
--   GROUP BY
--     m.fullVisitorId
--   HAVING
--     MAX(m.visitNumber) > 10
-- )

--- Traffic Source
SELECT
  m.fullVisitorId,
  COUNT(DISTINCT m.trafficSource.source) AS trafficSource_cnt,
  -- CASE
  --   WHEN COUNT(DISTINCT m.trafficSource.source) <> 1 THEN 'FALSE'
  --   ELSE 'TRUE'
  -- END AS same_source_always
  -- this categorizes the users into using single/multiple traffic sources. Not required for now.
FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
-- INNER JOIN sample_table AS s ON m.fullVisitorId = s.fullVisitorId
GROUP BY 
  m.fullVisitorId
HAVING
  MAX(m.visitNumber) > 10 AND
  COUNT(DISTINCT m.trafficSource.source) = 1
  -- this let's you chose those fullVisitorIds who have used more than 1 traffic source to visit back
ORDER BY
  trafficSource_cnt DESC;
-- => Heavy users (10th time visitors) always use the same source to visit the website. 

--Now we can check what is the most used traffic source for the heavy users.
WITH heavy_users AS (
  SELECT
    m.fullVisitorId
  FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` as m
  GROUP BY 
    m.fullVisitorId
  HAVING 
    MAX(m.visitNumber) > 10
)

SELECT
  m.trafficSource.source,
  COUNT(m.trafficSource.source) AS trafficSource_cnt
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
INNER JOIN heavy_users AS h ON m.fullVisitorId = h.fullVisitorId
GROUP BY
  m.trafficSource.source
ORDER BY
  trafficSource_cnt DESC;
/*
Row	source	trafficSource_cnt
1	(direct)	52
2	dfa	7
3	analytics.google.com	2
4	Partners	1
5	facebook.com	1
6	sites.google.com	1
*/

--- Device
SELECT
  m.fullVisitorId,
  COUNT(DISTINCT m.device.deviceCategory) AS device_cnt,
FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY 
  m.fullVisitorId
HAVING
  MAX(m.visitNumber) > 10 AND
  COUNT(DISTINCT m.device.deviceCategory) <> 1
ORDER BY
  device_cnt DESC;
-- => Similar to traffic source, heavy users (10th time visitors) always use the same device to visit the website. 

--Now we can check what is the most used device for the heavy users. We can also check the total visit count by device to help the UX/design team of a company prioritize their work.
WITH heavy_users AS (
  SELECT
    m.fullVisitorId
  FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` as m
  GROUP BY 
    m.fullVisitorId
  HAVING 
    MAX(m.visitNumber) > 10
)

SELECT
  m.device.deviceCategory,
  COUNT(m.device.deviceCategory) AS device_cnt
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
INNER JOIN heavy_users AS h ON m.fullVisitorId = h.fullVisitorId
GROUP BY
  m.device.deviceCategory
ORDER BY
  device_cnt DESC;
/*
Row	deviceCategory	device_cnt
1	desktop	58
2	mobile	3
3	tablet	3
*/
SELECT
  m.device.deviceCategory,
  COUNT(m.visitId) AS visit_cnt
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY
  deviceCategory
ORDER BY
  visit_cnt DESC;
/*
Row	deviceCategory	visit_cnt
1	desktop	1742
2	mobile	725
3	tablet	89
*/
-- => Insight: High-retention users (those with 10+ lifetime visits) consistently use the same traffic source and device, signaling a stable behavioral pattern. This consistency implies strong habitual usage — returning users rely on a predictable entry point (mostly direct on desktop), which helps in designing targeted retention UX flows.