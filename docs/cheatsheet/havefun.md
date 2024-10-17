<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [I'm very busy](#im-very-busy)
- [press any key to continue](#press-any-key-to-continue)
- [fortune](#fortune)
- [simulate type mechine (super cool!!)](#simulate-type-mechine-super-cool)
- [set volume by command](#set-volume-by-command)
- [cat and tac](#cat-and-tac)
- [ASCII chart](#ascii-chart)
- [hate someone](#hate-someone)
- [star war](#star-war)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### I'm very busy
```bash
$ cat /dev/urandom | hexdump -C | grep "ca fe"

# or: https://www.commandlinefu.com/commands/view/6771/pretend-to-be-busy-in-office-to-enjoy-a-cup-of-coffee
$ j=0; while true; do let j=$j+1; for i in $(seq 0 20 100); do echo $i;sleep 1; done | dialog --gauge "Install part $j : `sed $(perl -e "print int rand(99999)")"q;d" /usr/share/dict/words`" 6 40;done

# or: https://www.commandlinefu.com/commands/view/6673/pretend-to-be-busy-in-office-to-enjoy-a-cup-of-coffee
$ for i in `seq 0 100`; do timeout 6 dialog --gauge "Install..." 6 40 "$i"; done

# show quota
$ fortune | pv -qL 10
```

### press any key to continue
```bash
$ read -sn 1 -p "Press any key to continue..." && echo "\n"
Press any key to continue...\n
```

### fortune

- [a random "cow" say a random thing](https://www.commandlinefu.com/commands/view/6019/have-a-random-cow-say-a-random-thing)
  ```bash
  $ fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
  ```

- [loop show](https://www.commandlinefu.com/commands/view/12613/waste-time-for-about-3-minutes)
  ```bash
  $ for i in {1..20}; do fortune -w ; sleep 3; clear; done
  ```

### simulate type mechine (super cool!!)

> [!NOTE|label:references:]
> - [Simulate typing](https://www.commandlinefu.com/commands/matching/pv/cHY=/sort-by-votes)
> - [Simulate typing](https://www.commandlinefu.com/commands/view/7899/simulate-typing)

```bash
$ sudo apt-get intall pv
$ echo "Very very very very very long words" | pv -qL $[10+(-2 + RANDOM%5)]
$ echo "You can simulate on-screen typing just like in the movies" | pv -qL 10

# with mistake: https://www.commandlinefu.com/commands/view/11737/simulate-typing-but-with-mistakes
$ echo -e "You are wa jerk\b\b\b\bwonderful person" | pv -qL $[10+(-2 + RANDOM%5)]

# or
$ sudo apt-get install randtype
$ echo "Very very very very very long words" | randtype -m 4

# or
$ echo "hello world !" | while read x; do for(( i=0; i<${#x}; i++ )); do echo -n "${x:$i:1}"; sleep .06; done; done

# or wth tclsh: https://www.commandlinefu.com/commands/view/13499/mac-osx-friendly-version-of-this-terminal-typing-command-at-200ms-per-key
$ message="I have a nice easy typing pace"; for ((i=0; i<${#message}; i++)); do echo "after 100" | tclsh; printf "${message:$i:1}"; done; echo
```

### set volume by command
```bash
$ pacmd set-sink-volume 0 0x10000
Welcome to PulseAudio! Use "help" for usage information.
```

### cat and tac
```bash
$ cat a_b
1
2
3
$ tac a_b
3
2
1
```

### ASCII chart
```bash
$ figlet Marslo
 __  __                _
|  \/  | __ _ _ __ ___| | ___
| |\/| |/ _` | '__/ __| |/ _ \
| |  | | (_| | |  \__ \ | (_) |
|_|  |_|\__,_|_|  |___/_|\___/

$ toilet marslo
                             ""#
 mmmmm   mmm    m mm   mmm     #     mmm
 # # #  "   #   #"  " #   "    #    #" "#
 # # #  m"""#   #      """m    #    #   #
 # # #  "mm"#   #     "mmm"    "mm  "#m#"

# with fonts
$ date +"%I:%M %P" | figlet -f /usr/local/share/figlet/future.tlf
┏━┓┏━┓ ┏━┓┏━┓   ┏━┓┏┳┓
┃┃┃╺━┫╹╺━┫  ┃   ┣━┫┃┃┃
┗━┛┗━┛╹┗━┛  ╹   ╹ ╹╹ ╹

$ date +"%I:%M %P" | toilet -f future
┏━┓┏━┓ ┏━┓┏━┓   ┏━┓┏┳┓
┃┃┃╺━┫╹╺━┫  ┃   ┣━┫┃┃┃
┗━┛┗━┛╹┗━┛  ╹   ╹ ╹╹ ╹

# with colors
$ toilet --gay -f term
# or
$ toilet --metal -f term

# have fun
$ fortune | toilet -w $(($(tput cols)-5)) -f pagga
░█▀▀░█░█░█▀▀░█▀▀░█▀▀░█▀▀░▀█▀░░░█░█░█▀█░█░█░░░▀▀█░█░█░█▀▀░▀█▀░░░█▀▀░▀█▀░▀█▀░░░▀█▀░█░█░█▀▀░█▀▄░█▀▀░░░█▀█░█▀█░█▀▄░░░█░█░█▀█
░▀▀█░█░█░█░█░█░█░█▀▀░▀▀█░░█░░░░░█░░█░█░█░█░░░░░█░█░█░▀▀█░░█░░░░▀▀█░░█░░░█░░░░░█░░█▀█░█▀▀░█▀▄░█▀▀░░░█▀█░█░█░█░█░░░█▄█░█▀█
░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░░░░▀░░▀▀▀░▀▀▀░░░▀▀░░▀▀▀░▀▀▀░░▀░░░░▀▀▀░▀▀▀░░▀░░░░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░░░▀░▀░▀░▀░▀▀░░░░▀░▀░▀░▀
░▀█▀░▀█▀░░░▀█▀░▀█▀░█░░░█░░░░░█░░░▀█▀░█▀▀░█▀▀░░░█▀▀░█▀▀░▀█▀░█▀▀░░░█▀▀░█▀█░█▀▀░▀█▀░█▀▀░█▀▄░░░
░░█░░░█░░░░░█░░░█░░█░░░█░░░░░█░░░░█░░█▀▀░█▀▀░░░█░█░█▀▀░░█░░▀▀█░░░█▀▀░█▀█░▀▀█░░█░░█▀▀░█▀▄░░░
░▀▀▀░░▀░░░░░▀░░▀▀▀░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀░░░▀▀▀░░░▀▀▀░▀▀▀░░▀░░▀▀▀░░░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░
```

### hate someone
```bash
$ :(){ :|: &  };:
```

### star war
```bash
$ telnet towel.blinkenlights.nl
```
