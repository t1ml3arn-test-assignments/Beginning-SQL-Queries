/**
 Window functions Provide aggregetes based upon the current row.
 For ranking, running totals(промежуточные итоги), 
 rolling averages(скользящие средние).
 
 Allows to have several different groups 
 or partitions for single query.

 Saddly, but sqliteman does not support window functions.
 Probably the new version https://github.com/rparkins999/sqliteman supports it,
 but there is no build for windows.
 
*/

-- simple average
SELECT COUNT(Handicap) AS Count, AVG(Handicap * 1.0) as Average 
FROM Member; 

-- what if we want to have other data from member ?
-- query below wont work as expected
select 
 member.*, COUNT(Handicap) AS Count, 
 AVG(Handicap * 1.0) as Average
 from member
;
-- this might be useful
select * from member
  join (
    select 
     COUNT(Handicap) AS Count, 
     AVG(Handicap * 1.0) as Average
      from member
);

-- but there is a special solution
-- window function allows combine aggregates with data.
select memberid, firstname, lastname, handicap,
 count(handicap) OVER() as Count,
 ROUND(avg(handicap) OVER(), 2) as AverageHandicap
  from member
;

-- what it brings to us ?
-- well, now we can calc the diff between avg nahdicap
-- and member handicap
select memberid, firstname, lastname, handicap,
  ROUND(avg(handicap) OVER(), 2) as AverageHandicap,
  ROUND(handicap-avg(handicap) OVER(), 2) as Difference
  from member
;

-- can you do it without window function?
select memberid, firstname, lastname, handicap, 
 ROUND(avgh.h, 2) as AverageHandicap,
 ROUND(handicap-avgh.h, 2) as Difference
 from member
 join (select avg(handicap) h from member) AvgH
;
-- Easily. So what's the point for window ?

/** PARTITIONS */

-- With partitions we can have several grouping inside one query,
-- while with GROUP BY we can have ONLY ONE group

-- Get info from Entry table. Show total entries,
-- count of entries by tournament, count of entries
-- by tournament and year in one table
SELECT MemberID, TourID, Year, 
COUNT(*) OVER() as CountAll, 
COUNT(*) OVER(PARTITION BY TourID) AS CountTour, 
COUNT(*) OVER(PARTITION BY TourID, Year) AS CountTourYear 
FROM Entry;

-- Let's ask something by myself

-- Show for each member count of all entries
-- along with count of entries for each tournament
-- that member entered
select memberid, TourID, year,
  count(*) OVER(PARTITION BY memberid) as TotalEntries,
  count(*) OVER(PARTITION BY MemberID, TourID) as TourEntries
   from Entry
;

/** ORDER BY */

-- ORDER BY allows control order of calculating. It can be used inside OVER().

-- Cumulative effect. Run this query to see what it means.
-- Notice the Year and Last Cumulative columns.
SELECT MemberID, TourID, Year, 
COUNT(*) OVER(ORDER BY Year /* DESC */ ) AS Cumulative 
FROM Entry; 
-- NOTE if we add DESC to ORDER BY inside OVER()
-- we will get other results

/** RANKINKG */

-- RANK() set rating based on current row position.
-- If value of Handicap is changing then new Rank value is using. 
SELECT MemberID, Handicap,
RANK() OVER (ORDER BY Handicap) AS Rank 
FROM Member
-- excluding null, otherwise NULL handicap also will be ranked
WHERE Handicap IS NOT NULL
; 

-- Running total on Handicap (dont know for what)
SELECT MemberID, Handicap,
TOTAL(Handicap) OVER (ORDER BY Handicap) AS Total 
FROM Member
; 

/** Combining Ordering with Partitions */

-- While this is possible, there is no good example in the book =\
-- Provided query is related to table which is not exist in db.
-- So basic idea is:
--  Make partition first then order within each partition

-- this query shows 
-- How many concrete tournament there was on each year.
-- Note cumulative effect of TourCount
SELECT MemberID, TourID, Year,
  COUNT(*) OVER(PARTITION BY TourID ORDER BY Year) AS "TourCount",
  COUNT(*) OVER(PARTITION BY TourID, Year) AS CountTourYear 
FROM Entry;

/** Framing */

-- Allows to set which rows to use in a "window".
-- With them we now can see that this is really a WINDOW to process data.

-- Sample query to get averages and 3-month averages
-- NOTE the table is not in the database 
SELECT Month, Area, Income, 
-- This is a default FRAME.
-- Each next row will calculate considering all the prevent rows
    AVG(Income) OVER( 
       PARTITION BY AREA 
       ORDER BY Month 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
    ) AS AreaRunningAverage, 
-- This is a custom FRAME.
-- Each avg calculation is based on 1 previous and 1 next row.
    AVG(Income) OVER( 
       PARTITION BY AREA 
       ORDER BY Month 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING 
    ) AS Area3MonthAverage 
FROM Income; 

/** SUMMARY */

/**
 Window function allows to get both aggregate and detail info
 available in the same query.
*/

/* New practice after some time */

-- trying to print row number
select
 memberid
 , row_number() over w as row_num
 , lastname
 , firstname
 from Member
 window w as (order by memberid);
-- the same result
select
 memberid
 , row_number() over(order by memberid) as row_num
 , lastname
 , firstname
 from Member;
