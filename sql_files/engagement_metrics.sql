
------ ENGAGEMENT METRICS ------
--- Let's see how many pageviews, hits and visits are recieved by each device and through each traffic source 
-- Traffic Source
SELECT
  m.trafficSource.source AS source,
  COUNT(m.visitId) AS total_visits,
  SUM(m.totals.hits) AS total_hits,
  SUM(m.totals.pageviews) AS total_pageViews,
  ROUND(SUM(m.totals.hits)/COUNT(m.visitId)) AS hit_ratio,
  ROUND(SUM(m.totals.pageviews)/COUNT(m.visitId)) pageView_ratio
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY
  source;
/*
Row	source	total_visits	total_hits	total_pageViews	hit_ratio	pageView_ratio
1	(direct)	2166	12291	10069	6.0	5.0
2	analytics.google.com	57	114	113	2.0	2.0
3	adwords.google.com	2	7	7	4.0	4.0
-------
34	pinterest.com	1	11	7	11.0	7.0
35	dealspotr.com	1	23	19	23.0	19.0
==>Insight: Although 'direct' has the highest visits, hits, and pageviews, the highest hit_ratio and pageView_ratio is of 'dealspotr.com'. And the most interesting part about this is that this source has 23 hits and 19 pageviews on 1 visit, suggesting hyper-motivated traffic. It would be nice to see the difference between the user interface of this source and the 'direct' source. But another thing to remember is that it has only 1 visit. So, I think it is difficult to get a user to that website, but then once they reach there, they find it interesting.
*/

-- Device Category
SELECT
  m.device.deviceCategory AS device,
  COUNT(m.visitId) AS total_visits,
  SUM(m.totals.hits) AS total_hits,
  SUM(m.totals.pageviews) AS total_pageViews,
  ROUND(SUM(m.totals.hits)/COUNT(m.visitId)) AS hit_ratio,
  ROUND(SUM(m.totals.pageviews)/COUNT(m.visitId)) pageView_ratio
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY
  device;
/*
Row	device	total_visits	total_hits	total_pageViews	hit_ratio	pageView_ratio
1	desktop	1742	10206	8329	6.0	5.0
2	mobile	725	2716	2332	4.0	3.0
3	tablet	89	311	278	3.0	3.0
==> Desktop users show 50–70% higher engagement than mobile/tablet users across all metrics, indicating that the mobile experience likely introduces friction. Improving mobile navigation, page load, or layout could significantly increase session depth.
*/