-- SQL script that creates a stored procedure ComputeAverageWeightedScoreForUser that computes and store the average weighted score for a student
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
DELIMITER ; $$
