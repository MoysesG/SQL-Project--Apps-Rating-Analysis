create table appleStore_description_combine as 
select * from appleStore_description1
union ALL
select * from appleStore_description2
union ALL
SELECT* from appleStore_description3
union ALL
select * from appleStore_description4;

--EXPLORATORY DATA ANALYSIS--
---Check The Number of Unique Apps in both TableAppleStore
select count(distinct id) as UniqueAppsIds
from AppleStore

select count(distinct id) as UniqueAppsIds
from appleStore_description_combine

--Check for Any Missing Values in key fieldsAppleStore

select  count(*) as missingvalues
from AppleStore
where track_name is NULL OR user_rating is NULL or prime_genre is null

select count(*) as MissingValues
from appleStore_description_combine
where app_desc is NULL

--Find Out The Number Of Apps per Genre

select prime_genre,
count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps desc

--Get An Overiew Of The Apps Rating

select min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

-----Data Analysis-----

--Determine Whether Paid Apps Have Higher Rating than Free Apps

select CASE
         when price > 0 then 'paid'
         else 'free'
         end as Apps_Type,
         avg(user_rating) as Avg_Rating
from AppleStore
group by Apps_Type

--Check if Apps With more Supported Languages have Higher Rating

select CASE
when lang_num < 10 then '<10_languages'
when lang_num between 10 and 30 then '10-30_languages'
else '>30 languages'
end as Language_Bucket,
avg(user_rating) as avg_rating
from AppleStore
group by Language_Bucket
order by avg_rating desc;

---Check Genre with Low Rating

select prime_genre,
avg(user_rating) as avg_rating
from AppleStore
group by prime_genre
order by avg_rating asc

---check if there is correlaion between the length of the apps description and the user rating
select CASE
           when length(b.app_desc) < 500 then 'short'
           when length(b.app_desc) between 500 and 1000 then 'meduim'
           else 'long' 
           end as description_length_bucket,
           avg(user_rating) as avg_rating
from AppleStore as A
join appleStore_description_combine as b
on a.id=b.id
group by description_length_bucket
order by avg_rating desc;

--Check the Top Rated Apps for Each genre 

select 
prime_genre,
track_name,
user_rating
from(
        SELECT
               prime_genre,
               track_name,
                user_rating,
                rank () over(partition by prime_genre order by user_rating desc,rating_count_tot desc) as rank
  from AppleStore) as a
  where a.rank = 1;
