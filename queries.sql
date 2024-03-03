-- In this SQL file there are the typical SQL queries users will run on this database

-- Getting the top 5 players with highest rating on the website.
SELECT `username`, `rating` FROM `world_rankings` LIMIT 5;

-- Getting all the information about a player from the players table given a specific username.
SELECT * FROM `players` WHERE `username` = 'desired_username';

-- Getting summary game statistics from the view given a specific username
SELECT * FROM `summary_game_statistics` WHERE `username` = 'desired_username';

-- Retrieving summary game statistics from the view for games involving a specific player, identified by their username.
SELECT * FROM `summary_game_statistics` WHERE `game_id` IN (
    SELECT `id` FROM `games` WHERE `player_1` = (
        SELECT `id` FROM `players` WHERE `username` = 'desired_username'
    ) OR `player_2` = (
        SELECT `id` FROM `players` WHERE `username` = 'desired_username'
    )
);

-- Getting the player id, their username and total number of wins given a specific username.
SELECT `players`.`id`, `players`.`username`, `player_statistics`.`wins` FROM `players`
JOIN `player_statistics` ON `player_statistics`.`player_id` = `players`.`id`
WHERE `players`.`username` = 'desired_username';

-- Inserting into the players table in case a new person registers on the website.
INSERT INTO `players` (`username`, `password`, `rating`)
VALUES
(`desired_username`, `password_hashed`, 1200.0);

-- Deleting information about a player when the delete their account.
DELETE FROM `players`
WHERE `username` = 'desired_username';

-- Inreasing the rating of a player after they win a game
UPDATE `players`
SET `rating` = `rating` + 12.23
WHERE `username` = 'desired_username';
