-- SQL script that creates a function SafeDiv that divides (and returns) the first by the second number or returns 0 if the second number is equal to 0
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$ ;
CREATE FUNCTION SafeDiv (
	a INT,
	b INT
)
RETURNS FLOAT
BEGIN
	DECLARE diff FLOAT;
	IF b = 0 THEN
		SET diff = 0;
	ELSE
		SET diff = a / b;
	END IF;
	RETURN diff;
END
$$
DELIMITER ; $$
