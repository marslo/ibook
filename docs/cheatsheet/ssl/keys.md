

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
