
-- Creating a table that stores information about each player on the website.
CREATE TABLE `players` (
    `id` INT AUTO_INCREMENT,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(64) NOT NULL,
    `rating` DECIMAL(4, 2) NOT NULL DEFAULT 1200.0,
    PRIMARY KEY("id")
);

-- Creating a table that stores basic information about each game played on the website.
CREATE TABLE `games` (
    `id` INT AUTO_INCREMENT,
    `player_1` INT NOT NULL,
    `player_2` INT NOT NULL,
    `color_player_1` ENUM(`white`, `black`) NOT NULL,
    `won` INT NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`player_1`) REFERENCES `players`(`id`),
    FOREIGN KEY(`player_2`) REFERENCES `players`(`id`),
    FOREIGN KEY(`won`) REFERENCES `players`(`id`)
);

-- Creating a table that stores information about friends on the website.
CREATE TABLE `friends` (
    `id` INT AUTO_INCREMENT,
    `player_1` INT NOT NULL,
    `player_2` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`player_1`) REFERENCES `players`(`id`),
    FOREIGN KEY(`player_2`) REFERENCES `players`(`id`)
);

-- Creating a table that stores information about player statistics for each player.
CREATE TABLE `player_statistics` (
    `player_id` INT NOT NULL,
    `wins` INT NOT NULL,
    `draws` INT NOT NULL,
    `losses` INT NOT NULL,
    `average_accuracy` DECIMAL(3,1) NOT NULL,
    PRIMARY KEY(`player_id`),
    FOREIGN KEY(`player_id`) REFERENCES `players`(`id`)
);

-- Creating a table that stores information about game statistics for each game.
CREATE TABLE `game_statistics` (
    `game_id` INT,
    `accuracy_player_1` DECIMAL(3, 1) NOT NULL,
    `accuracy_player_2` DECIMAL(3, 1) NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`game_id`) REFERENCES `games`(`id`)
);

-- Creating a view that contains information about players with their ratings in descending order.
CREATE VIEW `world_rankings` AS
SELECT `id`, `username`, `rating` FROM `players`
ORDER BY `rating` DESC;

-- Creating a view for summary game statistics.
CREATE VIEW `summary_game_statistics` AS
SELECT `players`.`username` as `username`, `game_id`, AVG(`accuracy_player_1`), AVG(`accuracy_player_2`) FROM `game_statistics`
JOIN `games` ON `games`.`id` = `game_statistics`.`game_id`
JOIN `players` `p1` ON `games`.`player_1` = `p1`.`id`
JOIN `players` `p2` ON `games`.`player_2` = `p2`.`id`
GROUP BY `game_id`, `p1`.`username`, `p2`.`username`;

-- Creating a view for friendship durations.
CREATE VIEW `friendship_duration` AS
SELECT `friends`.`id`, `p1`.`username`, `p2`.`username`, `friends`.`start_date`, `friends`.`end_date`
FROM `friends`
INNER JOIN `players` `p1` ON `p1`.`id` = `friends`.`player_1`
INNER JOIN `players` `p2` ON `p2`.`id` = `friends`.`player_2`;


-- Creating a view for game results.
CREATE VIEW `game_results` AS
SELECT `g`.`id`, `p1`.`username` AS `player_1`, `p2`.`username` AS `player_2`,
       `g`.`color_player_1`, `pw`.`username` AS` winner`
FROM `games` `g`
INNER JOIN `players` `p1` ON `g`.`player_1` = `p1`.`id`
INNER JOIN `players` `p2` ON `g`.`player_2` = `p2`.`id`
LEFT JOIN `players` `pw` ON `g`.`won` = `pw`.`id`;

-- Creating an index for usernames available on the players table.
CREATE INDEX `username_index` ON `players` (`username`);

-- Creating an index for game ids from the games table.
CREATE INDEX `game_id_index` ON `games` (`id`);

-- Creating an index for specific cases of player1, player2.
CREATE INDEX `player1_player2_index` ON `games` (player_1, player_2);

-- Creating an index for player id on the player statistics table.
CREATE INDEX `player_id_index` ON `player_statistics` (`player_id`);

-- Creating an index for game id from the game statistics table.
CREATE INDEX `game_statistics_id_index` ON `game_statistics` (`game_id`);

-- Creating an index for player and their games on the player statistics table.
CREATE INDEX `player_game_index` ON `player_statistics` (player_id, game_id);
