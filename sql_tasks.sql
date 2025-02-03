--- a. 
---     rating score algorithm that accounts for rating category weights
WITH validratings AS (
SELECT 
    rating, 
    rating_max, 
    weight,
    SAFE_DIVIDE(rating, NULLIF(rating_max, 0)) * 100 AS normalized_rating
FROM
     `zendesk.manual_rating_test`
WHERE 
    rating IS NOT NULL AND rating <> 42)
SELECT 
CASE WHEN SUM(weight) > 0 THEN SAFE_DIVIDE(SUM(normalized_rating * weight), SUM(weight)) ELSE 0 END AS final_score
FROM 
    validratings;

--- b. 
---     average score for each ticket in autoqa_ratings_test
SELECT 
    external_ticket_id, 
    AVG(score) AS average_score
FROM `zendesk.autoqa_ratings_test`
WHERE score IS NOT NULL
GROUP BY external_ticket_id
ORDER BY average_score DESC;

--- c.
---     the average review score for each reviewee in manual_reviews_test.csv table if the reviewee has two or more reviews

WITH reviewcounts AS (
SELECT 
    reviewee_id, 
    COUNT(score) AS review_count, 
    AVG(score) AS average_score
FROM 
    `zendesk.manual_reviews_test`
WHERE 
    score IS NOT NULL
GROUP BY reviewee_id)
SELECT 
    reviewee_id, 
    average_score
FROM 
    reviewcounts
WHERE 
    review_count >= 2
ORDER BY average_score DESC;