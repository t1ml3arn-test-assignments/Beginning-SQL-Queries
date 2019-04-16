-- get all entries which entered both 24 or 36 tournamens
select * from entry where tourid = 24
union
select * from entry where tourid = 36;

-- this is possible with simple OR condition
select * from entry where tourid=24 or tourid=36;

-- get all members which entered both 24 or 36 tournamens
select distinct memberid, firstname, lastname from entry
  natural join member
  where tourid=24 or tourid=36
;

-- at this moment there are 3 types of member
select * from type;
-- updating MemberType table
-- add a Associate type with fee $60
insert into type values('Associate', 60);

-- update member table so it has at least ONE member
-- without member type
select * from member where membertype is null;
update member
  set membertype = NULL
  where memberid = 176
;

-- lets try to join now
-- note there is no info about 176 member
-- cause INNER JOIN
select * from member
  join type on membertype = type
  where membertype is null
;

-- now 176 member is present, but...
select * from member
  left join type on membertype = type
  where membertype is null
;

-- there is still no info abot new Associate member type
select * from member
  left join type on membertype = type
  where membertype = 'Associate'
;

-- to make it present in our join we need a FULL OUTER JOIN
-- but sqlite doesnt have one...
-- so we build some crunch to solve that problem
select member.*, type.* from member 
  left join type on membertype = type
union
select member.*, type.* from type
  left join member on type=membertype
;

/**  INTERSECTION */

-- helps us to answer question involving word 'BOTH'
-- earlier we solved this with join

-- Which members have entered both tournaments 36 and 38?

-- NOTE query below gives us NOTHING. Why?
select * from entry where tourid = 36
intersect
select * from entry where tourid = 38;

/**
first (id = 36) gives us this:

| 228 | 36 | 2015 |
|-----|----|------|
| 415 | 36 | 2014 |
| 415 | 36 | 2015 |

the second (id = 36) gives this

| 235 | 38 | 2013 |
|-----|----|------|
| 235 | 38 | 2015 |
| 258 | 38 | 2014 |
| 415 | 38 | 2013 |
| 415 | 38 | 2015 |
we get NOTHING because there is no common rows =\
so we need to obtain ONLY memberid

*/

-- correct
select memberid from entry where tourid = 36
intersect
select memberid from entry where tourid = 38;

-- now lets try join that to member to get real names
-- instead of integer ids
-- use other tournamens, say 24 and 25
select firstname, lastname from member
  natural join (
    select memberid from entry where tourid = 24
    intersect
    select memberid from entry where tourid = 25
);

-- how will it be using ONLY joins?
-- do you remember?
select firstname, lastname from member
  natural join (
    select distinct a.memberid from entry a
      join entry b on a.memberid = b.memberid
      where a.tourid=24 and b.tourid=25
);
-- just internal query  
select distinct a.memberid from entry a
  join entry b on a.memberid = b.memberid
  where a.tourid=24 and b.tourid=25
;

/** Lets try harder! */

-- find members which entered 2 or more tournaments 
-- in the SAME year
select firstname || ' ' || lastname, year, 
  count(tourid) as "tour count" 
  from entry e
  natural join member
  group by memberid, year
  having "tour count" > 1
  order by 1
;
-- control query to visually check the query above
select * from entry where memberid = 415 and year = 2015;

/** DIFFERENCE */

-- consider difference if there is a question
-- with word NOT

-- find members which DO NOT enter 25 tournament
-- (from those who entered at least 1 tournament)
select memberid from entry
except
select memberid from entry where tourid = 25;
-- the logik is: get set of ALL members
-- remove from that set those
-- who entered 25 tournament

-- how would you answer that question WITHOUT difference ?
-- NOT IN version
select distinct memberid from entry a
  where a.memberid not in (
    select b.memberid from entry b
      where b.memberid = a.memberid
            AND b.tourid = 25
  )
;
-- NOT EXISTS version
select distinct memberid from entry a
  where NOT EXISTS (
    select memberid from entry b
      where a.memberid=b.memberid
            AND b.tourid=25
);
/**
 now ket's answer the same question
 but for ALL the members, not only those
 who entered at least 1 tournament
 
 we need
 - all the members (A)
 - all the members entered 25 tournament (B)
 - diff between them ( A - B )
*/
select memberid from member
except
select memberid from entry where tourid = 25;

-- the same but with names
select firstname || ' ' || lastname Member from member
  natural join (
	select memberid from member except
	select memberid from entry where tourid = 25
  )
;

-- OR the better solution
-- we can join inside except subqueries
select firstname || ' ' || lastname Member from member
except
select firstname || ' ' || lastname from entry e
  natural join member m 
  where tourid=25
;

/** DIVISION */

/**  
 This involves question with word ALL or EVERY.
 SQL does not have keyword for that situations.
 Division can be thinked as OPPOSITE of CARTESIAN product
*/

-- Which members have entered EVERY tournament?
select distinct tourid from tournament; -- gives all possible tournaments
-- gives disrinct count of tours for each participant
select memberid, count(distinct tourid)
  from entry
  group by 1
;
-- the final result
select memberid, firstname||' '||lastname Member
  from entry natural join member
  group by 1
  having 
    count(distinct tourid) = (select count(distinct tourid) 
                              from tournament)
;
-- the question is answered, but the query is not so ellegant

-- how it would be in the better world:
select distinct memberid, tourid from entry;
-- DIVIDE -- (wont work, sad)
select distinct tourid from tournament;

-- Who had entered ALL the Open tournaments ?
-- (implying member can enter not only open tours)
select distinct tourid from tournament where tourtype='Open'; -- R
select distinct memberid, tourid from entry; -- L
-- next we nned to DIVIDE L to the R : L / R
-- I will use the same query (about ALL tournaments)
-- but with new condition
select memberid from entry
  group by 1
  having
    count(distinct tourid)>=(select count(distinct tourid)
                             from tournament
			     where tourtype='Open')
;
/**
 This is not right answer. What if count(distinct tourid)
 in HAVING will give us the same count (say 3)
 as the count of all open tours, but actual count of open
 tours which member had enterd is only 2 ?
*/

-- all members which had entered ALL tournaments
-- in the same year
select memberid, year, firstname||' '||lastname Member
  from entry natural join member
  group by 1,2
  having 
    count(distinct tourid) = (select count(distinct tourid) 
                              from tournament)
;
-- there is NO such a member actually

-- An OUTCOME approach to answer the first question
/**
 Write out the value of m.LastName, m.FirstName from
 rows m in the Member table where for every row 
 t in the Tournament table there exists a row e in the Entry 
 table with e.MemberID = m.MemberID and e.TourID = t.TourID.
 
 OR
 
 Write out the value of m.LastName, m.FirstName from 
 rows m in the Member table where there is no row t 
 in the Tournament table where there does not exist a row e 
 in the Entry table with e.MemberID = m.MemberID and e.TourID = t.TourID. 
*/
SELECT m.LastName||' '||m.FirstName Member FROM Member m 
WHERE NOT EXISTS 
( 
  SELECT * FROM Tournament t 
  WHERE NOT EXISTS 
  ( 
    SELECT * FROM Entry e 
    WHERE e.MemberID = m.MemberID AND e.TourID = t.TourID 
  ) 
);