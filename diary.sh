#!/bin/bash

# THIS SCRIPT IS BEING DEVELOPED BY OZAN YUCEL & MERT YILDIZ | github.com/ozanyucell & github.com/myildiz21

function menu() {
    CHOICE=$(dialog --menu "Welcome $USER" 12 45 25 1 "Enter dairy for $(date +%D)." 2 "View an old diary." 3 "Exit."\
        3>&1 1>&2 2>&3 3>&- \
        # if you are curious about what is happening on the line above, check here: https://stackoverflow.com/questions/29222633/bash-dialog-input-in-a-variable
    )
    clear
}

function passwordbox() {   # --passwordbox <text> <height> <width> [<init>]
    PASSWORD=$(dialog --passwordbox "Password" 10 20\
        3>&1 1>&2 2>&3 3>&- \
    )
    clear
}

function calendar() {
    UNFORMATTED_DATE=$(dialog --calendar "Calendar" 5 50 "$(date +%d) $(date +%m) $(date +%Y)"\
        3>&1 1>&2 2>&3 3>&- \
    )
    clear
    DATE=$(echo "$UNFORMATTED_DATE" | sed s/"\/"/"-"/g)
}

# --infobox <text> <height> <width>
function infobox() {
    dialog  --infobox "$TEXT" 15 30
    clear
    # not sure if we need to use clear here. probably yes
}

# --inputbox <text> <height> <width> [<init>]
function inputbox() {
    DIARY_INPUT=$(\
        dialog \
        --inputbox "Diary for $DATE_INPUT" 30 50 "$DIARY_INPUT" \
        3>&1 1>&2 2>&3 3>&- \
    )
    clear
}

# for locking the diary https://www.tecmint.com/create-password-protected-zip-file-in-linux/
function file_to_zip() {
    zip -p "$PASSWORD" "$FILE_PATH.zip" "$FILE_PATH.diary"
}

# for unlocking the diary https://www.shellhacks.com/create-password-protected-zip-file-linux/
function zip_to_file() {
    unzip -p "$PASSWORD" "$ZIP_PATH"
}

while true
do
    menu

    # Enter diary for current date
    if (( CHOICE == 1 )) 
    # what if user tries to crate a diary for twice at the same day?
    then
        # takes password and input into variables here
        inputbox
        passwordbox

        FILE_PATH="$HOME/diary/$(date +%d)-$(date +%m)-$(date +%Y)-$USER"

        echo "$DIARY_INPUT" >> "$FILE_PATH.diary"
        
        # converts file into zip with password
        file_to_zip

        # deletes the unprotected diary file
        rm "$FILE_PATH.diary"

    # view an old diary
    elif (( CHOICE == 2 ))
    then
        # pick date and password
        calendar
        passwordbox

        # unlock zip with the password taken and extract
        ZIP_PATH="$HOME/diary/$DATE-$USER.zip"
        zip_to_file

        # save the content into a variable
        FILE_PATH="$HOME/diary/$DATE-$USER.diary"
        TEXT=$(cat "$FILE_PATH")

        # print content to screen
        infobox

        # remove unsecured file
        rm "$FILE_PATH"

    # exit
    elif (( CHOICE == 3 ))
    then
        # exit the script
        exit

    else
        TEXT="Please enter a valid option."
        infobox
        continue
    fi
done
