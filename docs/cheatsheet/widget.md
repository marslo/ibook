<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [prompt](#prompt)
  - [linux/osx](#linuxosx)
  - [windows](#windows)
- [weather](#weather)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## prompt

### linux/osx
- [now](https://askubuntu.com/a/1020693/92979)

  <!--sec data-title="now" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  #!/bin/bash

  # NAME: now
  # PATH: $HOME/bin
  # DESC: Display current weather, calendar and time
  # CALL: Called from terminal or ~/.bashrc
  # DATE: Apr 6, 2017. Modified: May 24, 2019.

  # UPDT: 2019-05-24 If Weather unavailable nicely formatted error message.

  # NOTE: To display all available toilet fonts use this one-liner:
  #       for i in ${TOILET_FONT_PATH:=/usr/share/figlet}/*.{t,f}lf; do j=${i##*/}; toilet -d "${i%/*}" -f "$j" "${j%.*}"; done

  # Setup for 92 character wide terminal
  DateColumn=34 # Default is 27 for 80 character line, 34 for 92 character line
  TimeColumn=61 # Default is 49 for   "   "   "   "    61 "   "   "   "

  # Replace Edmonton with your city name, GPS, etc. See: curl wttr.in/:help
  curl wttr.in/Edmonton?0 --silent --max-time 3 > /tmp/now-weather
  # Timeout #. Increase for slow connection---^

  readarray aWeather < /tmp/now-weather
  rm -f /tmp/now-weather

  # Was valid weather report found or an error message?
  if [[ "${aWeather[0]}" == "Weather report:"* ]] ; then
      WeatherSuccess=true
      echo "${aWeather[@]}"
  else
      WeatherSuccess=false
      echo "+============================+"
      echo "| Weather unavailable now!!! |"
      echo "| Check reason with command: |"
      echo "|                            |"
      echo "| curl wttr.in/Edmonton?0    |" # Replace Edmonton with your city
      echo "|   --silent --max-time 3    |"
      echo "+============================+"
      echo " "
  fi
  echo " "                # Pad blank lines for calendar & time to fit

  #--------- DATE -------------------------------------------------------------

  # calendar current month with today highlighted.
  # colors 00=bright white, 31=red, 32=green, 33=yellow, 34=blue, 35=purple,
  #        36=cyan, 37=white

  tput sc                 # Save cursor position.
  # Move up 9 lines
  i=0
  while [ $((++i)) -lt 10 ]; do tput cuu1; done

  if [[ "$WeatherSuccess" == true ]] ; then
      # Depending on length of your city name and country name you will:
      #   1. Comment out next three lines of code. Uncomment fourth code line.
      #   2. Change subtraction value and set number of print spaces to match
      #      subtraction value. Then place comment on fourth code line.
      Column=$((DateColumn - 10))
      tput cuf $Column        # Move x column number
      # Blank out ", country" with x spaces
      printf "          "
  else
      tput cuf $DateColumn    # Position to column 27 for date display
  fi

  # -h needed to turn off formating: https://askubuntu.com/questions/1013954/bash-substring-stringoffsetlength-error/1013960#1013960
  cal > /tmp/terminal1
  # -h not supported in Ubuntu 18.04. Use second answer: https://askubuntu.com/a/1028566/307523
  tr -cd '\11\12\15\40\60-\136\140-\176' < /tmp/terminal1  > /tmp/terminal

  CalLineCnt=1
  Today=$(date +"%e")

  printf "\033[32m"   # color green -- see list above.

  while IFS= read -r Cal; do
      printf "%s" "$Cal"
      if [[ $CalLineCnt -gt 2 ]] ; then
          # See if today is on current line & invert background
          tput cub 22
          for (( j=0 ; j <= 18 ; j += 3 )) ; do
              Test=${Cal:$j:2}            # Current day on calendar line
              if [[ "$Test" == "$Today" ]] ; then
                  printf "\033[7m"        # Reverse: [ 7 m
                  printf "%s" "$Today"
                  printf "\033[0m"        # Normal: [ 0 m
                  printf "\033[32m"       # color green -- see list above.
                  tput cuf 1
              else
                  tput cuf 3
              fi
          done
      fi

      tput cud1               # Down one line
      tput cuf $DateColumn    # Move 27 columns right
      CalLineCnt=$((++CalLineCnt))
  done < /tmp/terminal

  printf "\033[00m"           # color -- bright white (default)
  echo ""

  tput rc                     # Restore saved cursor position.

  #-------- TIME --------------------------------------------------------------

  tput sc                 # Save cursor position.
  # Move up 8 lines
  i=0
  while [ $((++i)) -lt 9 ]; do tput cuu1; done
  tput cuf $TimeColumn    # Move 49 columns right

  # Do we have the toilet package?
  if hash toilet 2>/dev/null; then
      echo " $(date +"%I:%M %P") " | \
          toilet -f future --filter border > /tmp/terminal
  # Do we have the figlet package?
  elif hash figlet 2>/dev/null; then
  #    echo $(date +"%I:%M %P") | figlet > /tmp/terminal
      date +"%I:%M %P" | figlet > /tmp/terminal
  # else use standard font
  else
  #    echo $(date +"%I:%M %P") > /tmp/terminal
      date +"%I:%M %P" > /tmp/terminal
  fi

  while IFS= read -r Time; do
      printf "\033[01;36m"    # color cyan
      printf "%s" "$Time"
      tput cud1               # Up one line
      tput cuf $TimeColumn    # Move 49 columns right
  done < /tmp/terminal

  tput rc                     # Restore saved cursor position.

  exit 0
  ```
  <!--endsec-->

- [another now](https://unix.stackexchange.com/a/434701/29178)

  <!--sec data-title="now" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  # NAME: now
  # PATH: $HOME/bin
  # DESC: Display current weather, calendar and time
  # CALL: Called from terminal or ~/.bashrc
  # DATE: Apr 6, 2017. Modified: Mar 30, 2018.

  # NOTE: To display all available toilet fonts use this one-liner:
  #       for i in ${TOILET_FONT_PATH:=/usr/share/figlet}/*.{t,f}lf; do j=${i##*/}; toilet -d "${i%/*}" -f "$j" "${j%.*}"; done

  # Setup for 92 character wide terminal
  DateColumn=34 # Default is 27 for 80 character line, 34 for 92 character line
  TimeColumn=61 # Default is 49 for   "   "   "   "    61 "   "   "   "

  #--------- WEATHER ----------------------------------------------------------

  # Current weather, already in color so no need to override
  echo " "
  # Replace Edmonton with your city name, GPS, etc. See: curl wttr.in/:help
  curl wttr.in/Edmonton?0 --silent --max-time 3
  # Timeout #. Increase for slow connection---^

  echo " "
  echo " "                # Pad with blank lines for calendar & time to fit

  #--------- DATE -------------------------------------------------------------

  # calendar current month with today highlighted.
  # colors 00=bright white, 31=red, 32=green, 33=yellow, 34=blue, 35=purple,
  #        36=cyan, 37=white

  tput sc                 # Save cursor position.
  # Move up 9 lines
  while [ $((++i)) -lt 10 ]; do tput cuu1; done

  # Depending on length of your city name and country name you will:
  #   1. Comment out next three lines of code. Uncomment fourth code line.
  #   2. Change subtraction value and set number of print spaces to match
  #      subtraction value. Then place comment on fourth code line.

  Column=$(($DateColumn - 10))
  tput cuf $Column        # Move x column number
  printf "          "     # Blank out ", country" with x spaces
  #tput cuf $DateColumn    # Position to column 27 for date display

  # -h needed to turn off formating: https://askubuntu.com/questions/1013954/bash-substring-stringoffsetlength-error/1013960#1013960
  cal -h > /tmp/terminal

  CalLineCnt=1
  Today=$(date +"%d")
  # Prefix with space when length < 2
  if [[ ${#Today} < 2 ]] ; then
      Today=" "$Today
  fi
  printf "\033[32m"   # color green -- see list above.

  while IFS= read -r Cal; do
      printf "$Cal"
      if [[ $CalLineCnt > 2 ]] ; then
          # See if today is on current line & invert background
          tput cub 22
          for (( j=0 ; j <= 18 ; j += 3 )) ; do
              Test=${Cal:$j:2}            # Current day on calendar line
              if [[ "$Test" == "$Today" ]] ; then
                  printf "\033[7m"        # Reverse: [ 7 m
                  printf "$Today"
                  printf "\033[0m"        # Normal: [ 0 m
                  printf "\033[32m"       # color green -- see list above.
                  tput cuf 1
              else
                  tput cuf 3
              fi
          done
      fi

      tput cud1               # Down one line
      tput cuf $DateColumn    # Move 27 columns right
      CalLineCnt=$((++CalLineCnt))
  done < /tmp/terminal

  printf "\033[00m"           # color -- bright white (default)
  echo ""

  tput rc                     # Restore saved cursor position.

  #-------- TIME --------------------------------------------------------------

  tput sc                 # Save cursor position.
  # Move up 9 lines
  i=0
  while [ $((++i)) -lt 10 ]; do tput cuu1; done
  tput cuf $TimeColumn    # Move 49 columns right

  # Do we have the toilet package?
  if hash toilet 2>/dev/null; then
      echo " "$(date +"%I:%M %P")" " | \
          toilet -f future --filter border > /tmp/terminal
  # Do we have the figlet package?
  elif hash figlet 2>/dev/null; then
      echo $(date +"%I:%M %P") | figlet > /tmp/terminal
  # else use standard font
  else
      echo $(date +"%I:%M %P") > /tmp/terminal
  fi

  while IFS= read -r Time; do
      printf "\033[01;36m"    # color cyan
      printf "$Time"
      tput cud1               # Up one line
      tput cuf $TimeColumn    # Move 49 columns right
  done < /tmp/terminal

  tput rc                     # Restore saved cursor position.

  exit 0
  ```
  <!--endsec-->

### windows
- [nijikokun/WinScreeny](https://github.com/nijikokun/WinScreeny)
- [modified WinScreeny](https://askubuntu.com/a/978978/92979)
  <!--sec data-title="winscreeny" data-id="section2" data-show=true data-collapse=true ces-->
  ```bash
  #!/bin/bash
  #
  # Windows Screenfetch (Without the Screenshot functionality)
  # Hacked together by Nijikokun <nijikokun@gmail.com>
  # License: AOL <aol.nexua.org>

  # Downloaded from: https://github.com/nijikokun/WinScreeny
  # Modified from Windows to Windows Subsystem for Linux (Ubuntu initially)

  version='0.4'

  # Displayment
  display=( Host Cpu OS Arch Shell Motherboard HDD Memory Uptime Resolution DE WM WMTheme Font )

  # Color Loop
  bld=$'\e[1m'
  rst=$'\e[0m'
  inv=$'\e[7m'
  und=$'\e[4m'
  f=3 b=4
  for j in f b; do
    for i in {0..7}; do
      printf -v $j$i %b "\e[${!j}${i}m"
    done
  done

  # Debugging
  debug=

  Debug () {
      echo -e "\e[1;31m:: \e[0m$1"
  }

  # Flag Check
  while getopts "vVh" flags; do
      case $flags in
          h)
              echo -e "${und}Usage${rst}:"
              echo -e "  screeny [Optional Flags]"
              echo ""
              echo "WinScreeny - A CLI Bash Script to show System Information for Windows!"
              echo ""
              echo -e "${und}Options${rst}:"
              echo -e "    ${bld}-v${rst}                 Verbose / Debug Output"
              echo -e "    ${bld}-V${rst}                 Display script version"
              echo -e "    ${bld}-h${rst}                 Display this file"
              exit;;
          V)
              echo -e "${und}WinScreeny${rst} - Version ${version}"
              echo -e "Copyright (C) Nijiko Yonskai (nijikokun@gmail.com)"
              echo ""
              echo -e "This is free software, under the AOL license: http://aol.nexua.org"
              echo -e "Source can be downloaded from: https://github.com/Nijikokun/WinScreeny"
              exit;;
          v) debug=1 continue;;
      esac
  done

  # Prevent Unix Output
  unameOutput=`uname`GARBAGE
  if [[ "$unameOutput" == 'Linux' ]] || [[ "$unameOutput" == 'Darwin' ]] ; then
      echo 'This script is for Windows, silly!'
      exit 0
  fi

  # Begin Detection
  detectHost () {
      user=$(echo "$USER")
      host=$(hostname)
      [[ "$debug" -eq "1" ]] && Debug "Finding hostname, and user.... Found as: '$user@$host'"
  }

  detectCpu () {
      cpu=$(awk -F':' '/model name/{ print $2 }' /proc/cpuinfo | head -n 1 | tr -s " " | sed 's/^ //')
      [[ "$debug" -eq "1" ]] && Debug "Finding cpu.... Found as: '$cpu'"
  }

  detectOS () {
      os=`uname -r`
  }

  detectArch () {
      arch=`lsb_release -a 2>&1 | awk '{ print $2 " " $3 " " $4}' | head -3 | tail -1`
      [[ "$debug" -eq "1" ]] && Debug "Finding Architecture.... Found as: '$arch'"
  }

  detectHDD () {
      size=`df -H |  awk '{ print $2}' | head -2 | tail -1 | tr -d '\r '`
      free=`df -H |  awk '{ print $4 }' | head -2 | tail -1 | tr -d '\r '`

  }

  detectResolution () {
      width=`/mnt/c/Windows/System32/wbem/WMIC.exe desktopmonitor get screenwidth | grep -vE '[a-z]+' | tr -d '\r\n '`
      height=`/mnt/c/Windows/System32/wbem/WMIC.exe desktopmonitor get screenheight | grep -vE '[a-z]+' | tr -d '\r\n '`
  }

  detectUptime () {
      uptime=`awk -F. '{print $1}' /proc/uptime`
      secs=$((${uptime}%60))
      mins=$((${uptime}/60%60))
      hours=$((${uptime}/3600%24))
      days=$((${uptime}/86400))
      uptime="${mins}m"

      if [ "${hours}" -ne "0" ]; then
        uptime="${hours}h ${uptime}"
      fi

      if [ "${days}" -ne "0" ]; then
        uptime="${days}d ${uptime}"
      fi

      [[ "$debug" -eq "1" ]] && Debug "Finding Uptime.... Found as: '$uptime${rst}'"
  }

  detectMemory () {
      total_mem=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
      totalmem=$((${total_mem}/1024))
      free_mem=$(awk '/MemFree/ { print $2 }' /proc/meminfo)
      used_mem=$((${total_mem} - ${free_mem}))
      usedmem=$((${used_mem}/1024))
      mem="${usedmem}MB / ${totalmem}MB"

      [[ "$debug" -eq "1" ]] && Debug "Finding Memory.... Found as: '$mem${rst}'"
  }

  detectShell () {
      myshell=`bash --version | head -1`
      [[ "$debug" -eq "1" ]] && Debug "Finding Shell.... Found as: '$myshell'"
  }

  detectMotherboard () {
      board=`/mnt/c/Windows/System32/wbem/WMIC.exe baseboard get product | tail -2 | tr -d '\r '`
  }

  detectDE () {
      winver=`/mnt/c/Windows/System32/wbem/WMIC.exe os get version | grep -o '^[0-9]'`
      if [ "$winver" == "7" ]; then
          de='Aero'
      elif [ "$winver" == "6" ]; then
          de='Aero'
      else
          de=$winver
      fi
      [[ "$debug" -eq "1" ]] && Debug "Finding Desktop Environment.... Found as: '$de'"
  }

  detectWM () {
      vcxsrv=`/mnt/c/Windows/System32/tasklist.exe | grep -o 'vcxsrv' | tr -d '\r \n'`
      wind=`/mnt/c/Windows/System32/tasklist.exe | grep -o 'Windawesome' | tr -d '\r \n'`
      if [ "$vcxsrv" = "vcxsrv" ]; then
          wm="VcXsrv"
      elif [ "$wind" = "Windawesome" ]; then
          wm="Windawesome"
      else
          wm="DWM"
      fi
      [[ "$debug" -eq "1" ]] && Debug "Finding Window Manager.... Found as: '$wm'"
  }

  detectWMTheme () {
      themeFile="$(/mnt/c/Windows/System32/reg.exe query 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes' /v 'CurrentTheme' | grep -o '[A-Z]:\\.*')"
  #   theme=$(echo $themeFile | awk -F"\\" '{print $NF}' | grep -o '[0-9A-z. ]*$' | grep -o '^[0-9A-z ]*')
      theme=$themeFile
      [[ "$debug" -eq "1" ]] && Debug "Finding Window Theme.... Found as: '$theme'"
  }

  detectFont () {
  #   font=$(cat $HOME/.minttyrc | grep '^Font=.*' | grep -o '[0-9A-Za-z ]*$')
      font="Consolas"
      [[ "$debug" -eq "1" ]] && Debug "Finding Font.... Found as: '$font'"
  #   if [ -z $font ]; then
  #       font="Lucida Console"
  #   fi
  }

  # Loops :>
  for i in "${display[@]}"; do
      [[ "${display[*]}" =~ "$i" ]] && detect${i}
  done

  # Output

  cat << EOF

  $f1         ,.=:^!^!t3Z3z.,
  $f1        :tt:::tt333EE3                  ${f6}${user}${f7}@${f6}${host}
  $f1        Et:::ztt33EEE  $f2@Ee.,      ..,
  $f1       ;tt:::tt333EE7 $f2;EEEEEEttttt33#   ${f6}OS: ${f7}${os} ${arch}
  $f1      :Et:::zt333EEQ.$f2 SEEEEEttttt33QL   ${f6}CPU: ${f7}${cpu}
  $f1      it::::tt333EEF $f2@EEEEEEttttt33F    ${f6}HDD free / size: ${f7}$free / $size
  $f1     ;3=*^\`\`\`'*4EEV $f2:EEEEEEttttt33@.    ${f6}Memory used / size: ${f7}${mem}
  $f4     ,.=::::it=., $f1\` $f2@EEEEEEtttz33QF     ${f6}Uptime: ${f7}$uptime
  $f4    ;::::::::zt33)   $f2'4EEEtttji3P*      ${f6}Resolution: ${f7}$width x $height
  $f4   :t::::::::tt33.$f3:Z3z..  $f2\`\` $f3,..g.      ${f6}Motherboard: ${f7}$board
  $f4   i::::::::zt33F$f3 AEEEtttt::::ztF       ${f6}Shell: ${f7}$myshell
  $f4  ;:::::::::t33V $f3;EEEttttt::::t3        ${f6}DE: ${f7}$de
  $f4  E::::::::zt33L $f3@EEEtttt::::z3F        ${f6}WM: ${f7}$wm
  $f4 {3=*^\`\`\`'*4E3) $f3;EEEtttt:::::tZ\`        ${f6}WM Theme: ${f7}$theme
  $f4             \` $f3:EEEEtttt::::z7          ${f6}Font: ${f7}$font
  $f3                 $f3'VEzjt:;;z>*\`        $rst

  EOF
  ```
  <!--endsec-->

## weather
- [wttr.in](https://wttr.in/:help)
- [openweathermap](https://openweathermap.org/)
  - [One Call API 3.0](https://openweathermap.org/api/one-call-3)

  - lat & lon
    ```bash
    $ curl -g "https://api.openweathermap.org/geo/1.0/direct?q=San%20Jose&limit=5&appid=<api-key>"

    # i.e. Santa Clara City
    $ /usr/bin/curl -sg "https://api.openweathermap.org/geo/1.0/direct?q=Santa%20Clara&limit=5&appid=<api-key>" |
                   jq -r '.[] | select(.state == "California") | (.lat|tostring) + " : " + (.lon|tostring)'
    37.3541132 : -121.955174
    ```

  - weather
    ```bash
    $ /usr/bin/curl -sg "https://api.openweathermap.org/data/3.0/onecall?lat=37.3541132&lon=-121.955174&units=metric&appid=<api-key>" |
                    jq -r .current
    {
      "dt": 1691720508,                         # date -d @<secs>
      "sunrise": 1691673584,                    # date -d @<secs>
      "sunset": 1691723206,                     # date -d @<secs>
      "temp": 24.13,                            # °C : units=metric
      "feels_like": 24.17,                      # °C : units=metric
      "pressure": 1013,
      "humidity": 60,
      "dew_point": 15.88,                       # °C : units=metric
      "uvi": 0.26,
      "clouds": 40,                             # %
      "visibility": 10000,                      # m == 10.0km
      "wind_speed": 8.75,                       # m/s
      "wind_deg": 350,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "description": "scattered clouds",
          "icon": "03d"
        }
      ]
    }

    # unscramble
    # date:
    $ TZ=America/Los_Angeles date -d @1691720508
    Thu Aug 10 19:21:48 PDT 2023
    $ TZ=America/Los_Angeles date -d @1691673584
    Thu Aug 10 06:19:44 PDT 2023
    $ TZ=America/Los_Angeles date -d @1691723206
    Thu Aug 10 20:06:46 PDT 2023
    ```

- [uriel1998/weather.sh](https://github.com/uriel1998/weather.sh)
  - [How to start using professional collections](https://openweathermap.org/appid)
- [szantaii/bash-weather](https://github.com/szantaii/bash-weather)


## others
- [ruanyf/simple-bash-scripts](https://github.com/ruanyf/simple-bash-scripts/tree/master/scripts)
