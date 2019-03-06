

CREATE TABLE Type(
	Type Char(20) Primary Key,
	Fee smallint NULL);

CREATE TABLE Member(
	MemberID smallint Primary Key,
	LastName Char(20),
	FirstName Char(20),
	MemberType Char(20) Foreign Key References [Type],
	Phone Char(20),
	Handicap smallint,
	JoinDate date,
	Coach smallint Foreign Key References Member,
	Team Char(20) Foreign Key References Team,
	Gender Char(1));

CREATE TABLE Tournament(
	TourID smallint Primary Key,
	TourName Char(20) NULL,
	TourType Char(20) NULL);

CREATE TABLE Entry(
	MemberID smallint Foreign Key References Member,
	TourID smallint Foreign Key References Tournament,
	Year smallint,
Primary Key (MemberID, TourID, Year));

CREATE TABLE Team(
	TeamName Char(20) Primary Key,
	PracticeNight Char(20),
	Manager smallint Foreign Key References Member);
