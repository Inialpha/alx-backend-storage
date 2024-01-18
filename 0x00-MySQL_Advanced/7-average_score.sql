-- A SQL script that creates a stored procedure ComputeAverageScoreForUser that

DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;

DELIMITER $$

CREATE PROCEDURE ComputeAverageScoreForUser(user_id INT)

BEGIN
    DECLARE avg_score INT;

    SELECT AVG(score) INTO avg_score
    FROM corrections
    WHERE corrections.user_id = user_id;

    UPDATE users SET average_score = avg_score
    WHERE id = user_id;
END $$
DELIMITER ;
