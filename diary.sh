#!/bin/bash

# THIS SCRIPT IS BEING DEVELOPED BY OZAN YUCEL & MERT YILDIZ | github.com/ozanyucell & github.com/myildiz21

function menu() {
    CHOICE=$(dialog --menu "Welcome $USER" 12 45 25 1 "Enter dairy for today, $DATE." 2 "Enter a diary for another date." 3 "View an old diary." 4 "Exit."\
        3>&1 1>&2 2>&3 3>&- \
        # if you are curious about what is happening on the line above, check here: https://stackoverflow.com/questions/29222633/bash-dialog-input-in-a-variable
    )
    clear
}

function sub_menu() { # sub menu with yesno dialog for existing diary
    $(dialog --yesno "$TEXT" 10 30\
        3>&1 1>&2 2>&3 3>&- \
    )
    yesno=$?
    clear
}

function passwordbox() {   # --passwordbox <text> <height> <width> [<init>]
    PASSWORD=$(dialog --passwordbox "Password" 10 20\
        3>&1 1>&2 2>&3 3>&- \
    )
    clear
}

function calendar() {
    UNFORMATTED_DATE=$(dialog --calendar "Calendar" 5 50 "$(date +%d)" "$(date +%m)" "$(date +%Y)"\
        3>&1 1>&2 2>&3 3>&- \
    )
    clear
    DATE=$(echo "$UNFORMATTED_DATE" | sed s/"\/"/"-"/g)
}

# --msgbox <text> <height> <width>
function messagebox() {
    dialog --msgbox "$TEXT" 15 30
    clear
}

# --inputbox <text> <height> <width> [<init>]
function inputbox() {
    DIARY_INPUT=$(\
        dialog \
        --inputbox "Diary for $DATE" 30 50 "$OLD_INPUT" \
        3>&1 1>&2 2>&3 3>&- \
    )
    clear
}

# for locking the diary https://www.tecmint.com/create-password-protected-zip-file-in-linux/
function file_to_zip() {
    zip -P "$PASSWORD" "$FILE_NAME.zip" "$FILE_NAME.diary"
}

# for unlocking the diary https://www.shellhacks.com/create-password-protected-zip-file-linux/
function zip_to_file() {
    unzip -P "$PASSWORD" "$ZIP_PATH"
}

mkdir "$HOME/diary/"
# saving the current working directory and changing the current directory to script's directory
# because when I try to give a path into zip command, it zips the whole path, not only the file
cdw=$(pdw)
# we will be using this cdw variable just before the exit option
cd "$HOME/diary/"

while true
do
    DATE="$(date +%d)-$(date +%m)-$(date +%Y)"
    menu

    # Enter diary for current date
    if (( CHOICE == 1 )); then

        FILE_NAME="$(date +%d)-$(date +%m)-$(date +%Y)-$USER"

        # what if user tries to crate a diary for twice at the same day? we may let him/her edit it
        if [ -e "$FILE_NAME.zip" ]; then
            TEXT="You already have written diary for $DATE. Do you want to edit?"
            sub_menu

            if (( yesno == 1 )); then
                continue
            else
                passwordbox
                ZIP_PATH="$HOME/diary/$DATE-$USER.zip"
                zip_to_file

                # for editing the old diary
                FILE_PATH="$HOME/diary/$DATE-$USER.diary"
                OLD_INPUT=$(cat "$FILE_PATH")
                inputbox
                passwordbox

                echo "$DIARY_INPUT" > "$FILE_NAME.diary"

                # converts file into zip with password
                file_to_zip

                # remove the unsecured file
                rm "$FILE_PATH"

                # for going back to menu
                continue
            fi
        fi

        # takes password and input into variables here
        inputbox
        passwordbox

        echo "$DIARY_INPUT" > "$FILE_NAME.diary"

        # converts file into zip with password
        file_to_zip

        # deletes the unprotected diary file
        rm "$FILE_NAME.diary"

    # enter a diary for another date
    elif (( CHOICE == 2 )); then
        calendar
        FILE_NAME="$DATE-$USER"

        if [ -e "$FILE_NAME.zip" ]; then
            TEXT="You already have written diary for $DATE. Do you want to edit?"
            sub_menu

            if (( yesno == 1 )); then
                continue
            else
                passwordbox
                ZIP_PATH="$HOME/diary/$DATE-$USER.zip"
                zip_to_file

                # for editing the old diary
                FILE_PATH="$HOME/diary/$DATE-$USER.diary"
                OLD_INPUT=$(cat "$FILE_PATH")
                inputbox
                passwordbox

                echo "$DIARY_INPUT" > "$FILE_NAME.diary"

                # converts file into zip with password
                file_to_zip

                # remove the unsecured file
                rm "$FILE_PATH"

                # for going back to menu
                continue
            fi
        fi

        # takes password and input into variables here
        inputbox
        passwordbox

        echo "$DIARY_INPUT" > "$FILE_NAME.diary"

        # converts file into zip with password
        file_to_zip

        # deletes the unprotected diary file
        rm "$FILE_NAME.diary"

    # view an old diary
    elif (( CHOICE == 3 )); then
        # pick date and password
        calendar
        ZIP_PATH="$HOME/diary/$DATE-$USER.zip"

        if [ -e "$ZIP_PATH" ]; then
            passwordbox

            # unlock zip with the password taken and extract
            zip_to_file

            # save the content into a variable
            FILE_PATH="$HOME/diary/$DATE-$USER.diary"
            TEXT=$(cat "$FILE_PATH")

            # print content to screen
            messagebox

            # remove unsecured file
            rm "$FILE_PATH"

        else
            TEXT="Diary for given date doesn't exist."
            messagebox
        fi

    # exit
    elif (( CHOICE == 4 )); then
        # exit the script
        cd "$cdw"
        exit
    fi
done
