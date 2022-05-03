#!/bin/bash

echo "$(dialog --passwordbox "Password" 10 20)"

echo "$(dialog  --infobox "Info" 15 30)"

echo "$(dialog  --inputbox "Enter Input" 15 30 "Enter here.")"
