-- SQL script that creates a stored procedure ComputeAverageWeightedScoreForUsers that computes and store the average weighted score for all students
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

DELIMITER $$ ;

CREATE PROCEDURE ComputeAverageWeightedScoreForUser (
	IN p_user_id INT
)
BEGIN
	DECLARE sum_score_factor FLOAT;
	DECLARE sum_weights FLOAT;

	SELECT SUM(score * (SELECT weight FROM projects WHERE id = project_id))
	INTO sum_score_factor
	FROM corrections
	WHERE user_id = p_user_id;

	SELECT SUM((SELECT weight FROM projects WHERE id = project_id))
	INTO sum_weights
	FROM corrections
	WHERE user_id = p_user_id;

	UPDATE users SET average_score = (sum_score_factor / sum_weights) WHERE id = p_user_id;
END
$$


CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
	DECLARE scores FLOAT;
	DECLARE num_users INT;
	DECLARE i INT;

	SELECT COUNT(*) INTO num_users FROM users;
	SET i = 1;
	SET scores = 0;

	WHILE i <= num_users DO
		CALL ComputeAverageWeightedScoreForUser(i);		
		SET i = i + 1;
	END WHILE;
END
$$

DELIMITER ; $$
