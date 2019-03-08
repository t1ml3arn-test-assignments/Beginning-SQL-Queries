Insert into Type values ('Junior',150);
Insert into Type values ('Senior',300);
Insert into Type values ('Social',50);

Insert into Tournament values (24,'Leeston','Social');
Insert into Tournament values (25,'Kaiapoi','Social');
Insert into Tournament values (36,'WestCoast','Open');
Insert into Tournament values (38,'Canterbury','Open');
Insert into Tournament values (40,'Otago','Open');

Insert into Team values ('TeamA','Tuesday', null);
Insert into Team values ('TeamB','Monday', null);

Insert into Member VALUES (118,'McKenzie','Melissa','Junior','963270', 30, '2005-05-28', NULL, NULL,'F');
Insert into Member VALUES (138,'Stone','Michael','Senior','983223', 30, '2009-05-31', NULL, NULL,'M');
Insert into Member VALUES (153,'Nolan','Brenda','Senior','442649', 11, '2006-08-12', NULL,'TeamB','F');
Insert into Member VALUES (176,'Branch','Helen','Social','589419', NULL, '2011-12-06', NULL, NULL,'F');
Insert into Member VALUES (178,'Beck','Sarah','Social','226596', NULL, '2010-01-24', NULL, NULL,'F');
Insert into Member VALUES (228,'Burton','Sandra','Junior','244493', 26, '2013-07-09', NULL, NULL,'F');
Insert into Member VALUES (235,'Cooper','William','Senior','722954', 14, '2008-03-05', NULL,'TeamB','M');
Insert into Member VALUES (239,'Spence','Thomas','Senior','697720', 10, '2006-06-22', NULL, NULL,'M');
Insert into Member VALUES (258,'Olson','Barbara','Senior','370186', 16, '2013-07-29', NULL, NULL,'F');
Insert into Member VALUES (286,'Pollard','Robert','Junior','617681', 19, '2013-08-13', NULL,'TeamB','M');
Insert into Member VALUES (290,'Sexton�','Thomas','Senior','268936', 26, '2008-07-28', NULL, NULL,'M');
Insert into Member VALUES (323,'Wilcox','Daniel','Senior','665393', 3, '2009-05-18', NULL,'TeamA','M');
Insert into Member VALUES (331,'Schmidt','Thomas','Senior','867492', 25, '2009-04-07', NULL, NULL,'M');
Insert into Member VALUES (332,'Bridges','Deborah','Senior','279087', 12, '2007-03-23', NULL, NULL,'F');
Insert into Member VALUES (339,'Young','Betty','Senior','507813', 21, '2009-04-17', NULL,'TeamB','F');
Insert into Member VALUES (414,'Gilmore','Jane','Junior','459558', 5, '2007-05-30', NULL,'TeamA','F');
Insert into Member VALUES (415,'Taylor','William','Senior','137353', 7, '2007-11-27', NULL,'TeamA','M');
Insert into Member VALUES (461,'Reed','Robert','Senior','994664', 3, '2005-08-05', NULL,'TeamA','M');
Insert into Member VALUES (469,'Willis','Carolyn','Junior','688378', 29, '2011-01-14', NULL, NULL,'F');
Insert into Member VALUES (487,'Kent','Susan','Social','707217', NULL, '2010-10-07', NULL, NULL,'F');

Insert into Entry values (118,24,2014);
Insert into Entry values (228,24,2015);
Insert into Entry values (228,25,2015);
Insert into Entry values (228,36,2015);
Insert into Entry values (235,38,2013);
Insert into Entry values (235,38,2015);
Insert into Entry values (235,40,2014);
Insert into Entry values (235,40,2015);
Insert into Entry values (239,25,2015);
Insert into Entry values (239,40,2013);
Insert into Entry values (258,24,2014);
Insert into Entry values (258,38,2014);
Insert into Entry values (286,24,2013);
Insert into Entry values (286,24,2014);
Insert into Entry values (286,24,2015);
Insert into Entry values (415,24,2015);
Insert into Entry values (415,25,2013);
Insert into Entry values (415,36,2014);
Insert into Entry values (415,36,2015);
Insert into Entry values (415,38,2013);
Insert into Entry values (415,38,2015);
Insert into Entry values (415,40,2013);
Insert into Entry values (415,40,2014);
Insert into Entry values (415,40,2015);

Update Team Set Manager = 239 where TeamName ='TeamA';
Update Team Set Manager = 153 where TeamName ='TeamB';

Update Member Set Coach = 153 where MemberID = 118;
Update Member Set Coach = 153 where MemberID = 228;
Update Member Set Coach = 153 where MemberID = 235;
Update Member Set Coach = 235 where MemberID = 286;
Update Member Set Coach = 235 where MemberID = 290;
Update Member Set Coach = 153 where MemberID = 331;
Update Member Set Coach = 235 where MemberID = 332;
Update Member Set Coach = 153 where MemberID = 414;
Update Member Set Coach = 235 where MemberID = 415;
Update Member Set Coach = 235 where MemberID = 461;