#========================================================================== #
# Project Filename:    C:\Program Files\Datanamic\DeZign for Databases V3\GimbleModel.dez#
# Project Name:                                                             #
# Author:                                                                   #
# DBMS:                MySQL 4                                              #
# Copyright:                                                                #
# Generated on:        1/30/2005 8:48:22 AM                                 #
#========================================================================== #

#========================================================================== #
#  Tables                                                                   #
#========================================================================== #

CREATE TABLE player_t (
    player_id INTEGER NOT NULL AUTO_INCREMENT,
    clan_id INTEGER,
    screen_name VARCHAR(40) NOT NULL,
    login_name VARCHAR(40) NOT NULL,
    password VARCHAR(40) NOT NULL,
    email VARCHAR(40),
    elo_rating NUMERIC NOT NULL DEFAULT 1600,
    last_udpate TIMESTAMP,
    PRIMARY KEY (player_id),
    UNIQUE KEY IDX_player_t1(player_id),
    KEY IDX_player_t2(clan_id)
);

CREATE TABLE clan_t (
    clan_id INTEGER NOT NULL AUTO_INCREMENT,
    clan_abbrev VARCHAR(40) NOT NULL,
    clan_name VARCHAR(40) NOT NULL,
    clan_url VARCHAR(80),
    PRIMARY KEY (clan_id),
    UNIQUE KEY IDX_clan_t1(clan_id)
);

CREATE TABLE battle_t (
    battle_id INTEGER NOT NULL AUTO_INCREMENT,
    player_id_winner NUMERIC,
    creation_datetime TIMESTAMP NOT NULL,
    PRIMARY KEY (battle_id),
    UNIQUE KEY IDX_battle_t1(battle_id)
);

CREATE TABLE player_battle_t (
    player_id INTEGER NOT NULL,
    battle_id INTEGER NOT NULL,
    PRIMARY KEY (player_id, battle_id),
    KEY IDX_player_battle_t1(player_id),
    KEY IDX_player_battle_t2(battle_id)
);

#========================================================================== #
#  Foreign Keys                                                             #
#========================================================================== #

ALTER TABLE player_t
    ADD FOREIGN KEY (clan_id) REFERENCES clan_t (clan_id);

ALTER TABLE player_battle_t
    ADD FOREIGN KEY (player_id) REFERENCES player_t (player_id);

ALTER TABLE player_battle_t
    ADD FOREIGN KEY (battle_id) REFERENCES battle_t (battle_id);
