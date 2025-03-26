#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

# teams : team_id name
# games : game_id year round winner_id opponent_id winner_goals opponent_goals

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # get team_id
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    # if not found
    if [[ -z $TEAM_ID_W ]]
    then
      # insert 
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      # get 
      TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    fi
    # get team_id
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    # if not found
    if [[ -z $TEAM_ID_O ]]
    then
      # insert major
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      # get new major_id
      TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS);")
  fi
done
