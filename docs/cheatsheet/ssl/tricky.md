<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [new key](#new-key)
- [web certs](#web-certs)
- [convert](#convert)
- [signing](#signing)
- [diff](#diff)
- [encrypted archive](#encrypted-archive)
- [encrypt data over net](#encrypt-data-over-net)
- [decrypt](#decrypt)
- [random string](#random-string)
- [measure cpu performance](#measure-cpu-performance)
- [s_client](#s_client)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### new key

- [new ssl key and csr based on a previous ssl certificate](https://www.commandlinefu.com/commands/view/10256/new-ssl-key-and-csr-based-on-a-previous-ssl-certificate)
  ```bash
  $ regenerateCSR() { openssl genrsa -out $2 2048; openssl x509 -x509toreq -in $1 -out $3 -signkey $2; }

  # usage
  $ regenerateCSR original.crt new.key new.csr
  ```

### web certs
- outform perm
  ```bash
  $ openssl s_client -showcerts -connect google.com:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > /tmp/google.com.cer

  # or : https://www.commandlinefu.com/commands/view/25512/generate-pem-cert-from-host-with-ssl-port
  $ openssl s_client -connect HOSTNAME.at:443 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM > meinzertifikat.pem
  ```

- check ssl expiry
  ```bash
  $ echo | openssl s_client -showcerts -servername google.com -connect gnupg.org:443 2>/dev/null | openssl x509 -inform pem -noout -text
  ```

- [download from FTP](https://www.commandlinefu.com/commands/view/24623/download-certificate-from-ftp)
  ```bash
  $ echo | openssl s_client -servername ftp.domain.com -connect ftp.domain.com:21 -starttls ftp 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
  ```

### convert
- [convert PEM to PKCS#12](https://www.commandlinefu.com/commands/view/23433/convert-a-pem-certificate-file-and-a-private-key-to-pkcs12-.pfx-.p12)
  ```bash
  $ openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt
  ```

- [pkcs8 to PERM](https://www.commandlinefu.com/commands/view/135/convert-a-pkcs8-private-key-to-pem-format)
  ```bash

  $ openssl pkcs8 -inform DER -nocrypt -in [priv key] -out [pem priv key]
  ```

### signing

- [generate a certificate signing request based on an existing certificate.](https://www.commandlinefu.com/commands/view/24376/generate-a-certificate-signing-request-based-on-an-existing-certificate.-certificate.crt-must-be-exists-before-)
  ```bash
  $ openssl x509 -x509toreq -in certificate.crt -out CSR.csr -signkey privateKey.key
  ```

- [sha256 signature sum check of file](https://www.commandlinefu.com/commands/view/25095/sha256-signature-sum-check-of-file)
  ```bash
  $ openssl dgst -sha256 <FILENAME>
  ```

### diff
- [diff x509 and rsa private key](https://www.commandlinefu.com/commands/view/3389/check-if-x509-certificate-file-and-rsa-private-key-match)
  ```bash
  $ diff <(openssl x509 -noout -modulus -in server.crt ) <( openssl rsa -noout -modulus -in server.key )
  ```

### encrypted archive

> [!NOTE|label:references:]
> - [Geek to Live: Encrypt your data](https://lifehacker.com/geek-to-live-encrypt-your-data-178005)
> - [Geek to Live: Encrypt your web browsing session (with an SSH SOCKS proxy)](https://lifehacker.com/geek-to-live-encrypt-your-web-browsing-session-with-a-237227)

```bash
# encrypt
$ tar czf - /path/to/repos_folder | openssl enc -aes-256-cbc -pbkdf2 -salt -pass pass:<PASSWORD> -out <name>.tar.gz.enc

# decrypt
$ openssl enc -aes-256-cbc -pbkdf2 -d -pass pass:<PASSWORD> -in <name>.tar.gz.enc | tar xzf -
```

- [encrypted archive with openssl and tar](https://www.commandlinefu.com/commands/view/11584/encrypted-archive-with-openssl-and-tar)
  ```bash
  # encrypt
  $ tar --create --file - --posix --gzip -- <dir> | openssl enc -e -aes256 -out <file>
  # decrypt
  $ openssl enc -d -aes256 -in <file> | tar --extract --file - --gzip
  ```

- [encrypted archive with openssl and tar](https://www.commandlinefu.com/commands/view/2730/encrypted-archive-with-openssl-and-tar)
  ```bash
  # encrypt
  $ tar c folder_to_encrypt | openssl enc -aes-256-cbc -e > secret.tar.enc

  # decrypt
  $ openssl enc -aes-256-cbc -d < secret.tar.enc | tar x
  ```

- [encrypted archive with openssl and tar](https://www.commandlinefu.com/commands/view/3696/encrypted-archive-with-openssl-and-tar)
  ```bash
  # encrypt
  $ openssl des3 -salt -in unencrypted-data.tar -out encrypted-data.tar.des3

  # decrypt
  $ openssl des3 -d -salt -in encrypted-data.tar.des3 -out unencrypted-data.tar
  ```

- [create compressed encrypted backup](https://www.commandlinefu.com/commands/view/12997/create-compressed-encrypted-backup)
  ```bash
  $ tar --exclude-from=$excludefile -zcvp "$source" | openssl aes-128-cbc -salt -out $targetfile -k $key
  ```

- [AES file encryption with openssl](https://www.commandlinefu.com/commands/view/12174/aes-file-encryption-with-openssl)

  > [!NOTE|label:references:]
  > - [Simple File Encryption with OpenSSL](https://tombuntu.com/index.php/2007/12/12/simple-file-encryption-with-openssl/)

  ```bash
  # encrypt
  $ openssl aes-256-cbc -salt -in secrets.txt -out secrets.txt.enc

  # decrypt
  $ openssl aes-256-cbc -d -a -in secrets.txt.enc -out secrets.txt.new
  ```

- [test and send email via smtps using openssl client](https://www.commandlinefu.com/commands/view/20503/test-and-send-email-via-smtps-using-openssl-client)
  ```bash
  $ (sleep 1;echo EHLO MAIL;sleep 1;echo "MAIL FROM: <a@foo.de>";sleep 1;echo "RCPT TO: <b@bar.eu>";sleep 1;echo DATA;sleep 1;echo Subject: test;sleep 1;echo;sleep 1;echo Message;sleep 1;echo .;sleep 1;)|openssl s_client -host b.de -port 25 -starttls smtp
  ```

### encrypt data over net

- [encrypt data over net](https://www.commandlinefu.com/commands/view/3341/send-data-securly-over-the-net.)
  ```bash
  $ cat /etc/passwd | openssl aes-256-cbc -a -e -pass pass:<PASSWORD> | netcat -l -p 8080
  ```

- [Encrypted chat with netcat and openssl (one-liner)](https://www.commandlinefu.com/commands/view/13058/encrypted-chat-with-netcat-and-openssl-one-liner)
  ```bash
  server $ while true; do read -n30 ui; echo $ui | openssl enc -aes-256-ctr -a -k PaSSw; done | nc -l -p 8877 | while read so; do decoded_so=`echo "$so" | openssl enc -d -a -aes-256-ctr -k PaSSw`; echo -e "Incoming: $decoded_so"; done
  client $ while true; do read -n30 ui; echo $ui | openssl enc -aes-256-ctr -a -k PaSSw; done | nc localhost 8877 | while read so; do decoded_so=`echo "$so" | openssl enc -d -a -aes-256-ctr -k PaSSw`; echo -e "Incoming: $decoded_so"; done
  ```

### decrypt

- [decrypt ssl](https://www.commandlinefu.com/commands/view/12474/decrypt-ssl)
  ```bash
  $ openssl pkcs8 -in /etc/pki/tls/web.key -out /root/wc.key -nocrypt && tshark -o "ssl.desegment_ssl_records:TRUE" -o "ssl.desegment_ssl_application_data:TRUE" -o "ssl.keys_list:,443,http,/root/wc.key" -o "ssl.debug_file:rsa.log" -R "(tcp.port eq 443)"
  ```

- [encode/decode text to/from base64](https://www.commandlinefu.com/commands/view/6323/encodedecode-text-tofrom-base64-on-a-mac-wout-mac-ports)
  ```bash
  $ openssl base64 -in base64.decoded.txt -out base64.encoded.txt
  ```

### random string

> [!NOTE|label:references:]
> - [* more: random string](../text-processing/text-processing.md#random-string)
> - [random mac aaddress](https://www.commandlinefu.com/commands/view/6619/generate-a-random-mac-address)
> - [random unsigned integer](https://www.commandlinefu.com/commands/view/6988/random-unsigned-integer)


> [!TIP]
> - using: `openssl rand ...`

```bash
$ openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'
b7:85:cc:3e:bc:fa
# or FreeBSD
$ openssl rand 6 | xxd -p | sed 's/\(..\)/\1:/g; s/:$//'
```

```bash
$ echo $(openssl rand 4 | od -DAn)
```

### measure cpu performance
```bash
# Apple M3 Pro
Doing md5 ops for 3s on 16 size blocks: 21908506 md5 ops in 3.00s
Doing md5 ops for 3s on 64 size blocks: 14429622 md5 ops in 2.99s
Doing md5 ops for 3s on 256 size blocks: 6895910 md5 ops in 3.00s
Doing md5 ops for 3s on 1024 size blocks: 2230130 md5 ops in 3.00s
Doing md5 ops for 3s on 8192 size blocks: 303611 md5 ops in 2.99s
Doing md5 ops for 3s on 16384 size blocks: 152573 md5 ops in 2.99s
version: 3.4.0
built on: Tue Oct 22 12:26:59 2024 UTC
options: bn(64,64)
compiler: clang -fPIC -arch arm64 -O3 -Wall -DL_ENDIAN -DOPENSSL_PIC -D_REENTRANT -DOPENSSL_BUILDING_OPENSSL -DNDEBUG
CPUINFO: OPENSSL_armcap=0x987d
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
md5             116845.37k   308861.47k   588450.99k   761217.71k   831833.21k   836038.81k

# Intel Core (Haswell, no TSX) @ 32x 2.993GHz
$ openssl speed md5
Doing md5 for 3s on 16 size blocks: 14046172 md5's in 2.95s
Doing md5 for 3s on 64 size blocks: 10034271 md5's in 3.00s
Doing md5 for 3s on 256 size blocks: 5269249 md5's in 3.00s
Doing md5 for 3s on 1024 size blocks: 1799150 md5's in 3.00s
Doing md5 for 3s on 8192 size blocks: 257400 md5's in 3.00s
Doing md5 for 3s on 16384 size blocks: 129976 md5's in 3.00s
version: 3.0.2
built on: Tue Aug 20 17:27:32 2024 UTC
options: bn(64,64)
compiler: gcc -fPIC -pthread -m64 -Wa,--noexecstack -Wall -Wa,--noexecstack -g -O2 -ffile-prefix-map=/build/openssl-aGUoHt/openssl-3.0.2=. -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fstack-protector-strong -Wformat -Werror=format-security -DOPENSSL_TLS_SECURITY_LEVEL=2 -DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_BUILDING_OPENSSL -DNDEBUG -Wdate-time -D_FORTIFY_SOURCE=2
CPUINFO: OPENSSL_ia32cap=0xfffa3203478bffff:0x7a9
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
md5              76182.63k   214064.45k   449642.58k   614109.87k   702873.60k   709842.26k
```

### s_client
- [connect to smtp server using starttls](https://www.commandlinefu.com/commands/view/3093/connect-to-smtp-server-using-starttls)
  ```bash
  $ openssl s_client -starttls smtp -crlf -connect 127.0.0.1:25
  ```

- [test for weak ssl ciphers](https://www.commandlinefu.com/commands/view/178/test-for-weak-ssl-ciphers)
  ```bash
  $ openssl s_client -connect [host]:[sslport] -cipher LOW
  ```

### others

- [bitcoin brainwallet checksum calculator](https://www.commandlinefu.com/commands/view/13181/bitcoin-brainwallet-checksum-calculator)
  ```bash
  $ o='openssl sha256 -binary'; p='printf';($p %b "\x80";$p %s "$1" | $o) | $o | sha256sum | cut -b1-8
  5c5bbb26

  $ o='openssl sha256 -binary'; p='printf';($p %b "\x80";$p %s "$1" | $o) | $o | sha256sum
  5c5bbb2619af1260281fa23f412a06087ea391fb10e98e1a00885dd13fa98027  -
  ```

- [c_rehash replacement](https://www.commandlinefu.com/commands/view/2532/c_rehash-replacement)
  ```bash
  $ for file in *.pem; do ln -s $file `openssl x509 -hash -noout -in $file`.0; done
  ```

- [embed referred images in HTML files](https://www.commandlinefu.com/commands/view/5565/embed-referred-images-in-html-files)
  ```bash
  $ grep -ioE "(url\(|src=)['\"]?[^)'\"]*" a.html |
         grep -ioE "[^\"'(]*.(jpg|png|gif)" |
         while read l ; do sed -i "s>$l>data:image/${l/[^.]*./};base64,`openssl enc -base64 -in $l | tr -d '\n'`>" a.html; done;
  ```

- [securely destroy data on given device hugely faster than /dev/urandom](https://www.commandlinefu.com/commands/view/13440/securely-destroy-data-on-given-device-hugely-faster-than-devurandom)
  ```bash
  $ openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt < /dev/zero > randomfile.bin
  ```

- [generate file and checksum with pseudo-random content and size in bash](https://www.commandlinefu.com/commands/view/14759/generate-file-and-checksum-with-pseudo-random-content-and-size-in-bash)

  > [!NOTE|label:references:]
  > ```bash
  > $ sudo apt install units
  > ```

  ```bash
  $ s=1G bs=16K; count=`units ${s}iB ${bs}iB -1 -t --out="%.f"`; openssl enc -aes-256-ctr -pass pass:`date +%s%N` -nosalt < /dev/zero 2>/dev/null | dd iflag=fullblock bs=$bs count=$count | tee $s | pv -s $s | md5sum | sed -e "s/-/$s/" > ${s}.md5
  ```

- [write random data to a disk, quickly](https://www.commandlinefu.com/commands/view/15296/write-random-data-to-a-disk-quickly)

  > [!NOTE|label:references:]
  > - [Fast Way to Randomize HD?](https://unix.stackexchange.com/a/172088/29178)
  > - [Parallelize openssl as input to dd](https://unix.stackexchange.com/q/253466/29178)

  ```bash
  $ openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt </dev/zero | pv --progress --eta --rate --bytes --size 8000632782848 | dd of=/dev/md0 bs=2M
  ```

- [get md5 checksum from a pipe stream](https://www.commandlinefu.com/commands/view/11763/get-md5-checksum-from-a-pipe-stream-and-do-not-alter-it)
  ```bash
  $ cat somefile | tee >(openssl md5 > sum.md5) | bzip2 > somefile.bz2
  ```

- [ibm aix: calculate the sha256 hashes of a directory without sha256sum](https://www.commandlinefu.com/commands/view/12734/ibm-aix-calculate-the-sha256-hashes-of-a-directory-without-sha256sum)
  ```bash
  $ echo '#! /usr/bin/ksh\necho `cat $1 | openssl dgst -sha256` $1' > sslsha256; chmod +x sslsha256; find directory -type f -exec ./sslsha256 \{\} \;
  ```

- [random music player](https://www.commandlinefu.com/commands/view/11757/random-music-player)
  ```bash
  $ FILE='mp3.list';
  $ LNNO=`wc -l $FILE|cut -d' ' -f 1`;
  $ LIST=( `cat $FILE` );for((;;)) do SEED=$((RANDOM % $LNNO));RNNO=$(python -c "print int('`openssl rand -rand ${LIST[$SEED]} 8 -hex 2>/dev/null`', 16) % $LNNO");mplayer ${LIST[$RNNO]};sleep 2s; done
  ```

- [remove password from openssl key file](https://www.commandlinefu.com/commands/view/11282/remove-password-from-openssl-key-file)
  ```bash
  $ openssl rsa -in /path/to/originalkeywithpass.key -out /path/to/newkeywithnopass.key
  ```

- [Create a random file of a certain, and display progress along the way](https://www.commandlinefu.com/commands/view/13670/create-a-random-file-of-a-certain-and-display-progress-along-the-way.)
  ```bash
  $ SIZE=1; dd if=/dev/zero bs=1M count=$((SIZE*1024)) | pv -pters $((SIZE*1024*1024*1024)) | openssl enc -aes-256-ctr -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" -nosalt > randomfile
  ```
