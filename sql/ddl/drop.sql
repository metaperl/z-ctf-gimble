#========================================================================== #
# DROP SCRIPT                                                               #
#========================================================================== #
# Project Filename:    C:\Program Files\Datanamic\DeZign for Databases V3\GimbleModel.dez#
# Project Name:                                                             #
# Author:                                                                   #
# DBMS:                MySQL 4                                              #
# Copyright:                                                                #
# Generated on:        1/30/2005 8:48:24 AM                                 #
#========================================================================== #

#========================================================================== #
#  Drop Indexes                                                             #
#========================================================================== #
ALTER TABLE player_t DROP INDEX IDX_player_t1;
ALTER TABLE player_t DROP INDEX IDX_player_t2;
ALTER TABLE clan_t DROP INDEX IDX_clan_t1;
ALTER TABLE battle_t DROP INDEX IDX_battle_t1;
ALTER TABLE player_battle_t DROP INDEX IDX_player_battle_t1;
ALTER TABLE player_battle_t DROP INDEX IDX_player_battle_t2;

#========================================================================== #
#  Drop Tables                                                              #
#========================================================================== #
DROP TABLE player_battle_t;
DROP TABLE battle_t;
DROP TABLE clan_t;
DROP TABLE player_t;
