select * from member
  where joindate < '2009-01-01'
  order by joindate DESC;
 
-- find all junor girls 
select * from member
  where lower(membertype) = 'junior' and gender='F';

-- find count of girls for each member type 
select count(*), membertype from member
  where gender = 'F'
  group by membertype
;

--find any rows with null values
select * from member
  where membertype is NULL or phone is null
	or handicap is null or joindate is null
	or coach is null or team is null or gender is null
;

-- find all member which IS NOT females
select * from member where NOT (gender = 'F');

-- ordering
select firstname, lastname, handicap from member
order by handicap DESC;

-- count members with handicap
select count(handicap) from member;
-- count all members
select count(*) from member;
-- note COUNT() does not count NULL values

-- Saving query as view
create view phonelist as
  select lastname || ' ' || firstname as Name, phone from member;