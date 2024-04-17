#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
function GET_TEAM_ID() {
  if [[ $1 ]]
  then 
    TEAM_NAME=$*
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM_NAME';")
    if [[ -z $TEAM_ID ]]
    then
      RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_NAME')")
      if [[ $RESULT == "INSERT 0 1" ]]
      then
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM_NAME';")
      fi
    fi
    echo $TEAM_ID
  fi
}

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    WINNER_TEAM_ID=$(GET_TEAM_ID $WINNER)
    OPPONENT_TEAM_ID=$(GET_TEAM_ID $OPPONENT)
    RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
  fi
done