USE Banking
 
GO
CREATE PROCEDURE AddsTenDollarsToEachBankAccounts
@IdSocialStatus INT
AS
BEGIN

DEClARE @LinkedStatusToAccount INT = ( Select Count(*) 
FROM Accounts JOIN Clients ON Clients.ID = Accounts.cliens_Id
WHERE social_id = @IdSocialStatus)
IF @LinkedStatusToAccount = 0
	THROW 50000, 'The record does not exist.', 1;  
ELSE 
	UPDATE Accounts
	SET Balance_Overall = Balance_Overall + 10
	FROM Accounts JOIN Clients on Clients.ID = Accounts.cliens_Id
	WHERE social_id = @IdSocialStatus;
	PRINT 'Money added'
END

GO
DECLARE @SelectLinkedStatusToAccount INT = 4
EXEC AddsTenDollarsToEachBankAccounts @SelectLinkedStatusToAccount
DROP PROCEDURE AddsTenDollarsToEachBankAccounts
