select * from trips;

select * from trips_details4;

desc trips;
desc trips_details1;

Rename table trips_details4 to trips_details;
select * from trips_details;

select * from loc;

select * from duration;

select * from payment;
use oladb;
select * from trips_details where end_ride =1; 

#--total trips

select count(distinct tripid) from trips_details;
select tripid,count(*) as cnt from trips_details
group by tripid
having count(tripid)>1; #--hence no duplicates of trip id.

#--total drivers

select * from trips;

select count(distinct driverid) from trips;
#-- So there are 30 distinct drivers.


-- total earnings

select sum(fare) from trips;

-- total Completed trips

select * from trips_details;
select sum(end_ride) from trips_details;

#--total searches
select sum(searches) from trips_details; 
#,sum(searches_got_estimate),sum(searches_for_quotes),sum(searches_got_quotes),
#sum(customer_not_cancelled),sum(driver_not_cancelled),sum(otp_entered),sum(end_ride)
#from trips_details;

#--total searches which got estimate
select sum(searches_got_estimate) as pricecheck from trips_details;

#--total searches for quotes
select sum(searches_for_quotes) as drives_got from trips_details; 

#--total searches which got quotes
select sum(searches_got_quotes) as drives_got from trips_details; 

select * from trips;
select * from trips_details;

#--total driver cancelled
select count(*) - sum(driver_not_cancelled) as tot_driver_cancelled from trips_details;
# OR
select count(driver_not_cancelled) from trips_details where driver_not_cancelled=0; 

#--total otp entered
select sum(otp_entered) as OTP_entered from trips_details;

#--total end ride
select sum(end_ride) as succes_ride from trips_details;


#--cancelled bookings by driver
select count(driver_not_cancelled) from trips_details where driver_not_cancelled=0; 

#--cancelled bookings by customer
select count(driver_not_cancelled) from trips_details where driver_not_cancelled=1; 

#--average distance per trip
select avg(distance) from trips;

#-average fare per trip
select avg(fare) from trips;

select sum(fare)/count(*) from trips;

#--distance travelled
select sum(distance) from trips;

#-- which is the most used payment method 
select * from trips;
select * from loc;
select * from payment;
select distinct faremethod,count(distinct tripid) as cnt,sum(fare) as tot from trips
group by faremethod
order by cnt desc ;
#or
SELECT p.method, t.faremethod, COUNT(DISTINCT t.tripid) AS cnt
FROM payment AS p
INNER JOIN trips AS t ON p.id = t.faremethod
GROUP BY p.method, t.faremethod
ORDER BY cnt DESC;


#-- the highest payment was made through which instrument
#--------- ans is above 

#-- which two locations had the most trips
SELECT t.loc_from, t.loc_to, COUNT(t.loc_to) AS trips, t.driverid, l.assembly1 as location
FROM trips AS t 
INNER JOIN loc AS l ON t.driverid = l.id 
GROUP BY t.loc_from, t.loc_to, t.driverid, l.assembly1 
order by trips desc
LIMIT 2;

#--top 5 earning drivers
select * from trips;
with cte as (select driverid,fare,
             dense_rank() over (order by fare desc ) as rankk from trips)
             select driverid,fare,rankk from cte where rankk <= 5 ;
             
with cte as (select driverid, fare,
dense_rank() over (order by fare desc) as rankk from trips)
select driverid, fare, rankk from cte
where rankk <= 5;

#-- which duration had more trips
select * from duration;
select duration,count(distinct tripid) from trips
group by duration;
 
 select * from
( select *, dense_rank() over (order by cnt desc)  as rnk from 
 (select duration,count(distinct tripid) as cnt from trips
 group by duration )as b) as c where rnk<=5;
 
#-- which driver , customer pair had more orders
select * from
(select *, rank() over (order by cnt desc) as rnk from 
(select driverid,custid,count(distinct tripid) cnt from trips 
group by driverid,custid)c)d
where rnk=1;

#-- search to estimate rate
select * from trips_details;
select (sum(searches_got_estimate)/sum(searches))*100 as estimateRate from trips_details;


#-- which area got highest trips in which duration
select * from trips;
select * from duration;
select * from loc;
select * from
(select *, rank() over (partition by duration order by cnt desc) as rnk from
(select duration,loc_from,count(distinct tripid) as cnt from trips
group by duration,loc_from)a )c
where rnk=1;
