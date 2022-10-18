USE Banking

GO
CREATE FUNCTION GetInvalidRowsCount() RETURNS INT AS 
BEGIN

DECLARE @count INT

SELECT @count =			
	SUM (Cards.Balance)
	FROM Accounts
		JOIN Cards ON AccountNumber = Accounts.Number
	GROUP BY Accounts.Balance
	HAVING Accounts.Balance != SUM (Cards.Balance)
	
	RETURN @count
END
	
GO
CREATE TRIGGER AccountBalanceRestriction
ON Accounts AFTER UPDATE AS
BEGIN
	IF dbo.GetInvalidRowsCount() > 0 ROLLBACK TRAN
END

GO
CREATE TRIGGER CardsBalanceRestriction
ON Cards AFTER UPDATE AS
BEGIN
	IF dbo.GetInvalidRowsCount() > 0 ROLLBACK TRAN
END

GO
BEGIN TRY

	UPDATE Cards --or Accounts
	SET Balance = 1	

END TRY

BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
		   ERROR_MESSAGE() AS ErrorMessage
END CATCH

SELECT
	Accounts.Number AS AccountNumber,
	Accounts.Balance AS AccountBalance,
	ISNULL(SUM(Cards.Balance), 0) AS CardsSum
	FROM Accounts
		LEFT JOIN Cards ON AccountNumber = Accounts.Number
	GROUP BY Accounts.Number, Accounts.Balance
	ORDER BY Accounts.Balance DESC

DROP TRIGGER AccountBalanceRestriction
DROP TRIGGER CardsBalanceRestriction
DROP FUNCTION dbo.GetInvalidRowsCount

