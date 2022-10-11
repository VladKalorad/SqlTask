use Banking

SELECT Accounts.Number, Accounts.Balance_Overall, Cards.balance,
ABS(Accounts.Balance_Overall - SUM(Cards.Balance)) AS Difference
FROM Accounts join Cards on Accounts.ID = Accounts.ID
Group by  Accounts.Number, Cards.balance, Accounts.Balance_Overall