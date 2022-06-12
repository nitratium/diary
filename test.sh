CURRENT_DATE="$(date +%d)/$(date +%m)/$(date +%Y)"
UNFORMATTED_DATE="11/06/2022"

IFS='/' # DELIMETER
read -ra IN_DATE_ARR <<< "$UNFORMATTED_DATE"
read -ra CUR_DATE_ARR <<< "$CURRENT_DATE"

FUTURE=false

    
if (( ${IN_DATE_ARR[2]} > ${CUR_DATE_ARR[2]} )); then
  FUTURE=true

elif (( ${IN_DATE_ARR[2]} == ${CUR_DATE_ARR[2]} )); then

  if (( ${IN_DATE_ARR[1]} > ${CUR_DATE_ARR[1]} )); then
    FUTURE=true

  elif (( ${IN_DATE_ARR[1]} == ${CUR_DATE_ARR[1]} )); then

    if (( ${IN_DATE_ARR[0]} > ${CUR_DATE_ARR[0]} )); then
      FUTURE=true
    fi
  fi
fi

echo $FUTURE
