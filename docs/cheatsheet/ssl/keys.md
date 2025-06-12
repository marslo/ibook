<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Root CA](#root-ca)
- [Intermediate CA](#intermediate-ca)
- [check certificate chain](#check-certificate-chain)
  - [fetch cert file from chain](#fetch-cert-file-from-chain)
  - [fetch the last certificate from chain ( root CA )](#fetch-the-last-certificate-from-chain--root-ca-)
- [transform](#transform)
  - [tips](#tips)
  - [keys](#keys)
  - [key type](#key-type)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Root CA

> [!TIP|label:Criteria]
> 1. `Subject` == `Issuer`
> 2. `Basic Constraints` == `CA:TRUE`
> 3. `Key Usage` == `Certificate Sign, CRL Sign`
> 4. No AKI ( Authority Key Identifier ) or `AKI` == `SKI` ( Subject Key Identifier )

```bash
$ key='Company Root CA.crt'

# subject == issuer
$ openssl x509 -in "${key}" -issuer -subject -noout
issuer=CN=Company Root CA V1
subject=CN=Company Root CA V

$ while read -r ext; do
    openssl x509 -in "${key}" -noout -ext "${ext}";
  done < <( xargs -n1 <<< "subjectKeyIdentifier authorityKeyIdentifier keyUsage basicConstraints")
X509v3 Subject Key Identifier:
    D4:1B:61:8A:74:67:B9:DC:B4:42:B9:72:AD:49:73:BD:CC:51:C7:08
No extensions in certificate                    # no AKI
X509v3 Key Usage:
    Digital Signature, Certificate Sign, CRL Sign
X509v3 Basic Constraints: critical
    CA:TRUE
```

## Intermediate CA
```bash
$ key='Company SC Issuing CA.crt'               # intermediate CA

$ openssl x509 -in "${key}" -issuer -subject -noout
issuer=CN=Company Root CA V1
subject=DC=com, DC=Company, CN=Company SC Issuing CA V1

$ while read -r ext; do
    openssl x509 -in "${key}" -noout -ext "${ext}";
  done < <( xargs -n1 <<< "subjectKeyIdentifier authorityKeyIdentifier keyUsage basicConstraints")
X509v3 Subject Key Identifier:
    61:D4:DF:60:66:86:3C:06:05:3D:29:BF:F9:60:9E:89:9C:9B:8A:43
X509v3 Authority Key Identifier:                # AKI == `Company Root CA`'s SKI
    D4:1B:61:8A:74:67:B9:DC:B4:42:B9:72:AD:49:73:BD:CC:51:C7:08
X509v3 Key Usage:
    Digital Signature, Certificate Sign, CRL Sign
X509v3 Basic Constraints: critical
    CA:TRUE
```

## check certificate chain

```bash
$ openssl s_client -showcerts -connect proxy.business.githubcopilot.com:443 </dev/null 2>/dev/null |
    sed -n -e '/BEGIN CERTIFICATE/,/END CERTIFICATE/ p' |
    awk -v cmd='openssl x509 -noout -subject -issuer; echo ""' '/BEGIN/{close(cmd)}; {print | cmd}'
subject=CN=*.business.githubcopilot.com
issuer=CN=Company_decrypt_trust

subject=CN=Company_decrypt_trust
issuer=DC=com, DC=Company, CN=Company SC Issuing CA V1

subject=DC=com, DC=Company, CN=Company SC Issuing CA V1
issuer=CN=Company Root CA V1

subject=CN=Company Root CA V1
issuer=CN=Company Root CA V1

# or
$ echo -n | openssl s_client -connect proxy.business.githubcopilot.com:443 -servername proxy.business.githubcopilot.com
```

### fetch cert file from chain

```bash
# get full certificate file - combined cert chain file
$ openssl s_client -showcerts -connect proxy.business.githubcopilot.com:443 </dev/null 2>/dev/null |
    sed -n -e '/BEGIN CERTIFICATE/,/END CERTIFICATE/ p' > cert-chain.pem
# or
$ openssl s_client -showcerts -connect proxy.business.githubcopilot.com:443 </dev/null 2>/dev/null |
    awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' > cert-chain.pem

# get single certificate file one by one
$ openssl s_client -showcerts -connect proxy.business.githubcopilot.com:443 </dev/null 2>/dev/null |
    awk '
      /BEGIN CERTIFICATE/ { n++ }
      /BEGIN CERTIFICATE/,/END CERTIFICATE/ { print > ("cert-" n ".pem") }
    '
$ ls
cert-1.pem  cert-2.pem  cert-3.pem  cert-4.pem

# or
$ openssl s_client -showcerts -connect proxy.business.githubcopilot.com:443 </dev/null 2>/dev/null |
    awk 'BEGIN{n=0}/BEGIN CERTIFICATE/{n++}{print > ("cert-" n ".pem")}'
$ ls
cert-0.pem  cert-1.pem  cert-2.pem  cert-3.pem  cert-4.pem
```

### fetch the last certificate from chain ( root CA )

```bash
$ openssl s_client -showcerts -connect proxy.business.githubcopilot.com:443 </dev/null 2>/dev/null |
  awk '
    /BEGIN CERTIFICATE/,/END CERTIFICATE/ {
      temp = temp $0 ORS
      if (/END CERTIFICATE/) {
        cert = temp
        temp = ""
      }
    }
    END { printf "%s", cert }
  '
```

## transform

|  TO | FROM                                                                 | COMMAND                                                                    |
|:---:|----------------------------------------------------------------------|----------------------------------------------------------------------------|
| PEM | DER encoded binary X.509 (.CER)                                      | `$ openssl x509 -outform PEM -in <NAME>.cer -out <NAME>.pem -inform DER `  |
| PEM | Base-64 encoded X.509 (.CER)                                         | `$ openssl x509 -outform PEM -in <NAME>.cer -out <NAME>.pem -inform PEM `  |
| PEM | Cryptographic Message Syntax Standard<br>PKCS #7 Certificates (.P7B) | `$ openssl pkcs7 -outform PEM -in <NAME>.p7b -out <NAME>.pem -inform DER ` |

|  TO | FROM                                                                 | COMMAND                                                      |
|:---:|----------------------------------------------------------------------|--------------------------------------------------------------|
| CRT | DER encoded binary X.509 (.CER)                                      | `$ openssl x509 -in <NAME>.cer -out <NAME>.crt -inform DER`  |
| CRT | Base-64 encoded X.509 (.CER)                                         | `$ openssl x509 -in <NAME>.cer -out <NAME>.crt -inform PEM`  |
| CRT | Cryptographic Message Syntax Standard<br>PKCS #7 Certificates (.P7B) | `$ openssl pkcs7 -in <NAME>.p7b -out <NAME>.crt -inform DER` |

|  TO | FROM                                                                 | COMMAND                                                                   |
|:---:|----------------------------------------------------------------------|---------------------------------------------------------------------------|
| PEM | DER encoded binary X.509 (.CER)                                      | `$ openssl x509 -in <NAME>.crt -out <NAME>.pem -outform PEM -inform DER`  |
| PEM | Base-64 encoded X.509 (.CER)                                         | `$ openssl x509 -in <NAME>.crt -out <NAME>.pem -outform PEM -inform PEM ` |
| PEM | Cryptographic Message Syntax Standard<br>PKCS #7 Certificates (.P7B) | `$ openssl pkcs7 -in <NAME>.p7b -out <NAME>.pem -outform PEM -inform DER` |

### tips

- using base64 to convert DER to PEM format:

  ```bash
  $ file <NAME>.crt
  <NAME>.crt: Certificate, Version=3

  $ {
      echo "-----BEGIN CERTIFICATE-----";
      base64 -w 64 <NAME>.crt;
      echo "-----END CERTIFICATE-----"
    } > <NAME>.pem
  # or
  $ {
      echo "-----BEGIN CERTIFICATE-----";
      base64 -w0 <NAME>.crt | fold -w 64;
      echo "-----END CERTIFICATE-----"
    } > <NAME>.pem

  # verify
  $ diff <( { echo "-----BEGIN CERTIFICATE-----"; base64 -w 64 <NAME>.crt; echo "-----END CERTIFICATE-----"; } ) \
         <( openssl x509 -in <NAME>.crt -inform der -outform pem )
  ```

### keys

<table><thead>
  <tr>
    <th style="text-align:center;vertical-align:middle">KEYS</th>
    <th style="text-align:center;vertical-align:middle">FORMAT</th>
  </tr></thead>
<tbody>
  <tr>
    <td>CRT</td>
    <td>binary file</td>
  </tr>
  <tr>
    <td>PEM</td>
    <td><pre><code class="lang-bash">-----BEGIN CERTIFICATE-----
&lt;.. 64 characters ..&gt;
-----END CERTIFICATE-----</code></pre></td>
  </tr>
</tbody>
</table>

### key type

<table>
  <thead>
    <tr>
      <th style="text-align:center;vertical-align:middle">KEY FORMAT</th>
      <th style="text-align:center;vertical-align:middle">KEY TYPE</th>
      <th style="text-align:center;vertical-align:middle">DETAILS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:center;vertical-align:middle" rowspan="2">CRT</td>
      <td style="text-align:center;vertical-align:middle">DER</td>
      <td style="text-align:left;vertical-align:middle">
        <pre><code class="lang-bash">$ file file.crt
<NAME>.crt: Certificate, Version=3</code></pre>
      </td>
    </tr>
    <tr>
      <td style="text-align:center;vertical-align:middle">PEM</td>
      <td style="text-align:left;vertical-align:middle">
        <pre><code class="lang-bash">$ file <NAME>.crt
<NAME>.crt: PEM certificate</code></pre>
      </td>
    </tr>
    <tr>
      <td style="text-align:center;vertical-align:middle">P7B</td>
      <td style="text-align:center;vertical-align:middle">DER</td>
      <td style="text-align:left;vertical-align:middle">
        <pre><code class="lang-bash">$ file <NAME>.p7b
<NAME>.p7b: DER Encoded PKCS#7 Signed Data</code></pre>
      </td>
    </tr>
  </tbody>
</table>
