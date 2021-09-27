<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Keytool Options](#keytool-options)
- [get cert from domain](#get-cert-from-domain)
- [add crt into Java keystore](#add-crt-into-java-keystore)
  - [generate a certificate](#generate-a-certificate)
  - [create java keystore from cert file](#create-java-keystore-from-cert-file)
  - [append to existing java keystore](#append-to-existing-java-keystore)
- [import an entire keystore into another keystore](#import-an-entire-keystore-into-another-keystore)
- [export items to cert file](#export-items-to-cert-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



{% hint style='tip' %}
> references:
> - [keytool - Key and Certificate Management Tool](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/keytool.html)
> - [To Use keytool to Create a Server Certificate](https://docs.oracle.com/cd/E19798-01/821-1841/gjrgy/)
>   - [gencert](https://www.ibm.com/docs/en/sdk-java-technology/8?topic=keystore-gencert)
>   - [importcert](https://www.ibm.com/docs/en/sdk-java-technology/8?topic=keystore-importcert)
>   - [changealias](https://www.ibm.com/docs/en/sdk-java-technology/8?topic=keystore-changealias)
>   - [Examples](https://www.ibm.com/docs/en/sdk-java-technology/8?topic=keytool-examples)
> - [5 Creating, Exporting, and Importing SSL Certificates](https://docs.oracle.com/cd/E54932_01/doc.705/e54936/cssg_create_ssl_cert.htm#CSVSG178)
> - [To Generate a Certificate by Using keytool](https://docs.oracle.com/cd/E19798-01/821-1751/ghlgv/index.html)
> - [Error Importing SSL certificate : Not an X.509 Certificate](https://stackoverflow.com/a/53538542/2940319)
> - [generate key and certificate using keytool](https://stackoverflow.com/a/61674251/2940319)
> - [How to Creat JKS KeyStore file from existing private key and certificate](https://xacmlinfo.org/2014/06/13/how-to-keystore-creating-jks-file-from-existing-private-key-and-certificate/)
> - [How to Generate a Keystore and CSR Using the Keytool Command](https://dzone.com/articles/keytool-commandutility-to-generate-a-keystorecerti)
> - [The Most Common Java Keytool Keystore Commands](https://www.sslshopper.com/article-most-common-java-keytool-keystore-commands.html)
> - [Error unable to find valid certification path](https://discuss.elastic.co/t/error-unable-to-find-valid-certification-path/122304)
> - [Java Keytool - Create Keystore](https://support.globalsign.com/digital-certificates/digital-certificate-installation/java-keytool-create-keystore)

{% endhint %}

## Keytool Options

|  KEYTOOL OPTIONS  | DESCRIPTION                                                    |
|:-----------------:|----------------------------------------------------------------|
|     `-delete`     | Deletes an entry from the Keystore                             |
|   `-exportcert`   | Exports a certificate from a Keystore                          |
|   `-genkeypair`   | Generates a key pair                                           |
|    `-genseckey`   | Generates a secret key pair                                    |
|     `-gencert`    | Generates a certificate from a certificate request             |
|   `-importcert`   | Import a certificate or a certificate chain to keystore        |
|   `-importpass`   | Imports a password                                             |
| `-importkeystore` | Imports one or all entries from another keystore to a keystore |
|    `-keypasswd`   | Changes the key password of an entry in keystore               |
|      `-list`      | Lists entries in a keystore                                    |
|    `-printcert`   | Prints the content of a certificate                            |
|  `-printcertreq`  | Prints the content of a certificate request                    |
|    `-printcrl`    | Prints the content of a CRL file                               |
|   `-storepasswd`  | Changes the store password of a keystore                       |


## get cert from domain
```bash
$ keytool -printcert \
          -rfc \
          -sslserver google.com:443 > google.com.new.crt
```

- check crt file
  ```bash
  $ openssl x509 \
            -in google.com.new.crt \
            -noout \
            -text |
            grep "Not "
              Not Before: Aug 30 01:36:08 2021 GMT
              Not After : Nov 22 01:36:07 2021 GMT
  ```
  or
  ```bash
  $ keytool -printcert \
            -v \
            -file google.com.new.crt |
            head
  Certificate[1]:
  Owner: CN=*.google.com
  Issuer: CN=GTS CA 1C3, O=Google Trust Services LLC, C=US
  Serial number: 1a46a5eeaea1c2610a00000000fcefe4
  Valid from: Sun Aug 29 18:36:08 PDT 2021 until: Sun Nov 21 17:36:07 PST 2021
  Certificate fingerprints:
     MD5:  58:83:A1:72:6A:FC:96:FD:18:BF:93:57:AD:64:BE:55
     SHA1: 5D:F7:6F:AC:E9:D8:13:9F:68:E3:32:9C:42:CD:11:44:67:0A:E7:E6
     SHA256: 03:FF:12:79:0E:57:B2:90:65:37:F2:5D:EA:62:A5:36:62:C6:1E:C0:2E:58:12:10:33:66:2D:49:2B:0C:3B:D5
  Signature algorithm name: SHA256withRSA
  ```

## add crt into Java keystore
### generate a certificate
```bash
$ keytool -genkey \
          -alias google.com \
          -keyalg RSA \
          -keystore keystore.jks \
          -keysize 2048
```

### create java keystore from cert file
```bash
$ keytool -importcert \
          -alias google.com \
          -keystore google.com.jks \
          -storepass changeit \
          -file google.com.new.crt

Trust this certificate? [no]:  yes
Certificate was added to keystore
```

{% hint style='tip' %}
using `-noprompt -trustcacerts` will skip manual input `yes` for `Trust this certificate`
{% endhint %}


- verify
  ```bash
  $ keytool -list \
            [-v] \
            -keystore google.com.jks \
            -storepass changeit
  Keystore type: jks
  Keystore provider: SUN

  Your keystore contains 1 entry

  google.com, Sep 27, 2021, trustedCertEntry,
  Certificate fingerprint (SHA1): 5D:F7:6F:AC:E9:D8:13:9F:68:E3:32:9C:42:CD:11:44:67:0A:E7:E6
  ```

### append to existing java keystore
```bash
$ keytool -import \
          -noprompt \
          -trustcacerts \
          -alias google.com \
          -keystore google.com.new.jks \
          -file google.com.new.crt
```

## import an entire keystore into another keystore
```bash
$ keytool -importkeystore
          -srckeystore key.jks -destkeystore NONE
          -srcstoretype JKS -deststoretype PKCS11
          -srcstorepass <source keystore password> -deststorepass <destination keystore password>
```

- import only single alias from keystore to another keystore
  ```bash
  $ keytool -importkeystore
            -srckeystore key.jks -destkeystore NONE
            -srcstoretype JKS -deststoretype PKCS11
            -srcstorepass <source keystore password> -deststorepass <destination keystore password>
            -srcalias myprivatekey -destalias myoldprivatekey
            -srckeypass <source entry password> -destkeypass <destination entry password>
            -noprompt
  ```

## export items to cert file
{% hint style='tip' %}
> history:
> This command was named `-export` in previous releases.
>
> This old name is still supported in this release and will be supported in future releases, but for clarify the new name, `-exportcert`, is preferred going forward.
{% endhint %}

```bash
$ keytool -export \
          -keystore google.com.jks \
          -alias google.com \
          -file google.com.crt
```
