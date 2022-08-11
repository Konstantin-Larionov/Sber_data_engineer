DECLARE
ROWS_cnt NUMBER;

BEGIN
	SELECT count(*) 
	  INTO ROWS_cnt
      FROM TRANSACTIONS_PRE;
	
	
	FOR cntr IN 1..Rows_cnt LOOP
	MERGE INTO transactions t
	USING (SELECT to_date(substr(TRANSACTION_TIME, 1, 19), 'yyyy-mm-dd HH24:mi:ss') TRANSACTION_TIME,
					  User_id,
					  CARD,
					  AMOUNT,
					  Use_Chip,
					  Merchant_Name,
					  Merchant_City,
					  Merchant_State,
					  ZIP,
					  MCC,
					  ERR
				FROM transactions_pre
				WHERE n = cntr
				 ) v
	ON (t.TRANSACTION_TIME = v.TRANSACTION_TIME AND t.User_id = v.User_id AND t.CARD = v.CARD)
	
	WHEN MATCHED 
	THEN UPDATE 
	SET t.AMOUNT = v.AMOUNT,
		t.Use_Chip = v.Use_Chip,
		t.Merchant_Name = v.Merchant_Name,
		t.Merchant_City = v.Merchant_City,
		t.Merchant_State = v.Merchant_State,
		t.ZIP = v.ZIP,
		t.MCC = v.MCC,
		t.ERR = v.ERR,
	    t.update_dt = sysdate
	    
	WHEN NOT MATCHED 
	THEN INSERT (t.TRANSACTION_TIME, t.User_id, t.CARD, t.AMOUNT, t.Use_Chip, t.Merchant_Name, t.Merchant_City, t.Merchant_State, t.ZIP, t.MCC, t.ERR, t.create_dt, t.update_dt)
	VALUES (v.TRANSACTION_TIME, v.User_id, v.CARD, v.AMOUNT, v.Use_Chip, v.Merchant_Name, v.Merchant_City, v.Merchant_State, v.ZIP, v.MCC, v.ERR, sysdate, sysdate);    
   
 END LOOP;

COMMIT;
 

END;

