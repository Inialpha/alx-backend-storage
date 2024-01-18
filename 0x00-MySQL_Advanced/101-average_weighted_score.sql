-- A SQL script that creates a stored procedure ComputeAverageWeightedScoreForUsers
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE user_id_var INT;
    DECLARE avg_score DECIMAL(10, 2);

    -- Cursor to iterate through each user
    DECLARE user_cursor CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET user_id_var = NULL;

    OPEN user_cursor;

    user_loop: LOOP
        FETCH user_cursor INTO user_id_var;

        IF user_id_var IS NULL THEN
            LEAVE user_loop;
        END IF;

        -- Calculate average weighted score for the current user
        SELECT SUM(c.score * p.weight) / SUM(p.weight)
        INTO avg_score
        FROM corrections AS c
        JOIN projects AS p ON p.id = c.project_id
        WHERE c.user_id = user_id_var;

        -- Update the user's average_score
        UPDATE users
        SET average_score = avg_score
        WHERE id = user_id_var;
    END LOOP;

    CLOSE user_cursor;
END $$

DELIMITER ;

