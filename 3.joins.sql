-- this matches every row from one table
-- ot every row in other table
-- pretty useles in its pure form (?)
select * from member cross join type;

-- this inner join the same result as above 
select * from member inner join type;

-- but actually inner join (or just JOIN)
-- allows to set a condition where two tables match
-- with ON (condition) clause
select * from member m inner join type t ON m.membertype = t.type;

-- query above can be transformed into this
select * from member m, type t where m.membertype = t.type;

-- find the names of everyone who entered the Leeston tournament in 2014
select m.firstname || ' ' || m.lastname as Name from entry e
  join tournament t ON e.tourid = t.tourid
  join member m ON m.memberid=e.memberid
  where e.year=2014 AND LOWER(t.tourname)='leeston'
;

-- lets do above query but manualy optimized
-- first we make a cross join but with year and name condition
-- this (I think) gives a much less rows in tmp table
-- then the litle tmp table joins to Member table
select m.firstname || ' ' || m.lastname as Name from entry e
  join tournament t ON (e.tourid = t.tourid AND e.year = 2014 AND LOWER(t.tourname)='leeston')
  join member m ON m.memberid=e.memberid
;

-- Both queries above was writtent wtih proccess approach
-- that answers to question HOW TO GET DATA.
-- Now let's try to the Outcome Approach
-- which asnwers WHAT YOU WANT TO GET

select m.firstname || ' ' || m.lastname as Name
  from member m, entry e, tournament t
    where m.memberid = e.memberid and e.tourid = t.tourid
          and e.year = 2014 and t.tourname='Leeston'
;

/*
Joins seen abose are equi-joins - such joins use EQUALS operator (e.tourid = t.tourid).

NATURAL join assumes your tables have the same name for joining columns.
Thus only ONE column will be left in the result
*/

-- Natural join
select * from entry e
  NATURAL JOIN tournament;