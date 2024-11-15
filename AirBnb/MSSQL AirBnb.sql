-- inserts reviews from csv loaded tables
SELECT *
INTO review_la
FROM reviews_la_sep92022

INSERT INTO review_la
SELECT *
FROM reviews_la_dec62022

INSERT INTO review_la
SELECT *
FROM reviews_la_mar72023

INSERT INTO review_la
SELECT *
FROM reviews_la_jun62023

-- checks data
SELECT *
FROM review_la

--count: 5 827 906
-- checks duplicates
SELECT listing_id
	,DATE
	,reviewer_id
	,reviewer_name
	,comments
	,count(*) AS 'count'
FROM review_la
GROUP BY listing_id
	,DATE
	,reviewer_id
	,reviewer_name
	,comments
HAVING count(*) > 1
ORDER BY listing_id
	,count(*)
-- removes the duplicates
WITH cte AS (
		SELECT id
			,listing_id
			,DATE
			,reviewer_id
			,reviewer_name
			,comments
			,ROW_NUMBER() OVER (
				PARTITION BY listing_id
				,DATE
				,reviewer_id
				,reviewer_name
				,comments ORDER BY id
					,listing_id
					,DATE
					,reviewer_id
					,reviewer_name
					,comments
				) row_num
		FROM review_la
		)

DELETE FROM cte WHERE
cte.row_num > 1

SELECT count(*)
FROM review_la

-- 2 056 899 records


-- Listing data combining
SELECT *
INTO listing_la
FROM listing_la_sep92022

--45815 rows inserted
SELECT *
FROM listing_la_sep92022

-- checks the date for verification
SELECT last_scraped
FROM listing_la
GROUP BY last_scraped
ORDER BY last_scraped

INSERT INTO listing_la
SELECT *
FROM listing_la_dec62022

--40438 rows inserted
INSERT INTO listing_la
SELECT *
FROM listing_la_mar72023

--42451 rows inserted
INSERT INTO listing_la
SELECT *
FROM listing_la_jun62023

--44464 rows inserted
------------------------------------------------------------


SELECT host_id
	,last_scraped
	,price * (30 - availability_30) AS projected_revenue_30d
FROM listing_la
GROUP BY host_id
	,last_scraped
	,price * (30 - availability_30)
ORDER BY host_id

SELECT listing_id
	,count(*)
FROM review_la
GROUP BY listing_id
ORDER BY count(*) DESC

------------------------------------------------------------
--misc
------------------------------------------------------------
select top 25
	host_id,
	neighbourhood_cleansed,
	property_type,
avg(price * (30 - availability_30)) AS projected_revenue_30d
from listing_la
where price <2082
group by
	host_id,
	neighbourhood_cleansed,
	property_type
order by projected_revenue_30d desc

select
*
from listing_la
where host_id=385575830