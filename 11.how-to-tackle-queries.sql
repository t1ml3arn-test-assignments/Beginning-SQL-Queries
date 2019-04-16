-- Find all the men who have entered a Leeston tournament.
-- We need info from 3 tables: Member, Entry, Tournaments.
-- Lets join them first

select *
    from member m
        join entry e using (memberid)
        join tournament t using (tourid)
;

-- next filter only men and Leeston tour
select *
    from member m
        join entry e using (memberid)
        join tournament t using (tourid)
    where gender='M' and tourname='Leeston'
;
-- we see 3 rows with for the same member,
-- lets rid of them in the final query
select distinct m.memberid, firstname, lastname
    from member m
        join entry e using (memberid)
        join tournament t using (tourid)
    where gender='M' and tourname='Leeston'
;
/*
    MemberID    FirstName   LastName
    ----------  ----------  ----------
    286         Robert      Pollard
    415         William     Taylor
*/

-- We need to join that three table very often
-- for various questions. So we can create a VIEW
-- as temp table and then filter data from that VIEW.
create VIEW AllTourInfo AS
    select *
    from member m
        join entry e using (memberid)
        join tournament t using (tourid)
;
/*
    One important thing about this view - NOT ALL
    sql engines support this syntax cause there are
    duplicate fields like memberid and tourid.
    If this is the case - consider to write
    ALL the needed fields witho duplicates instead of *,
    or give different ALIASES to duplicates.
*/

-- Now rewrite query for men in Leeston with new VIEW
select distinct memberid, lastname, firstname
from AllTourInfo
where gender='M' and tourname='Leeston'
;

/* Spotting KEYWORDS in questions */

-- AND, BOTH, ALSO

-- Rule of a thumb - if we can get data from ONE single row
-- of a table, then we write simple WHERE condition.
-- But if the data cames from TWO rows, consider SELF JOIN
-- (or other type of join).

-- Find male juniors
select * from member
where gender='M' AND membertype='Junior';

-- Find women and children
select * from member
where gender='F' OR membertype='Junior';

-- Find member which entered BOTH 24 and 36 tournamens
select distinct memberid 
 from entry a join entry b using (memberid)
where a.tourid=24 and b.tourid=36;
-- query above can be also answered with INTERSECT

-- NOT, NEVER
-- As with previous, need to know
-- if we can get data from one row or from more rows

-- Find the members who are NOT seniors.
select * from member where membertype!='Senior';

-- Find members who have NEVER entered tournaments
select * from member m
where not exists (select * from entry e where m.memberid = e.memberid);
-- OR (this gives less steps in QUERY PLAN)
select * from member m
  left join entry e on (m.memberid=e.memberid)
where tourid is null;
-- OR (looks like THE BEST solution)
select * from member
where memberid not in (select memberid from entry);
-- OR with EXCEPT
select memberid from member except
select memberid from entry;

-- ALL, EVERY

-- Work for DIVISION operator.

-- Find members who have entered every open tournament.
-- (was answered already, look behind)

-- Has anyone coached all the juniors?
-- The question is ambigious:
--   Has a coach ONLY junior trainees ?
--   Has a coach EVERY junior trainee ?
--   Has a coach ONLY and EVERY junior trainee ?

-- All the juniors
select memberid from member where membertype='Junior';

-- All the coaches and theirs trainees
select coach, memberid Trainee from member
where coach is not null
order by coach;

-- Find a coach which coaches ALL(or EVERY) junior member
-- (Find a coach who coaches EVERY junior trainee)
-- There is no such a coach. But we can modify Member.
-- Create a tmp table and update its values
create table member_old as select * from member;
update member_old set coach=153 where memberid=414;
update member_old set coach=153 where memberid=286 or memberid=469;
-- Final query gives us id=153. 
-- So all trainees of that coach are juniors
select m.memberid from member_old m
where not exists(
  select memberid from member_old m1 where membertype='Junior'
  and not exists (
    select coach, memberid Trainee from member_old m2
    where coach is not null
      and m.memberid=m2.coach
      and m1.memberid=m2.memberid
  )
);

-- One more hard question
-- Which teams have a coach as their manager?

-- No coach, obviously wrong answer
select * from team join member on manager=memberid;
-- We can see TeamB manager (153) is also a coach for 235
select * from team join member on teamname=team
order by teamname;
-- My answer
select  
 teamname Team
--  ,t.manager "Manager and Coach ID",
--  b.firstname, b.lastname
  from team t
   join member a on teamname=a.team
   -- join to get the name of a manager
   --join member b on t.manager=b.memberid
  where t.manager=a.coach
;
-- OR
select teamname from team join member on manager=coach limit 1;
-- OR
select teamname from team t
where exists (select * from member m where t.manager=m.coach);
-- OR (select teams which manager is a coach)
select teamname from team
where manager in (select coach from member where coach is not null);