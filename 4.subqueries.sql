-- select all members id participating in Open tournaments
select distinct memberid from entry
  where tourid in (
	select tourid from tournament
	where tourtype='Open'
);

-- do the same but with JOIN
select distinct memberid from entry
  natural join tournament
  where tourtype='Open'
;

-- what if want to obtain members which NOT PARTICIPATING
-- in Open tournaments ? Let's try just ask NOT IN
select distinct memberid from entry
  where tourid NOT IN (
	select tourid from tournament
	where tourtype='Open'
);

/**
 We will get 415 id, but actually that member also
 was participating in Open tournaments. Hmmm...
*/

-- Find members which not participating in Open tournaments
-- select all members in Open tournament (1)
-- select all members from member(!) table which is not in (1) set
select memberid from member
  where memberid NOT IN (
    -- selecting all participators of Open
    select distinct memberid from entry
      natural join tournament
        where tourtype='Open')
;

-- whether any junior members have a lower handicap
-- than the average for seniors ?
select * from member
  where membertype='Junior'
	and handicap < (
	  select avg(handicap) from member
	    where membertype='Senior')
;

-- find all members which participated 
-- at least in one tournament
select firstname, lastname from member m
  where exists (select * from entry e
		where e.memberid = m.memberid)
;

/** A subquery returning a single value */

-- Find the tournaments that member Cooper has entered
select distinct tourname, year, tourtype 
  from entry natural join tournament 
  where memberid = (select memberid from member 
		    where lastname = 'Cooper')
;

-- the same as above buth with a join
-- instead of nested select
select distinct tourname, year from entry e
  natural join member
  join tournament t on e.tourid=t.tourid
  where lastname = 'Cooper'
;

-- the only(?) way to use natual join twice
select distinct tourname, year from tournament
  natural join (
    select * from entry 
    natural join member 
    where lastname = 'Cooper'
);

/** A subquery returning a set of single values  */

-- Find all the entries for an Open tournament
select * from entry
  where tourid in (select tourid from tournament 
		   where tourtype='Open')
;

-- the same with join
select * from entry
  natural join tournament
  where tourtype='Open';

/** A subquery checking for existence  */

-- Find the names of members that have entered any tournament: 
select lastname, firstname from member m
  where exists (select * from entry e
		where m.memberid=e.memberid)
;

-- the same with join
select distinct lastname, firstname from member
  natural join entry;

-- Constructing queries with negatives 
-- Find the names of members who have not entered a tournament:
select firstname, lastname from member
  where memberid NOT IN (select distinct memberid from entry)
;

-- Comparing values with the results of aggregates 
-- Find the names of members with handicaps less than the average:
select firstname || ' ' || lastname from member
  where handicap < (select avg(handicap) from member)
;

-- Update data 
-- Add a row in the Entry table 
-- for every junior for tournament 25 in 2016
insert into entry (memberid, tourid, year)
  select memberid, 25, 2016 from member 
    where membertype='Junior'
;
