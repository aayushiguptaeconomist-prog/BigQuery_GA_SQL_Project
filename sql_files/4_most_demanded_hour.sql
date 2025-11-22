
------- MOST DEMANDED HOUR OF THE DAY --------

-- Let's query to find out at what hour of the day the users visit the website the most
SELECT
  EXTRACT(HOUR FROM TIMESTAMP_SECONDS(m.visitStartTime)) AS hour_time,
  COUNT(m.visitId) AS visit_cnt
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY
  hour_time
ORDER BY
  visit_cnt DESC;
/* For visit_cnt>100
Row	hour_time	visit_cnt
1	20	156
2	17	147
3	18	144
4	14	138
5	19	135
6	21	130
7	15	129
8	16	121
9	22	121
10	13	121
11	1	102
*/
-- => Insight: This informs us that most of the visits take place in the afternoon and the evening, especially after 12 and go on until 1 at night. Marketing pushes or product releases timed in this window may generate higher visibility and conversions.

-- Let's query to find out what traffic sources were used at the most demanded hour of the day
SELECT
  m.trafficSource.source AS source,
  COUNT(m.visitId) AS visit_cnt
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
WHERE
  EXTRACT(HOUR FROM TIMESTAMP_SECONDS(m.visitStartTime)) IN (20, 17, 18)
GROUP BY
  source;
-- ==> the traffic source is direct at the top three most demanded hours of the day, reinforcing that users actively type or bookmark the site rather than coming from external referrals.

