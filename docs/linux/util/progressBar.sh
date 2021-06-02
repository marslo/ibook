#!/bin/bash

function is_int() { test "$@" -eq "$@" 2> /dev/null }

# Parameter 1 must be integer
if ! is_int "$1" ; then
   echo "Not an integer: ${1}"
   exit 1
fi

# Parameter 1 must be >= 0 and <= 100
if [ "$1" -ge 0 ] && [ "$1" -le 100 ]  2>/dev/null
then
    :
else
    echo bad volume: ${1}
    exit 1
fi

# Main function designed for quickly copying to another program
progressBar() {
  Bar=""                                  # Progress Bar / Volume level
  Len=25                                  # Length of Progress Bar / Volume level
  Div=4                                   # Divisor into Volume for # of blocks
  Fill="▒"                                # Fill up to $Len
  Arr=( "▉" "▎" "▌" "▊" )                 # UTF-8 left blocks: 7/8, 1/4, 1/2, 3/4

  FullBlock=$((${1} / Div))               # Number of full blocks
  PartBlock=$((${1} % Div))               # Size of partial block (array index)

  while [[ $FullBlock -gt 0 ]]; do
      Bar="$Bar${Arr[0]}"                 # Add 1 full block into Progress Bar
      (( FullBlock-- ))                   # Decrement full blocks counter
  done

  # If remainder zero no partial block, else append character from array
  if [[ $PartBlock -gt 0 ]]; then Bar="$Bar${Arr[$PartBlock]}"; fi

  # Pad Progress Bar with fill character
  while [[ "${#Bar}" -lt "$Len" ]]; do Bar="$Bar$Fill"; done

  echo progress : "$1 $Bar"
  exit 0                                  # Remove this line when copying into program
} # progressBar

Main () {
  tput civis                              # Turn off cursor
  for ((i=0; i<=100; i++)); do
    CurrLevel=$(progressBar "$i")         # Generate progress bar 0 to 100
    echo -ne "$CurrLevel"\\r              # Reprint overtop same line
    sleep .04
  done
  echo -e \\n                             # Advance line to keep last progress
  echo "$0 Done"
  tput cnorm                              # Turn cursor back on
} # Main

Main "$@"
