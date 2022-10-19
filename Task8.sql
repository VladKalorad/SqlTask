USE Banking
GO
CREATE FUNCTION MatchingAccountAndCardAccount() RETURNS INT AS 
BEGIN

DECLARE @count INT

SELECT @count =			
	SUM (Cards.balance)
	FROM Accounts
		JOIN Cards ON account_id = Accounts.ID
	GROUP BY Accounts.Balance_Overall
	HAVING Accounts.Balance_Overall != SUM (Cards.balance)
	
	RETURN @count
END
	
GO
CREATE TRIGGER AccountBalanceMismatch
ON Accounts AFTER UPDATE AS
BEGIN
	IF dbo.MatchingAccountAndCardAccount() > 0 ROLLBACK TRAN
END

GO
CREATE TRIGGER CardsBalanceMismatch
ON Cards AFTER UPDATE AS
BEGIN
	IF dbo.MatchingAccountAndCardAccount() > 0 ROLLBACK TRAN
END

GO
BEGIN TRY

	UPDATE Cards
	SET balance = 10	

END TRY

BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
		   ERROR_MESSAGE() AS ErrorMessage
END CATCH

SELECT
	Accounts.Number AS 'Account Number',
	Accounts.Balance_Overall AS 'Account Balance',
	ISNULL(SUM(Cards.balance), 0) AS CardsSum
	FROM Accounts
		LEFT JOIN Cards ON account_id = Accounts.ID
	GROUP BY Accounts.Number, Accounts.Balance_Overall
	ORDER BY Accounts.Balance_Overall DESC

DROP TRIGGER AccountBalanceRestriction
DROP TRIGGER CardsBalanceRestriction
DROP FUNCTION dbo.MatchingAccountAndCardAccount

