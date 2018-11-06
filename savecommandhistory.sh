#!/usr/bin/sudo bash

## This script is created to store history command output day by day.
## Bash disables history in noninteractive shells by default, but you can turn it on.
## Resource: https://unix.stackexchange.com/questions/5684/history-command-inside-bash-script

HISTFILE=~/.bash_history
set -o history

tarih=`date |awk '{print $2 $3 $6}'`

history > /home/ugur.ersoy/EveryDayScripts/Historyofhistory/$tarih.ug
