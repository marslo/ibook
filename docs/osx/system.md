<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [system tools](#system-tools)
  - [`hostinfo`](#hostinfo)
  - [get human-readable vm_stat](#get-human-readable-vm_stat)
  - [show system info](#show-system-info)
  - [show memory](#show-memory)
  - [show Mach virtual memory statistics](#show-mach-virtual-memory-statistics)
  - [check process without interactive mode](#check-process-without-interactive-mode)
- [show system](#show-system)
  - [Serial Number](#serial-number)
  - [hardware](#hardware)
  - [memory](#memory)
  - [swap usage](#swap-usage)
  - [show kernel version](#show-kernel-version)
- [flushed](#flushed)
  - [disk cache](#disk-cache)
- [clean OSX native dot file](#clean-osx-native-dot-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## system tools
### `hostinfo`
```bash
$ hostinfo
Mach kernel version:
   Darwin Kernel Version 19.6.0: Mon Aug 31 22:12:52 PDT 2020; root:xnu-6153.141.2~1/RELEASE_X86_64
Kernel configured for up to 12 processors.
6 processors are physically available.
12 processors are logically available.
Processor type: x86_64h (Intel x86-64h Haswell)
Processors active: 0 1 2 3 4 5 6 7 8 9 10 11
Primary memory available: 16.00 gigabytes
Default processor set: 463 tasks, 2557 threads, 12 processors
Load average: 2.72, Mach factor: 9.26
```

### [get human-readable vm_stat](https://apple.stackexchange.com/a/216657/254265)
```bash
$ paste <(vm_stat | awk 'NR>1' | grep -o ".*:") <(for i in $(vm_stat | awk 'NR>1' | tr -d '.' | awk '{print $NF}'); do perl -e "print $i/1024" | awk '{printf "%0.2f", $0}'; echo; done) | column -s: -t
Pages free                      328.70
Pages active                    910.00
Pages inactive                  973.38
Pages speculative               39.51
Pages throttled                 0.00
Pages wired down                852.52
Pages purgeable                 389.65
"Translation faults"            174323.38
Pages copy-on-write             7828.62
Pages zero filled               127404.04
Pages reactivated               3420.56
Pages purged                    6392.20
File-backed pages               656.69
Anonymous pages                 1266.20
Pages stored in compressor      2536.76
Pages occupied by compressor    991.23
Decompressions                  1555.85
Compressions                    8494.54
Pageins                         7799.75
Pageouts                        11.98
Swapins                         43.15
Swapouts                        48.46
```

### show system info
```bash
$ glances
```

### show memory
```bash
$ top -o MEM
```

#### iStat
```bash
 $ istats
--- CPU Stats ---
CPU temp:               53.19°C     ▁▂▃▅▆▇

--- Fan Stats ---
Total fans in system:   2
Fan 0 speed:            2157 RPM    ▁▂▃▅▆▇
Fan 1 speed:            1995 RPM    ▁▂▃▅▆▇

--- Battery Stats ---
Battery health:         unknown
Cycle count:            34          ▁▂▃▅▆▇  3.4%
Max cycles:             1000
Current charge:         6093 mAh    ▁▂▃▅▆▇  100%
Maximum charge:         6237 mAh    ▁▂▃▅▆▇  85.0%
Design capacity:        7336 mAh
Battery temp:           36.5°C

For more stats run `istats extra` and follow the instructions.
```

### show Mach virtual memory statistics
```bash
$ vm_stat
```

### check process without interactive mode
```bash
$ top -l 1 -n 0
```
example
```bash
$ top -l 1 -n 0
Processes: 472 total, 3 running, 469 sleeping, 2589 threads
2020/11/02 16:10:28
Load Avg: 2.67, 2.88, 3.12
CPU usage: 33.4% user, 20.46% sys, 46.49% idle
SharedLibs: 268M resident, 69M data, 44M linkedit.
MemRegions: 112888 total, 3016M resident, 90M private, 2802M shared.
PhysMem: 16G used (3742M wired), 420M unused.
VM: 3201G vsize, 1993M framework vsize, 44188(0) swapins, 49627(0) swapouts.
Networks: packets: 1575080/1561M in, 1302980/954M out.
Disks: 1368885/28G read, 648911/13G written.
```

- [or](https://apple.stackexchange.com/a/46655/254265)
  ```bash
  $ top -l 1 -s 0
  ```

## show system
### Serial Number
```bash
$ /usr/sbin/system_profiler SPHardwareDataType
Hardware:

    Hardware Overview:

      Model Name: MacBook Pro
      Model Identifier: MacBookPro15,1
      Processor Name: 6-Core Intel Core i7
      Processor Speed: 2.2 GHz
      Number of Processors: 1
      Total Number of Cores: 6
      L2 Cache (per Core): 256 KB
      L3 Cache: 9 MB
      Hyper-Threading Technology: Enabled
      Memory: 16 GB
      Boot ROM Version: 10**.***.*.*.* (iBridge: 17.**.*****.*.*,*)
      Serial Number (system): ************
      Hardware UUID: ********-****-****-****-************
      Activation Lock Status: Enabled
```

### hardware
- cpu manufacture
  ```bash
  $ sysctl -n machdep.cpu.brand_string
  Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
  ```
  or
  ```bash
  $ sysctl machdep.cpu
  machdep.cpu.max_basic: 22
  machdep.cpu.max_ext: 2147483656
  machdep.cpu.vendor: GenuineIntel
  machdep.cpu.brand_string: Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
  machdep.cpu.family: 6
  ...
  ```

### memory
```bash
$ system_profiler SPHardwareDataType | grep  "Memory:\|Cores:\|Processors:"
      Number of Processors: 1
      Total Number of Cores: 6
      Memory: 16 GB
```

- or
  ```bash
  $ sysctl hw.memsize
  hw.memsize: 17179869184

  $ sysctl hw.ncpu
  hw.ncpu: 12
  ```

#### [memory slot](https://apple.stackexchange.com/a/11591/254265)
```bash
$ system_profiler SPMemoryDataType
Memory:

    Memory Slots:

      ECC: Disabled
      Upgradeable Memory: No

        BANK 0/ChannelA-DIMM0:

          Size: 8 GB
          Type: DDR4
          Speed: 2400 MHz
          Status: OK
          Manufacturer: Micron
          Part Number: **********-*****
          Serial Number: -

        BANK 2/ChannelB-DIMM0:

          Size: 8 GB
          Type: DDR4
          Speed: 2400 MHz
          Status: OK
          Manufacturer: Micron
          Part Number: **********-*****
          Serial Number:
```

### [swap usage](https://apple.stackexchange.com/a/110459/254265)
```bash
$ sysctl vm.swapusage
vm.swapusage: total = 1024.00M  used = 34.00M  free = 990.00M  (encrypted)
```

### [show kernel version](https://apple.stackexchange.com/a/368722/254265)
```bash
$ sysctl kern.version
kern.version: Darwin Kernel Version 20.1.0: Sat Oct 31 00:07:11 PDT 2020; root:xnu-7195.50.7~2/RELEASE_X86_64

$ sysctl kern.ostype
kern.ostype: Darwin

$ sysctl kern.osrelease
kern.osrelease: 20.1.0

$ sysctl kern.osrevision
kern.osrevision: 199506
```
- or
  ```bash
  $ uname -a
  Darwin iMarslo 20.1.0 Darwin Kernel Version 20.1.0: Sat Oct 31 00:07:11 PDT 2020; root:xnu-7195.50.7~2/RELEASE_X86_64 x86_64 i386 MacBookPro15,1 Darwin
  ```

## flushed
### disk cache
```bash
$ sudo purge
```

## clean OSX native dot file
```bash
$ dot_clean -mvp <path>
```
- i.e.:
  ```bash
  $ sudo dot_clean -mvp /
  ```

OR
```bash
$ find $HOME -name '.DS_Store' -type f -delete
```

## launchctl
### create new plist
```bash
cat > ~/Library/LaunchAgents/i.marslo.updatedb.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>i.marslo.updatedb</string>
  <key>ProgramArguments</key>
  <array>
    <string>sudo</string>
    <string>/usr/local/bin/gupdatedb</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardErrorPath</key>
  <string>/Users/marslo/.marslo/log/i.marslo.updatedb.log</string>
  <key>StandardOutPath</key>
  <string>/Users/marslo/.marslo/log/i.marslo.updatedb.error.log</string>
  <key>StartInterval</key>
  <integer>300</integer>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
EOF
```
- check
  ```bash
  $ plutil ~/Library/LaunchAgents/i.marslo.updatedb.plist
  /Users/marslo/Library/LaunchAgents/i.marslo.updatedb.plist: OK
  ```
- enable
  ```bash
  $ launchctl load ~/Library/LaunchAgents/i.marslo.updatedb.plist
  $ launchctl list | grep updatedb
  - 1 i.marslo.updatedb
  ```
- disable
  ```bash
  $ launchctl remove i.marslo.updatedb
  ```
