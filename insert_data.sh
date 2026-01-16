#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"

# reset tables
$PSQL "TRUNCATE games, teams RESTART IDENTITY"

# insert unique teams
cat games.csv | tail -n +2 | cut -d',' -f3,4 | tr ',' '\n' | sort -u |
while read TEAM
do
  $PSQL "INSERT INTO teams(name) VALUES('$TEAM')"
done

# insert games
cat games.csv | tail -n +2 |
while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS)"
done

