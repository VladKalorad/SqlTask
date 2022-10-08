CREATE DATABASE Banking;

GO
Use Banking

Create table Banks
(
	Id INT PRIMARY KEY identity(1,1),
	Name Varchar(50) not null,
)
Create table Cities 
(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Title VARCHAR(50) not null,
)
Create table Affiliates
(
	ID INT PRIMARY KEY IDENTITY(1,1),
	bank_id int references Banks(id),
	cities_id int references Cities(id),
)
Create table Social_status
(
	ID INT Primary key identity(1,1),
	Type Varchar(20) not null,
)
Create table Clients
(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Firstname varchar(50) not null,
	LastName varchar(50) not null,
	social_id int references Social_status(id),
)
Create table Accounts
( 
	ID INT PRIMARY KEY IDENTITY(1,1),
	Number Varchar(50) not null,
	Balance_Overall Float not null,
	banks_id int references Banks(id),
	cliens_Id int references Clients(id),
)
Create table Cards
(
	ID int primary key identity(1,1),
	Number varchar(16) not null,
	Cvv int not null,
	balance float not null,
	account_id int references Accounts(id),
)