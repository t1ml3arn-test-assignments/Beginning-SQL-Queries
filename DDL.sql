CREATE TABLE Type(
	Type Char(20) Primary Key,
	Fee smallint NULL);

CREATE TABLE Member(
	MemberID smallint Primary Key,
	LastName Char(20),
	FirstName Char(20),
	MemberType Char(20) References Type(Type),
	Phone Char(20),
	Handicap smallint,
	JoinDate date,
	Coach smallint References Member(MemberID),
	Team Char(20) References Team(TeamName),
	Gender Char(1));

CREATE TABLE Tournament(
	TourID smallint Primary Key,
	TourName Char(20) NULL,
	TourType Char(20) NULL);

CREATE TABLE Entry(
	MemberID smallint References Member(MemberID),
	TourID smallint References Tournament(TourID),
	Year smallint,
Primary Key (MemberID, TourID, Year));

CREATE TABLE Team(
	TeamName Char(20) Primary Key,
	PracticeNight Char(20),
	Manager smallint References Member(MemberID));
