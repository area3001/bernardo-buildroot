# Main program flow
while read TIME CODE VALUE; do
case "$CODE" in
  KEY_*)
    if [ $VALUE == 0 ]; then # is pressed
      echo "key $CODE pressed"
    else # is released
      echo "key $CODE released"
    fi;
    ;;
  SYN_REPORT) # Ignore SYN_REPORT keycodes
    ;;
  esac
done;
