-- A SQL script that creates a stored procedure ComputeAverageWeightedScoreForUser that computes and store the average weighted score for a student

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DELIMITER $$
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(user_id INT)
BEGIN
    DECLARE avg_score DECIMAL(10, 2);
    SELECT SUM(c.score * p.weight) / SUM(p.weight) INTO avg_score
    FROM projects AS p
    JOIN corrections AS c ON p.id = c.project_id
    WHERE c.user_id = user_id;

    UPDATE users SET average_score = avg_score
   WHERE id = user_id;
END $$
DELIMITER ;
