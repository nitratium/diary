#!/bin/bash

# THIS SCRIPT IS BEING DEVELOPED BY OZAN YUCEL | github.com/ozanyucell

while(true) { # not sure if this one is working or not
    echo "1. Enter dairy for $(date +%D)."
    echo "2. View or edit an old diary."
    echo "3. Exit."

    read choice

    if (( $choice == 1 )) # what if user tries to crate a diary for twice at the same day?
    then
        read daily_text
        echo "Enter a password for this diary."
        read password
        password = encryption(password)
        echo password > $HOME/dairy/texts/$(date +%D)_$USER.dairy
        echo daily_text >> $HOME/dairy/texts/$(date +%D)_$USER.dairy

    else if (( $choice == 2 ))
    then
        echo "Please enter the password."
        read password
        password = encryption(password)

        echo "Please enter the year"
        read year

        echo "Please enter the month"
        read month

        echo "Please enter the day"
        read day

        cat $HOME/diary/texts/$year_$month_$day_$USER.diary # not sure about this pattern

        echo "1. Edit this diary."
        echo "2. Exit."
        read selection

        if (( $selection == 1 ))
        then
            echo password > $HOME/diary/texts/$year_$month_$day_$USER.diary
            read new_text
            echo new_text >> $HOME/diary/texts/$year_$month_$day_$USER.diary
        else
            continue
        fi

    else
        exit()
    fi
}

function encryption(password) {

}
