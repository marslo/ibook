<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [verify local cert](#verify-local-cert)
  - [`s_client`](#s_client)
    - [with cert debug](#with-cert-debug)
  - [curl](#curl)
  - [openssl](#openssl)
    - [get crt information](#get-crt-information)
    - [get csr information](#get-csr-information)
  - [java ssl](#java-ssl)
    - [InstallCert.java](#installcertjava)
- [verify remote cert](#verify-remote-cert)
  - [openssl & s_client](#openssl--s_client)
  - [curl](#curl-1)
  - [keytool](#keytool)
  - [nmap](#nmap)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> check in [kubernetes certifactes as well](../../virtualization/kubernetes/certificates.html)

{% endhint %}

# verify local cert
## `s_client`
```bash
$ openssl s_client -state -msg -connect my.server.com:443
```

### with cert debug
```bash
$ openssl s_client -state \
                   -debug \
                   -connect my.server.com:443 \
                   -cert my.server.com-server.crt \
                   -key my.server.com-server.key \
```

## curl
```bash
$ curl -vvv \
       [--cacert server.crt \]
       https://my.server.com:443/artifactory
```
- or
  ```bash
  $ curl -vvv \
         -i \
         -L \
         [--cacert server.crt \] \
         https://my.server.com:443/artifactory
  ```

## openssl
### get crt information
- ca.crt
  ```bash
  $ openssl verify ca.crt
  ```
  - or
    ```bash
    $ openssl x509 -noout -text -in ca.crt
    ```

- server.crt
  ```bash
  $ openssl x509 -inform PEM \
                 -in server.crt \
                 -text \
                 -out certdata
  ```

### get csr information
```bash
$ openssl req -noout -text -in server.csr
```

## java ssl
{% hint style='tip' %}
to add cert into Java for Java services (i.e.: Jenkins)
> reference:
> - [4ndrej/SSLPoke.java](https://gist.github.com/4ndrej/4547029)
> - [bric3/SSLPoke.java](https://gist.github.com/bric3/4ac8d5184fdc80c869c70444e591d3de)
> - [klasen/sslpoke](https://github.com/klasen/sslpoke)
> - [Test of java SSL / keystore / cert setup](https://confluence.atlassian.com/download/attachments/117455/SSLPoke.java)
>
{% endhint %}

- `SSLPoke.java`
  ```java
  // SSLPoke.java
  import javax.net.ssl.SSLParameters;
  import javax.net.ssl.SSLSocket;
  import javax.net.ssl.SSLSocketFactory;
  import java.io.*;

  /** Establish a SSL connection to a host and port, writes a byte and
   * prints the response. See
   * http://confluence.atlassian.com/display/JIRA/Connecting+to+SSL+services
   */
  public class SSLPoke {
    public static void main(String[] args) {
      if (args.length != 2) {
        System.out.println("Usage: "+SSLPoke.class.getName()+" <host> <port>");
        System.exit(1);
      }
      try {
        SSLSocketFactory sslsocketfactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
        SSLSocket sslsocket = (SSLSocket) sslsocketfactory.createSocket(args[0], Integer.parseInt(args[1]));

        SSLParameters sslparams = new SSLParameters();
        sslparams.setEndpointIdentificationAlgorithm("HTTPS");
        sslsocket.setSSLParameters(sslparams);

        InputStream in = sslsocket.getInputStream();
        OutputStream out = sslsocket.getOutputStream();

        // Write a test byte to get a reaction :)
        out.write(1);

        while (in.available() > 0) {
          System.out.print(in.read());
        }
        System.out.println("Successfully connected");

      } catch (Exception exception) {
          exception.printStackTrace();
          System.exit(1);
      }
    }
  }
```

- extract cert from server:
  ```bash
  $ openssl s_client -connect server:443
  ```
- negative test cert/keytool:
  ```bash
  $ java SSLPoke server 443
  ```
  - you should get something like
    ```bash
    javax.net.ssl.SSLHandshakeException: sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
    ```
- import cert into default keytool:
  ```bash
  $ keytool -import -alias alias.server.com -keystore $JAVA_HOME/jre/lib/security/cacerts
  ```
- positive test cert / keytool:
  ```bash
  java SSLPoke server 443

  // you should get this:
  // Successfully connected
  ```

- import certificate into your local TrustStore

  > `-Djavax.net.ssl.trustStore` will override the default truststore (cacerts). copy the default one and then add cert and set it via `-Djavax.net.ssl.trustStore` so default CA won't be lost.

  ```bash
  $ keytool -import -trustcacerts -storepass changeit -file "./class 1 root ca.cer" -alias C1_ROOT_CA -keystore ./LocalTrustStore

  # use it in JAVA:
  $ java -Djavax.net.ssl.trustStore=./LocalTrustStore -jar SSLPoke.jar $HOST $PORT
  ```


### [InstallCert.java](https://github.com/escline/InstallCert)
> reference:
> - [unable to find valid certification path to requested target](https://blogs.oracle.com/gc/unable-to-find-valid-certification-path-to-requested-target)

compile first
```bash
$ javac InstallCert.java
```
- Access server, and retrieve certificate (accept default certificate 1)
  ```bash
  $ java InstallCert [host]:[port]
  ```
- Extract certificate from created jssecacerts keystore
  ```bash
  $ keytool -exportcert -alias [host]-1 -keystore jssecacerts -storepass changeit -file [host].cer
  ```
- Import certificate into system keystore
  ```bash
  $ keytool -importcert -alias [host] -keystore [path to system keystore] -storepass changeit -file [host].cer
  ```

# verify remote cert
{% hint style="tip" %}
reference:
- [Checking A Remote Certificate Chain With OpenSSL](https://langui.sh/2009/03/14/checking-a-remote-certificate-chain-with-openssl/)
- [How to extract SSL data from any website](https://securitytrails.com/blog/extract-ssl-data)
{% endhint %}

## openssl & s_client
```bash
$ openssl s_client -showcerts -connect www.domain.com:443
```
or

```bash
$ echo | openssl s_client -showcerts \
                          -servername www.domain.com \
                          -connect www.domain.com:443 2>/dev/null \
                          | openssl x509 -inform pem -noout -text
```

- or
  ```bash
  $ openssl s_client -showcerts -starttls imap -connect www.domain.com:443
  CONNECTED(00000005)
  ```

- or using local client cert for debug purpose
  ```bash
  $ openssl s_client -showcerts \
                     -cert cert.cer \
                     -key cert.key \
                     -connect www.domain.com:443
  ```
- [or](https://stackoverflow.com/a/25274959/2940319)
  ```bash
   $ openssl s_client -connect www.domain.com:443 \
                      | openssl x509 -text -noout \
                      | grep -A 1 -i key
  ```

- or use specify acceptable ciphers for ssl handshake
  ```bash
  $ openssl s_client -showcerts -cipher DHE-RSA-AES256-SHA -connect www.domain.com:443
  ```

- or get `enddate` only
  ```bash
  $ echo | openssl s_client \
                   -connect www.domain.com:443 2>/dev/null \
                   | openssl x509 -noout -enddate
  notAfter=Nov 28 23:59:59 2020 GMT
  ```

## curl
```bash
$ curl -vvI https://www.domain.com
```
- print ssl only
  ```bash
  $ curl --insecure \
         -vvI https://www.domain.com 2>&1 \
         | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'
  ```

## keytool
```bash
$ keytool -printcert -sslserver www.domain.com:443
```

## nmap
```bash
$ nmap -p 443 --script ssl-cert www.domain.com [-v]
```

