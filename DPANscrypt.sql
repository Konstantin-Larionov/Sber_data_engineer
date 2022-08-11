INSERT INTO DPAN (mas,num)
SELECT substr(card_number, 1, 6)||','||user_id||','||card_index||','||substr(card_number, -4, 4) mas,
	   card_number num
FROM cards;

COMMIT;

UPDATE CARDS
   SET card_number = substr(card_number, 1, 6)||','||user_id||','||card_index||','||substr(card_number, -4, 4);
  
COMMIT;

