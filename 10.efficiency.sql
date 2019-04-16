/** INDEXES */

-- Creating index on Member LastName
create index m_lastname_idx on Member(LastName);

-- Drop that index
drop index m_lastname_idx;

-- You cannot create indexes with the same name
create index test_idx on Member(LastName);
-- Error: index test_idx already exists
create index test_idx on Entry(MemberID);

-- Sqlite creates indexes automaticaly for primary keys.
-- It works fro both one-field key and compound keys.

-- Get index info for Entry table
pragma index_info(Entry);
/**
seq         name                      unique      origin      partial
----------  ------------------------  ----------  ----------  ----------
0           sqlite_autoindex_Entry_1  1           pk          0
*/

-- Get info about concrete index
pragma index_info(sqlite_autoindex_Entry_1);
/**
seqno       cid         name
----------  ----------  ----------
0           0           MemberID
1           1           TourID
2           2           Year
*/

-- More info about sql pragmas https://sqlite.org/pragma.html

-- There is a hint to make an index for foreign keys.
-- Let's do some.

-- create indexe on TourID foreign key in Entry table
create index e_tour_id_idx on Entry(TourId);

/* 
    CLUSTERED index.

    That indexing means the data PHYSICALY stored in order of the specific field
    to match the index. There can be ONLY one clustered index.

    In NON-CLUSTERED indexing, physical order does not matter,
    but logical order is specified by the index. 

*/

/** QUERY PLAN */

-- Allows to see how optimizer tackles the query.
-- Execute EXPLAIN QUERY PLAN youre_query to see it.

-- Find all the men who have entered a Leeston tournament.
-- For example both of these queries produce the same plan:
-- 1
explain query plan
select distinct memberid, firstname, lastname from member m
  join entry e using (memberid)
  join tournament t using (tourid)
    where gender='M' and tourname='Leeston'
;
-- 2
explain query plan
select distinct m.memberid, firstname, lastname 
 from member m,entry e, tournament t
 where
  m.memberid=e.memberid and e.tourid=t.tourid
  and t.tourname = 'Leeston' and gender='M'
;
/**  the plan

    |--SCAN TABLE tournament AS t
    |--SCAN TABLE member AS m USING INDEX sqlite_autoindex_Member_1
    |--SEARCH TABLE entry AS e USING COVERING INDEX sqlite_autoindex_Entry_1 (MemberID=? AND TourID=?)
    `--USE TEMP B-TREE FOR DISTINCT

*/