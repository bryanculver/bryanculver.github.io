---
layout: default
title: bryanculver.com SSL Public Key
permalink: /ssl/
---

Below is the SSL public key for https://bryanculver.com

```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvMhjBJVJAIPn9NBaEapc
+0SMzw5DR41BQ0/RCrTPUWOMX//KAIAZmmswE/lQyLggN3m3uj/Op5WU9vSt5OhE
0AIGl73u5dr+o29XqsA71a4b25CpQ53FLt9lZl50DHD/UZMPHpsaIrbiVtlRSS+I
gGhMM9hff1qIPb18tzoRvMZ3Ak4UZXbGLGW3BRRhpSSCC3j3zL7ZMSNHwVFfoBGw
K5nQlNSPuRP7IDL4M3fYjKd87HVfzeNvKs9BpvA987VxtJfIalARuIoga3KqWcoO
qezAxpkcHKo/CoYymyDEgcM58DAv0kj0RE2R80Guqd9Dq0pfkpUAJYFLbjOmRk5t
gwIDAQAB
-----END PUBLIC KEY-----
```

Verify by running:

```
$ openssl s_client -connect bryanculver.com:443 | openssl x509 -pubkey -noout
```

_Updated 2017-07-24_
