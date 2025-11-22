
----- VisitId vs fullVisitorId vs visitNumber ------
SELECT
  fullVisitorId,
  COUNT(fullVisitorId) AS repeating_user
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY
  fullVisitorId
ORDER BY
  repeating_user DESC;
-- => This tells me that the fullVisitorId (user) is repeating

--- Let's check if the visitId is also repeating
SELECT
  fullVisitorId,
  visitId,
  COUNT(fullVisitorId) AS repeating_user
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY
  fullVisitorId, visitId
ORDER BY
  repeating_user DESC;
-- => -- This tells me that there is a single distinct visitId per fullVisitorId.
SELECT
  visitId,
  COUNT(visitId) AS repeating_visitId
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY
  visitId
ORDER BY
  repeating_visitId DESC;
-- => the above two queries imply that the visitId is repeating but not within a single fullVisitorId. Upon doing some research, I find out that a visitId can repeat because it refers to timestamp-based session identifier. It is the same for all those users who visit the website at the same time on the same day.

-- Further queried to see what visitNumber is all about
WITH repeat_user_table AS (
  SELECT
    m.fullVisitorId,
    COUNT(m.fullVisitorId) AS cnt_user
  FROM
    `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
  GROUP BY
    m.fullVisitorId
  HAVING
    COUNT(m.fullVisitorId) >1
  ORDER BY
    cnt_user DESC
)

SELECT
  m.fullVisitorId,
  m.visitNumber
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` AS m
  INNER JOIN repeat_user_table AS r ON m.fullVisitorId = r.fullVisitorId
ORDER BY
  m.fullVisitorId DESC;
-- => Found out that there are different visitNumber for the same user. So, I did some research and understood that this is not the total number of visits by a user, which I was initially thinking, but instead it is the serial number for the nth visit of the user. Eg. #6 means it is the 6th time the user is visiting.