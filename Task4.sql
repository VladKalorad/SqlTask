use Banking
SELECT Type, COUNT(Cards.Number) as 'Amount'
FROM Social_status 
LEFT JOIN Clients c on Social_status.ID = c.social_id
LEFT JOIN Accounts a on c.ID = a.cliens_Id
LEFT JOIN Cards on a.ID = Cards.account_id
GROUP BY Social_status.Type

SELECT Type, (Select COUNT(Cards.Number) FROM Cards
JOIN Clients on Social_status.ID = Clients.social_id
JOIN Accounts on Accounts.cliens_Id = Clients.ID
WHERE Cards.Number = Accounts.Number) AS CardsCount
FROM Social_status
ORDER BY Social_status.Type
