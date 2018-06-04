---
layout: default
title: bryanculver.com SSL Public Key
permalink: /ssl/
---

Below is the SSL public key for https://bryanculver.com

```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0pGXq1qyBtyQirs3mKv9
Q+wYC8UVWSPzA36tnKVv2HP/a3U1t34U+3dP4pAIgooQZVmhMlfO4d0j1g1fNjor
BWZ+Gmfc3EcZ4Jc2olzk7UGlBe85Rm1LHxymr6zFovczTlUHpZdrrGKR1l3eXUbm
15lSsZEeL3AawJiAoZtlTE9yOQJySwLfsGEzWRtt2yxLcFCZFi+fdbIlFJE+ph/b
aBg0lWniRk+VMC7MCs+OG3vf7RiitWxBhBhvug+9pW/lBtRiJT35+s/jDM2XTNwl
CzTYmdxLjBgq39szdTFLWHvoiI8S4RoSiKE+j96diIpujCYbONlP1pohu+IzkTxn
xQIDAQAB
-----END PUBLIC KEY-----
```

Verify by running:

```
$ openssl s_client -connect bryanculver.com:443 | openssl x509 -pubkey -noout
```

_Updated 2018-06-04_
