
-------- BOUNCE RATE ANALYSIS --------
-- Let us query the bounce rate. A bounce = ONE visit where user left immediately.
SELECT
  m.trafficSource.source,
  COUNT(m.visitId) AS sessions,
  SUM(IFNULL(m.totals.bounces,0)) AS bounces,
  ROUND(SUM(IFNULL(m.totals.bounces,0))/COUNT(m.visitId),2) AS bounce_rate
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY
  m.trafficSource.source
ORDER BY
  bounces DESC;
/*
Row	source	sessions	bounces	bounce_rate
1	(direct)	2166	985	0.45
2	youtube.com	180	139	0.77
3	analytics.google.com	57	34	0.6
4	Partners	52	30	0.58
5	google.com	12	9	0.75
6	dfa	15	6	0.4
*/
-- => bounce rate ranges from 0 to 1. 'direct' traffic source has the highest number of bounces but its bounce rate is less than 0.5. Other important traffic sources with a greater than 0.5 bounce rate are 'youtube.com', 'analytics.google.com', 'Partners', 'google.com' and many more, indicating mismatch between user intent and landing page experience. As we already saw under engagement ratios, 'dealspotr.com' had a hit_ratio and pageview_ratio, we expected it to have 0 bounce rate which it does. 