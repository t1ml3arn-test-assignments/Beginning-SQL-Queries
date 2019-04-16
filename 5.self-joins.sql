-- What are the names of the coaches?
select 
  distinct m.firstname || ' ' || m.lastname "Coach Name"
    from member c
    join member m on c.coach = m.memberid
;
  
-- How many students has each of the coach ?
select m.coach, 
	count(m.firstname || ' ' || m.lastname) as Trainee
  from member m
  -- coach field can be NULL
  -- that means a member does not have a coach
  where coach is not null
  group by 1
;

-- Which members does not have a coach ?
select * from member where coach is null;

-- which members have a coach
select * from member where coach is not null;

-- What is the name of Jane Gilmore's coach? 
select c.firstname, c.lastnamefrom member m
  join member c on m.coach = c.memberid 
  where m.firstname = 'Jane' and m.lastname = 'Gilmore'
;

-- Is anyone being coached by someone with a higher handicap? 
select 
  m.firstname || ' ' || m.lastname Trainee, 
  m.handicap as "Trainee handicap",
  c.firstname || ' ' || c.lastname Coach, 
  c.handicap as "Coach handicap"
  from member m
    join member c on m.coach = c.memberid
    where m.handicap < c.handicap
;

-- Are any women being coached by men?
select
  m.firstname || ' ' || m.lastname Trainee,
  m.gender,
  c.firstname || ' ' || c.lastname Coach,
  c.gender
  from member m
    join member c on m.coach = c.memberid
    where m.gender='F' and c.gender='M'
  order by 3
;

-- list members and their coaches
select
  m.firstname || ' ' || m.lastname Trainee,
  c.firstname || ' ' || c.lastname Coach
  from member m
    join member c on m.coach = c.memberid
;

-- Who Coaches the Coaches ?
-- To answer this we need to make self join three times!
select distinct
  c.firstname || ' ' || c.lastname coach,
  cc.firstname || ' ' || cc.lastname "his/her coach"
  from member m 
    join member c on m.coach = c.memberid
    join member cc on c.coach = cc.memberid
;

/* Question involving "BOTH" */

-- Which members have entered both tournaments 24 and 36?
select distinct m.firstname, m.lastname
  from entry a, entry b, member m
  where a.memberid = b.memberid
	      and a.tourid = 24 and b.tourid = 36
	      and a.memberid = m.memberid
;
-- or
select 
 distinct m.firstname, m.lastname
 from entry a
  join entry b using (memberid)
  join member m using (memberid)
  where a.tourid = 24 and b.tourid = 36
;

