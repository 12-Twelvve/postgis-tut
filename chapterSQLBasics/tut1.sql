-- create and upload the cities data to the database;
create table cities_data(
    city_id int,
    city_name varchar(100),
    country VARCHAR(100),
    latitude float,
    longitude float,
    population int,
    geom geometry(Point, 4326)  
);

create table countries(
    id int,
    country VARCHAR(100),
    alpha2_code VARCHAR(2),
    alpha3_code VARCHAR(3),
    numeric_code int,
    longitude float,
    latitude float
);

-- copy all non-geometry column directly
copy cities_data(city_id, city_name, country, latitude, longitude, population)
FROM '/tmp/cities.csv' -- permission error so copy the file to tmp folder.
DELIMITER ','
CSV HEADER;

copy countries(id, country, alpha2_code, alpha3_code, numeric_code, longitude, latitude)
FROM '/tmp/countries.csv'
DELIMITER ','
CSV HEADER;

-- update the geometry column using the lat and long
UPDATE cities_data SET geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)

select count(*) from cities_data;

select * from cities_data limit 5;

select DISTINCT country from cities_data limit 10;

select  count(DISTINCT country) from cities_data;

select max(population) from cities_data;

select sum(population) from cities_data;

select * from cities_data ORDER BY country limit 10;

select * from cities_data order by country asc, population desc limit 10;

select * from cities_data where country ='USA';

select * from cities_data where city_name like 'U%'

select * from cities_data where country like '_S_';

select * from cities_data  where country in ('USA', 'CAN', 'CHN');

select count(*) from cities_data where population between 3500000 and 10000000;

-- SQL joins;

select * from countries limit 10;

select * from cities_data inner join countries on cities_data.country = countries.alpha3_code limit 10;

select city_name, cities_data.country as country_code, countries.country from cities_data inner join  countries on cities_data.country = countries.alpha3_code limit 10;

select * from cities_data left join countries on cities_data.country = countries.alpha3_code limit 10;

select * from cities_data right join countries on cities_data.country = countries.alpha3_code limit 10;

select * from cities_data full outer join countries on cities_data.country = countries.alpha3_code limit 10;

-- SQL UNion

select country from cities_data
UNION
select alpha3_code from countries;

-- Aggregation functions

select count(city_name), country from cities_data GROUP BY country order by count(city_name) desc;

select countries.country , count(city_name) from cities_data
left join countries on cities_data.country = countries.alpha3_code
GROUP BY countries.country
ORDER BY count(city_name) DESC;

-- Having clause
select count(city_name), country from cities_data GROUP BY country HAVING count(city_name) > 40 order by count(city_name) desc;    


-- conditional statements
select city_name, population,
CASE
    WHEN population > 10000000 THEN 'Megacity'
    WHEN population > 1000000 THEN 'Large city'
    ELSE 'Small city'
END AS city_category
FROM cities_data;


-- saving results
select * into cities from cities_data;

select count(*) from cities;

drop table if EXISTS cities_usa;

select * into cities_usa from cities_data where country = 'USA';

select count(*) from cities_usa limit 10;

insert into cities_usa select * from cities where country = 'CAN';

select count(*) from cities_usa;

-- Comments in SQL
-- this is a single line comment
/*
 *this is multiline comment
 */
