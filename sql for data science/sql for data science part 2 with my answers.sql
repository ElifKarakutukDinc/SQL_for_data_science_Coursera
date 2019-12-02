--part2:
--1. Pick one city and category of your choice and group the businesses in that city or category by their overall star rating. Compare the businesses with 2-3 stars to the businesses with 4-5 stars and answer the following questions. Include your code.
select c.business_id, stars, category, city, hours, review_count, latitude, longitude 
from business as b
inner join category as c on (b.id=c.business_id)
inner join hours as h on (h.business_id=c.business_id)
where city='Las Vegas' and category='Restaurants' ;

--i. Do the two groups you chose to analyze have a different distribution of hours?
select  c.business_id, stars, category, city, hours, review_count, latitude, longitude, 
       case WHEN B.stars BETWEEN 2 AND 3 THEN '2-3 stars'
	   WHEN B.stars BETWEEN 4 AND 5 THEN '4-5 stars'
	   END AS star_rating
from business as b
inner join category as c on (b.id=c.business_id)
inner join hours as h on (h.business_id=c.business_id)
where city='Las Vegas' and category='Restaurants' and (stars BETWEEN 2 AND 3 OR stars BETWEEN 4 AND 5)
group by hours
order by star_rating ASC; 

--My review: Yes two groups have a different distribution of hours. 


--ii. Do the two groups you chose to analyze have a different number of reviews?

select  c.business_id, stars, category, city, hours, review_count, latitude, longitude, 
       case WHEN B.stars BETWEEN 2 AND 3 THEN '2-3 stars'
	   WHEN B.stars BETWEEN 4 AND 5 THEN '4-5 stars'
	   END AS star_rating
from business as b
inner join category as c on (b.id=c.business_id)
inner join hours as h on (h.business_id=c.business_id)
where city='Las Vegas' and category='Restaurants' and (stars BETWEEN 2 AND 3 OR stars BETWEEN 4 AND 5)
group by review_count
order by star_rating ASC; 

+------------------------+-------+-------------+-----------+----------------------+--------------+----------+-----------+-------------+
| business_id            | stars | category    | city      | hours                | review_count | latitude | longitude | star_rating |
+------------------------+-------+-------------+-----------+----------------------+--------------+----------+-----------+-------------+
| 1CP8aJa8ILlfM5deroar0Q |   3.0 | Restaurants | Las Vegas | Saturday|11:00-0:00  |          123 |  36.1003 |   -115.21 | 2-3 stars   |
| 1aj4TG0eFq6NaPBKk6bK7Q |   4.0 | Restaurants | Las Vegas | Saturday|11:00-20:00 |          168 |  36.1933 |  -115.304 | 4-5 stars   |
| 1ZnVfS-qP19upP_fwOhZsA |   4.0 | Restaurants | Las Vegas | Saturday|10:00-23:00 |          768 |  36.1267 |   -115.21 | 4-5 stars   |
+------------------------+-------+-------------+-----------+----------------------+--------------+----------+-----------+-------------+

--My review: Yes two groups have a different number of reviews. 4-5 stars group has a lot of more reviews. 

--iii. Are you able to infer anything from the location data provided between these two groups? 

 select  c.business_id, stars, category, city, hours, review_count, latitude, longitude, 
       case WHEN B.stars BETWEEN 2 AND 3 THEN '2-3 stars'
	   WHEN B.stars BETWEEN 4 AND 5 THEN '4-5 stars'
	   END AS star_rating
from business as b
inner join category as c on (b.id=c.business_id)
inner join hours as h on (h.business_id=c.business_id)
where city='Las Vegas' and category='Restaurants' and (stars BETWEEN 2 AND 3 OR stars BETWEEN 4 AND 5)
group by latitude, longitude
order by star_rating ASC; 

+------------------------+-------+-------------+-----------+----------------------+--------------+----------+-----------+-------------+
| business_id            | stars | category    | city      | hours                | review_count | latitude | longitude | star_rating |
+------------------------+-------+-------------+-----------+----------------------+--------------+----------+-----------+-------------+
| 1CP8aJa8ILlfM5deroar0Q |   3.0 | Restaurants | Las Vegas | Saturday|11:00-0:00  |          123 |  36.1003 |   -115.21 | 2-3 stars   |
| 1ZnVfS-qP19upP_fwOhZsA |   4.0 | Restaurants | Las Vegas | Saturday|10:00-23:00 |          768 |  36.1267 |   -115.21 | 4-5 stars   |
| 1aj4TG0eFq6NaPBKk6bK7Q |   4.0 | Restaurants | Las Vegas | Saturday|11:00-20:00 |          168 |  36.1933 |  -115.304 | 4-5 stars   |
+------------------------+-------+-------------+-----------+----------------------+--------------+----------+-----------+-------------+

--My review: Two groups have a different locations. Two business_id have same longitude but their latitude are very different. 


/* 2. Group business based on the ones that are open and the ones that are closed. What differences can you find between 
the ones that are still open and the ones that are closed? List at least two differences and the SQL code you used to arrive at your answer.*/

select is_open, count(id), sum(stars), avg(stars), min(stars), max(stars), sum(review_count), avg(review_count), min(review_count), max(review_count)
from business 
group by is_open;

+---------+-----------+------------+---------------+------------+------------+-------------------+-------------------+-------------------+-------------------+
| is_open | count(id) | sum(stars) |    avg(stars) | min(stars) | max(stars) | sum(review_count) | avg(review_count) | min(review_count) | max(review_count) |
+---------+-----------+------------+---------------+------------+------------+-------------------+-------------------+-------------------+-------------------+
|       0 |      1520 |     5351.0 | 3.52039473684 |        1.0 |        5.0 |             35261 |     23.1980263158 |                 3 |               700 |
|       1 |      8480 |    31198.0 | 3.67900943396 |        1.0 |        5.0 |            269300 |     31.7570754717 |                 3 |              3873 |
+---------+-----------+------------+---------------+------------+------------+-------------------+-------------------+-------------------+-------------------+

/* My review: 
i. Difference 1: Number of stars given of closed business is less than open business.           
         
ii. Difference 2:Number of review done of closed business is less than open business.

iii. Difference 3: Number of open business is more than closed business*/

--category of open business (top 5)
select category, Count(id)
from business as b 
inner join category as c on (b.id= c.business_id)
where is_open=1
group by category
order by Count(id) desc
limit 5; 

+------------------+-----------+
| category         | Count(id) |
+------------------+-----------+
| Restaurants      |        53 |
| Shopping         |        25 |
| Food             |        20 |
| Health & Medical |        16 |
| Home Services    |        15 |
+------------------+-----------+


--category of closed business (top 5)
select category, Count(id)
from business as b 
inner join category as c on (b.id= c.business_id)
where is_open=0
group by category
order by Count(id) desc
limit 5;

+----------------+-----------+
| category       | Count(id) |
+----------------+-----------+
| Restaurants    |        18 |
| Nightlife      |         8 |
| Bars           |         6 |
| Shopping       |         5 |
| American (New) |         3 |
+----------------+-----------+

--Difference 4: most of closed and opened busines category is Restaurant. But second line is changed. Second most of opened business Shopping, Second and thirt most of closed business Nighlife and bars.

/*3. For this last part of your analysis, you are going to choose the type of analysis you want to conduct on the Yelp dataset and are going to prepare the data for analysis.

Ideas for analysis include: Parsing out keywords and business attributes for sentiment analysis, clustering businesses to find commonalities or anomalies between them, predicting the overall star rating for a business, 
predicting the number of fans a user will have, and so on. These are just a few examples to get you started, so feel free to be creative and come up with your own problem you want to solve. Provide answers, in-line, 
to all of the following:
i. Indicate the type of analysis you chose to do:
         
         
ii. Write 1-2 brief paragraphs on the type of data you will need for your analysis and why you chose that data:
                           
                  
iii. Output of your finished dataset:
         
         
iv. Provide the SQL code you used to create your final dataset: