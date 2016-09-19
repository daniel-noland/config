#!/usr/bin/zsh
source $HOME/.bin/ratLibrary.sh
# pick action based on incoming argument
case "$1" in

   "scan")
      scanAllGroups
   ;;

   "inc")
      changeToGroupNumber $(getNextGroupNumber)
   ;;

   "dec")
      changeToGroupNumber $(getPreviousGroupNumber)
   ;;

   "sendn")
      sendWindowToNextGroup
   ;;

   "sendp")
      sendWindowToPreviousGroup
   ;;

   "follown")
      followWindowToNextGroup
   ;;

   "followp")
      followWindowToPreviousGroup
   ;;

   "swap")
      swapScreens
   ;;

   *)
      echo "invalid option $1"
      exit 1;
   ;;
esac

return 0
