
------ REVENUE CONTRIBUTION BY SOURCE ------
SELECT
  m.trafficSource.source AS source,
  COUNT(m.visitId) AS sessions,
  SUM(IFNULL(m.totals.transactionRevenue,0)) AS revenue,
  ROUND(SUM(IFNULL(m.totals.transactionRevenue,0))/COUNT(m.visitId),2) AS revenue_per_session
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
GROUP BY 
  source
ORDER BY 
  revenue DESC;
/*
Revenue is only generated from two sources. The total revenue and the per session revenue by those sources is reflected below.
Row	source	sessions	revenue	revenue_per_session
1	(direct)	2166	8292980000	3828707.29
2	mail.google.com	2	11960000	5980000.0
=> Although '(direct)' generates the majority of revenue volume, Gmail traffic produces 1.56× higher revenue per session, indicating a higher purchase intent segment. Increasing outreach via Gmail campaigns could materially increase revenue even with lower number of visitors.
*/
