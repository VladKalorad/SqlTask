GO
CREATE PROC TransferFromAccountToCard @accountNumberFrom INT, @cardNumber INT, @moneyTransfer INT AS 
BEGIN

SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRY
BEGIN TRAN

	DECLARE @selectedCardAccountNumber INT
	DECLARE @accountBalance FLOAT
	DECLARE @cardsBalance FLOAT 

	SET @selectedCardAccountNumber = 
		(SELECT account_id
		FROM cards
		WHERE cards.id = @cardNumber) 	

	IF(@selectedCardAccountNumber != @accountNumberFrom)
		THROW 51000, 'Selected card doesnt belong to selected account number',1

	SET @accountBalance = 
		(SELECT balance_overall 
		FROM accounts
		WHERE accounts.id = @accountNumberFrom)

	SET @cardsBalance = 
		(SELECT balance
		FROM cards
		LEFT JOIN accounts
			ON accounts.id = account_id
		WHERE accounts.id = @accountNumberFrom)

	IF(@accountBalance - @cardsBalance >= @moneyTransfer)
		BEGIN 
			UPDATE cards
			SET balance += @moneyTransfer
			FROM cards
			WHERE account_id = @accountNumberFrom AND cards.id = @cardNumber
		END
	ELSE 
		THROW 51000, 'Not enough money',1

END TRY 

BEGIN CATCH
	ROLLBACK TRAN
	;THROW
END CATCH

COMMIT TRAN 
END

GO
CREATE PROC ShowChangings @cardNumber INT AS
BEGIN 

	SELECT accounts.number AS AccountNumber,
			 cards.balance AS 'Card Balance',
			 accounts.balance_overall AS 'Account Balance'
	FROM cards
 JOIN accounts
		ON accounts.id = cards.account_id
	WHERE cards.id = @cardNumber
END 

GO

	DECLARE @from int = 1
	DECLARE @to int = 3
	DECLARE @sumOfMoney FLOAT = 1

	EXEC ShowChangings @to
	EXEC TransferFromAccountToCard @from, @to, @sumOfMoney
	EXEC ShowChangings @to

BEGIN TRY
	EXEC TransferFromAccountToCard @from, @to, 999999999
END TRY

BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber,
		   ERROR_MESSAGE() AS ErrorMessage
END CATCH

GO
DROP PROC ShowChangings
DROP PROC TransferFromAccountToCard