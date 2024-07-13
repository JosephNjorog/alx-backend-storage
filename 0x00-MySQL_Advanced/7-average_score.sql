-- SQL script that creates a stored procedure ComputeAverageScoreForUser that computes and store the average score for a student
DELIMITER $$
CREATE PROCEDURE ComputeAverageScoreForUser (
    IN p_user_id INT
)
BEGIN
    DECLARE projects FLOAT;
    DECLARE scores INT;
    
    SELECT COUNT(DISTINCT project_id) INTO projects FROM corrections WHERE user_id = p_user_id;
    SELECT SUM(score) INTO scores FROM corrections WHERE user_id = p_user_id;
    
    UPDATE users SET average_score = (scores / projects) WHERE id = p_user_id;
END
$$
DELIMITER ;

