-- Understand the data in the survey
SELECT *
FROM survey
LIMIT 10;

-- Determine how many users made it through each question
SELECT question, COUNT(DISTINCT user_id) AS 'count'
FROM survey
GROUP BY question;

-- Understand the data in the funnel
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

-- Create a table with LEFT JOIN to track users
SELECT DISTINCT q.user_id,
       CASE WHEN h.number_of_pairs IS NOT NULL THEN 'True'
            ELSE 'False' END AS 'is_home_try_on',
       h.number_of_pairs,
       CASE WHEN p.price IS NOT NULL THEN 'True'
            ELSE 'False' END AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h ON q.user_id = h.user_id
LEFT JOIN purchase p ON q.user_id = p.user_id
LIMIT 10;

-- Measure conversions
WITH conversions AS
(SELECT DISTINCT q.user_id,
       h.number_of_pairs IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.price IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h ON q.user_id = h.user_id
LEFT JOIN purchase p ON q.user_id = p.user_id)

SELECT COUNT(user_id) AS '# completed survey',
       SUM(is_home_try_on) AS '# home try on',
       SUM(is_purchase) AS '# purchase',
       1.0*SUM(is_home_try_on)/COUNT(user_id) AS 'quiz to home',
       1.0*SUM(is_purchase)/SUM(is_home_try_on) AS 'home to purchase'
FROM conversions;

-- GROUP BY A/B testing groups
WITH conversions AS
(SELECT DISTINCT q.user_id,
       h.number_of_pairs IS NOT NULL AS 'is_home_try_on',
       h.number_of_pairs,
       p.price IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h ON q.user_id = h.user_id
LEFT JOIN purchase p ON q.user_id = p.user_id)

SELECT number_of_pairs,
       COUNT(user_id) AS '# completed survey',
       SUM(is_home_try_on) AS '# home try on',
       SUM(is_purchase) AS '# purchase',
       1.0*SUM(is_home_try_on)/COUNT(user_id) AS 'quiz to home',
       1.0*SUM(is_purchase)/SUM(is_home_try_on) AS 'home to purchase'
FROM conversions
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;

-- Find the most common results of the quiz
SELECT style, COUNT(style)
FROM quiz
GROUP BY style
ORDER BY COUNT(style) DESC;

SELECT fit, COUNT(fit)
FROM quiz
GROUP BY fit
ORDER BY COUNT(fit) DESC;

SELECT shape, COUNT(shape)
FROM quiz
GROUP BY shape
ORDER BY COUNT(shape) DESC;

SELECT color, COUNT(color)
FROM quiz
GROUP BY color
ORDER BY COUNT(color) DESC;

-- Find the most common styles purchases by gender
SELECT product_id, COUNT(product_id), style, model_name, color
FROM purchase
GROUP BY product_id
ORDER BY style, COUNT(product_id) DESC;
