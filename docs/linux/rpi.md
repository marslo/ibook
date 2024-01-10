<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Raspberry Pi](#raspberry-pi)
  - [repository](#repository)
  - [jdk](#jdk)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Raspberry Pi

> [!NOTE|label:references:]
> - [* debian/dists/bullseye](https://ftp.debian.org/debian/dists/bullseye/main/)
> - [How to install and use Java 11 and JavaFX 11 on Raspberry Pi boards with ARMv6 processor](https://webtechie.be/post/2020-08-27-azul-zulu-java-11-and-gluon-javafx-11-on-armv6-raspberry-pi/)
> - [bellsoft: Liberica JDK Download Center](https://bell-sw.com/pages/downloads/#jdk-17-lts)
> - [bellsoft: Liberica JDK 11.0.2 Install Guide](https://docs.bell-sw.com/liberica-jdk/11.0.2b7/general/install-guide/)
> - [How to Install Java on Raspberry Pi](https://phoenixnap.com/kb/install-java-raspberry-pi)
> - [raspbian.raspberrypi.org: openjdk-11](http://raspbian.raspberrypi.org/raspbian/pool/main/o/openjdk-11/)
> - [PiJava - Part 2 - Installing Java 11 on a Raspberry PI 3 Model B+](https://webtechie.be/post/2019-03-13-pijava-part-2-java-11-on-raspberry-pi-3/)
> - [How to Update Java on Raspberry Pi](https://linuxhint.com/update-java-raspberry-pi/)
> - [Upgrading your Raspberry Pi to Bullseye](https://www.sanderh.dev/upgrade-Raspberry-Pi-bullseye/)
> - [Raspbian Mirrors](https://www.raspbian.org/RaspbianMirrors)
> - [How to change the Repository Mirror on Raspbian](https://pimylifeup.com/raspbian-repository-mirror/)

## repository
- `/etc/apt/source.list`
  ```bash
  $ cat /etc/apt/sources.list
  deb http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi
  # Uncomment line below then 'apt-get update' to enable 'apt-get source'
  # deb-src http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi

  # or
  $ cat /etc/apt/sources.list
  deb http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi
  deb http://deb.debian.org/debian bullseye main contrib non-free
  deb http://security.debian.org/debian-security bullseye-security main contrib non-free
  deb http://deb.debian.org/debian bullseye-updates main contrib non-free
  ```

- `/etc/apt/sources.list.d/raspi.list`
  ```bash
  $ cat /etc/apt/sources.list.d/raspi.list
  deb http://archive.raspberrypi.org/debian/ bullseye main
  # Uncomment line below then 'apt-get update' to enable 'apt-get source'
  # deb-src http://archive.raspberrypi.org/debian/ bullseye main
  ```

## jdk

> [!NOTE|label:references:]
> - [* iMarslo: jdk/bellsoft](../tools/app/app.html#java)
> - [Liberica jdk : all versions](https://bell-sw.com/pages/downloads/)
