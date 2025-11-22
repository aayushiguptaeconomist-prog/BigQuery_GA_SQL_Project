
-------- FUNNEL ANALYSIS --------
-- Let's query to understand where users drop off as they move through a sequence of steps
SELECT
  COUNT(m.visitId) AS sessions,
  SUM(CASE WHEN m.totals.pageviews > 0 THEN 1 ELSE 0 END) AS viewed,
  SUM(CASE WHEN m.totals.transactions > 0 THEN 1 ELSE 0 END) AS added_to_cart,
  SUM(CASE WHEN m.totals.transactions > 0 THEN 1 ELSE 0 END)/SUM(CASE WHEN m.totals.pageviews > 0 THEN 1 ELSE 0 END) AS ratio_transaction,
  SUM(CASE WHEN m.totals.transactionRevenue > 0 THEN 1 ELSE 0 END) AS purchased,
  SUM(CASE WHEN m.totals.transactionRevenue > 0 THEN 1 ELSE 0 END)/SUM(CASE WHEN m.totals.pageviews > 0 THEN 1 ELSE 0 END) AS ratio_purchased
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m;

-- => I am assuming NULL = NO PURCHASE. Based on this assumption, we observe that people do view the website, but off those only ~1.7% people make the purchase and complete the transaction, showing a sharp drop-off between browsing and purchasing. This points toward checkout friction or lack of purchase intent during this sampled period.