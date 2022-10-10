use Banking

SELECT Banks.Name, Cities.Title	
FROM Banks 
Left join Affiliates  on Affiliates.bank_id = Banks.Id
Left join Cities on Affiliates.cities_id = Cities.ID
