#!/bin/bash

# THIS SCRIPT IS BEING DEVELOPED BY OZAN YUCEL | github.com/ozanyucell

function menu() {
    CHOICE=$(dialog --menu "Welcome $USER" 12 45 25 1 "Enter dairy for $(date +%D)." 2 "View or edit an old diary." 3 "Exit."\
        3>&1 1>&2 2>&3 3>&- \ 
        # if you are curious about what is happening on the line above, check here: https://stackoverflow.com/questions/29222633/bash-dialog-input-in-a-variable
    )
}

function sub_menu() {
    CHOICE=$(dialog --menu "Welcome $USER" 12 45 25 1 "Edit this diary." 2 "Exit."\
        3>&1 1>&2 2>&3 3>&- \ 
    )
}

function passwordbox() {   # --passwordbox <text> <height> <width> [<init>]
    PASSWORD=$(dialog --passwordbox "Password" 10 20\
        3>&1 1>&2 2>&3 3>&- \
    )
}

function password_encryption() { # passwords is in $PASSWORD

}

function text_encryption() { # Diary inputs are in $DIARY_INPUT
    
}

function calendar() {
    DATE=$(dialog --calendar "Calendar" 5 50 $(date +%d) $(date +%m) $(date +%Y)\
        3>&1 1>&2 2>&3 3>&- \
    )
}

function infobox() {
    dialog  --infobox "$DATE" 15 30   # --infobox <text> <height> <width>
}

function inputbox() {   # --inputbox <text> <height> <width> [<init>]
    DIARY_INPUT=$(\
        dialog \
        --inputbox "Diary for $DATE_INPUT" 30 50 "$DIARY_INPUT" \
        3>&1 1>&2 2>&3 3>&- \
    )
}

while true 
do
    menu

    if (( $CHOICE == 1 )) # what if user tries to crate a diary for twice at the same day?
    then
        inputbox

        passwordbox
        #take password and input into variables here

        password_encryption
        text_encryption

        echo password > $HOME/diary/texts/$(date +%D)_$USER.dairy
        echo daily_text >> $HOME/diary/texts/$(date +%D)_$USER.dairy # here needs to be encrypted

    else if (( $CHOICE == 2 ))
    then
        echo "Please enter the password."
        read password
        password = encryption(password)

        calendar

        cat $HOME/diary/texts/$DATE_$USER.diary # not sure about this pattern, date returns dd/mm/yy. it will collide with path's pattern

        sub_menu # MISSING CODE HERE

        if (( $CHOICE == 1 ))
        then # NEEDS ENCRYPTION
            echo password > $HOME/diary/texts/$year_$month_$day_$USER.diary
            read new_text
            echo new_text >> $HOME/diary/texts/$year_$month_$day_$USER.diary
        else
            continue
        fi

    else
        exit()
    fi
done
