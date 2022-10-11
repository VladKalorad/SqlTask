use Banking

SELECT (Clients.Firstname + ' ' + Clients.LastName) as FullName, Banks.Name, Cards.balance, Accounts.Number
FROM Accounts
join Banks on Accounts.banks_id = Banks.Id
join Clients on Accounts.cliens_Id = Clients.ID
join Cards on Accounts.ID = Cards.ID
Order by Clients.LastName
