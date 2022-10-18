use Banking
SELECT
	(Clients.FirstName + ' ' + Clients.LastName) AS FullName,
	(SELECT SUM(Accounts.Balance_Overall)
	 FROM Accounts
	 WHERE Accounts.cliens_Id = Clients.Id) AS BalanceSum,

	(SELECT ISNULL(SUM(Cards.Balance), 0) 
	 FROM Cards
		LEFT JOIN Accounts ON Accounts.cliens_Id = Clients.Id
	 WHERE Cards.account_id = Accounts.ID) AS CardsSum,

	(SELECT ABS(SUM(DISTINCT Accounts.Balance_Overall) - ISNULL(SUM(Cards.balance), 0))
	 FROM Accounts
		LEFT JOIN Cards ON Accounts.ID = Cards.account_id
	 WHERE Accounts.cliens_Id = Clients.Id) AS MoneyAvailable
FROM Clients
