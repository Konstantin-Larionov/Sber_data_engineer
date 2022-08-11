--CREATE OR REPLACE VIEW report AS 

WITH V AS (
			SELECT User_id, card, TRANSACTION_TIME, max(TRANSACTION_TIME) times
			FROM transactions t
			WHERE lower(Merchant_city) != 'online'
			GROUP BY User_id, card, TRANSACTION_TIME
			HAVING count(DISTINCT Merchant_city) > 1
)

SELECT TRANSACTION_TIME AS fraud_dt,
	   'Операции в разных городах в течение дня' AS Fraud_type,  
	   User_id AS Client_id, 
	   sysdate AS Report_dt  
  FROM transactions t 
 WHERE t.User_id ||','||t.CARD||','||TRANSACTION_TIME in 
						                 (SELECT t1.User_id ||','||t1.CARD||','||t1.TRANSACTION_TIME
											FROM V t1)
																			
union

SELECT t.TRANSACTION_TIME AS fraud_dt,
       'Операция по просроченной карте' AS Fraud_type,
	   t.User_id AS Client_id, 
	   sysdate AS Report_dt  
  FROM transactions t 
  join CARDS c 
    ON t.User_id = c.User_id
   AND t.card = c.card_index 
   AND ADD_MONTHS(to_date(c.expires, 'mm/yyyy'), 1) < t.TRANSACTION_TIME;

