#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~~ MY SALON ~~~~\n"


MAIN_MENU() {

if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

AVAILABLE_SERVICES=$($PSQL "Select service_id, name from services order by service_id") 

echo -e "\nWelcome to My Salon, how can I help you?\n"

echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
do
echo  "$SERVICE_ID) $NAME"
done

echo -e "\nInput the service number you would like to take."
read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
      then
        
        MAIN_MENU "That is not a valid service number."
      else
       SERVICE_SELECTED=$($PSQL "Select name from services where service_id = $SERVICE_ID_SELECTED")

      if [[ -z $SERVICE_SELECTED ]]
      then
      MAIN_MENU "I could not find that service. What would you like today?"
       else

  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_VERIFY=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_VERIFY ]]
  then 
  echo -e "\nI don't have a record for that phone number, what's your name?"

  read CUSTOMER_NAME
  INSERT_NEW_CUSTOMER=$($PSQL "insert into customers(name , phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your $(echo $SERVICE_SELECTED | sed -r 's/^ *//'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
read SERVICE_TIME

INSERT_SERVICE_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values( '$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

echo -e "\nI have put you down for a $(echo $SERVICE_SELECTED | sed -r 's/^ *//') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."

 fi
fi
}

MAIN_MENU