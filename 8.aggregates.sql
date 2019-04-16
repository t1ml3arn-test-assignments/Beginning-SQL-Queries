-- gives count of members which have a coach
-- note in such particular way NULL values does not count
select count(coach) from member;

-- find count of members WITHOUT a coach
select count(*) from member where coach is null;

-- proof that count() counts NOT NULL values
select count(coach) from member where coach is null;
-- finds 0, but should be 10 (at the moment of checking)

select membertype, avg(handicap) from member
--where membertype is not null and handicap is not null
group by 1;

select count(*) from member where handicap is null;

select avg(handicap) from member;

select round(avg(handicap), 2) from member;

-- handicap statistics
select max(handicap) Maximum, min(handicap) Minimum,
  round(avg(handicap), 2) Average 
from member;

-- handicap statistics by gender
SELECT Gender, MIN(Handicap)as Minimum, Max(Handicap)as Maximum, 
       ROUND(AVG(Handicap),1) AS Average 
FROM Member 
GROUP BY Gender;

-- find tournaments where was 3 or more entries
SELECT TourID, Year, COUNT(*) AS NumEntries 
FROM Entry 
GROUP BY TourID, Year 
HAVING NumEntries >= 3;

-- let's change previous query to
-- find out which members have entered more than 
-- four Open tournaments
-- 1. find all Open tournaments
select tourid from tournament where tourtype='Open';
-- 2. get the members who entered Open tour
select distinct memberid from entry
where tourid in 
 (select tourid from tournament 
  where tourtype='Open'
  )
;
-- 3. get the final query with aggregates
select memberid, count(tourid) entries
  from entry
  where tourid in (select tourid from tournament
		  where tourtype='Open')
  group by memberid
  having entries >= 4
;
-- the same but with names
select firstname||' '||lastname member, count(e.tourid) Entries
  from entry e
    join member using(memberid)
    join tournament t on e.tourid=t.tourid
  where tourtype='Open'
group by memberid
having entries >= 4
-- we can also do ordering on aggregate
order by entries DESC;

/**   Using Aggregates to Perform Division Operations  */

-- find those members who have entered every tournament

-- 1. take a look at all unique entries
select distinct memberid, tourid from entry;
-- 2. take a look at all unique tournaments
select tourid from tournament;

-- answer question with aggregate
SELECT firstname||' '||lastname Member 
FROM Entry e
NATURAL JOIN Member 
GROUP BY MemberID 
HAVING COUNT(DISTINCT TourID) = 
     (SELECT COUNT(DISTINCT TourID) FROM Tournament)
;

/** Nested Queries and Aggregates */

-- find members who have entered more than three tournaments?
-- 1. without nested
select member.* from entry
  natural join member
group by memberid
having count(tourid) > 3
;
-- 2. with nested
select * from member m
where (select count(tourid) from entry e
       where m.memberid=e.memberid) > 3
;

-- Noted as harder:
-- find the average number of tournaments entered by members
/** 
 I need:
 - total entries T
 - entries of each member E(i)
 - ANG(i) = T / E(i)'
 What is an AVG() ? it is SUM() divided by quantity
*/
-- total entries
select count(*) from entry;
-- entries of each member
select count(*) from entry group by memberid;
-- find sum of entries
select SUM(c) from 
 (select count(*) c from entry group by memberid)
;
-- Final result 
-- so simple, but not every SQL engines support this
select AVG(c) from 
 (select count(*) c from entry group by memberid)
;

-- the problem with aliases
-- more correct solution with proper alias using
select AVG(numEntries.count) as "AVG entry count" from 
 (select count(*) count 
  from entry group by memberid) as numEntries
;

/** 
 Still there is no answer for question 
 from the previous chapter
 
 Who had entered ALL the Open tournaments ?
*/

-- this is easier than I think =\
-- lets join Entry and Tournament and left only open tours
select * from entry
 natural join tournament
where tourtype='Open';

-- then let's find how many each member entered open tours
select 
 memberid, count(tourid)
  from entry
  natural join tournament where tourtype='Open'
group by 1;

-- a little middle step to COUNT of all Open tours
select count(tourid) from tournament where tourtype='Open';

-- final answer:
-- using an aggregate and HAVING to filter
-- note distinct - we dont want to get EVERY entry
select 
 firstname||' '||lastname Member, 
 count(tourid) EntryCount
  from entry e
   natural join tournament 
   join member m on m.memberid=e.memberid
  where tourtype='Open'
 group by m.memberid
 having
 -- Note DISTINCT cause we need DIFFERENT tournaments.
 -- Without distinct we can get results where
 -- member entered 3 open tournaments (there is total 3 open tours)
 -- but 2 of them are the same.
   count(distinct tourid) >= (select count(tourid) from tournament 
                  where tourtype='Open')
;