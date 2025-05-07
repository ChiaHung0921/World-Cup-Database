 #! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != "winner" ]]
  then
    # get team_id
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")

    # if not found
    if [[ -z $team_id ]]
    then
      # insert name
      insert_name=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $insert_name == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $winner
      fi
    fi
  fi

  if [[ $opponent != "opponent" ]]
  then
    # get team_id
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    # if not found
    if [[ -z $team_id ]]
    then
      # insert name
      insert_name=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $insert_name == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
      fi
    fi
  fi

  if [[ $winner != "winner" ]]
  then 
    # get winner_id via teams table
    search_of_winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  fi

  if [[ $opponent != "opponent" ]]
  then 
    # get opponent_id via teams table
    search_of_opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  fi

  # insert info
  insert__info=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', '$search_of_winner_id', '$search_of_opponent_id', $winner_goals, $opponent_goals)")
done
