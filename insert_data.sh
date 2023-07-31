#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
    # Check if the line is the CSV header; skip it if it is
    if [[ "$YEAR" == "year" ]]; then
        continue
    fi

    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ -z $winner_id ]]; then
      insert_winner=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      if [[ $insert_winner = "INSERT 0 1" ]]; then
        winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
    fi

    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $opponent_id ]]; then
      insert_opponent=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      if [[ $insert_winner = "INSERT 0 1" ]]; then
        opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi
    fi

    echo $($PSQL "INSERT INTO games(year, round, opponent_id, winner_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$opponent_id', '$winner_id', '$WINNER_GOALS', '$OPPONENT_GOALS')")
done