---
title: "Secure Messages Between Rails and NodeJS"
---

Digging around some old code I wrote I stumbled across a way to decrypt the encrypted messages created with Rails' MessageEncryptor. It can be useful to use this to securely exchange secrets between a Rails app and a AWS Lambda function where you don't trust the transport mechanism, for example a user's web browser. This can be helpful as you won't need to translate a bunch of code to JavaScript or open up either direct connections to a database or create an API endpoint for the serverless function to call.

This example will use AES-256-GCM which is fairly secure in my research, which of the few has been: [here](https://security.stackexchange.com/questions/184305/why-would-i-ever-use-aes-256-cbc-if-aes-256-gcm-is-more-secure){:target="_blank"}, [here](https://crypto.stackexchange.com/questions/2310/what-is-the-difference-between-cbc-and-gcm-mode){:target="_blank"}, and [here](https://en.wikipedia.org/wiki/Galois/Counter_Mode){:target="_blank"}. This example will create a new initialization vector (IV) for every new message (thanks Rails!) so it does cover one of the GCM weaknesses of IV reuse. However, there is a cipher flag set on both sides for you to change it as you choose.


## Setup Rails Message Encryptor
This portion you would store somewhere inside your Rails app, possibly a controller to encrypt messages for you.

**NOTE:** `ENC_PASSWORD` should be grabbed from an environment variable or config file. Never hard code your secrets.
```ruby
ENC_PASSWORD = 'k15XSjo1f6GKBfu0WbZkyC5DJgbsJyd9' #TODO: Securely access this, maybe from ENV?
#...
message_encryptor = ActiveSupport::MessageEncryptor.new(
  ENC_PASSWORD,
  { cipher: "aes-256-gcm",
    serializer: ActiveSupport::MessageEncryptor::NullSerializer
  })
```
Note the `NullSerializer` usage. Rails likes to use the `Marshal` serializer, and for this simple purpose of plaintext message exchange it's not entirely necessary. If you don't use the NullSerializer, you will be left with additional data on the output of your decrypted string later.

## Generate Encrypted Message
Generating the encrypted message is as simple as calling the `encrypt_and_sign` function off of the recently created `message_encryptor`.

**NOTE:** Unless you define a signing key when initializing the message encrytor, there is only the accuracy of the decrypted message that is checked. For brevity I did not include the signing procedure/validation into this example. You may not need authenticated signing but use this example at your own risk without it.
```ruby
message_encryptor.encrypt_and_sign("tacotime")
=> "3m0TdDwpMQY=--AZweF8B22KJ5q01K--6zD/a8c9k7ve1o2VM8+cEA=="
```

Voila! An encrypted message you can safely use to transport secrets in an untrusted means. You can optionally pass in a Base64 encoded version of your input string if you expect special / non-standard characters. It should decrypt well on the other side but Base64 has the added benefit of being fairly visually verifiable and reduces your character set when encoding and decoding.

That would look like this:

```ruby
message_encryptor.encrypt_and_sign(Base64.strict_encode64("tacotime"))
=> "JttrhFXvH1mXtnUl--Cqc2n0nyV8wAKAas--debSS7YBLfcsEB/82BUwUQ=="
```

You should be using `strict_encode64` as it won't put a newline at the end of the encoded string.

**NOTE:** If you are going to be transporting this payload via a GET/URL param, you should Base64 encode this output above as it contains non-url-safe characters, namely `=`.

## Setup NodeJS Message Decryptor
Now we're on the NodeJS side of things. Again you should be securely storing and accessing your encryption password, `enc_password` below. You'll likely stash this into it's own module and import it as needed. Again for brevity sake this is just set up as a function. This uses just the standard 'crypto' library from NodeJS.
```js
let crypto = require('crypto'),
  algorithm = 'aes-256-gcm',
  enc_password = 'wxYIj9V5jBZ9pJTEST8qjHpXRrS8sOAA'; //TODO: Securely access this, maybe from ENV?

function digest_and_decrypt(digest) {
  let [encryptedValue, iv, authTag] = digest.split('--');
  let decipher = crypto.createDecipheriv(algorithm, enc_password, Buffer.from(iv, 'base64'));
  
  decipher.setAuthTag(Buffer.from(authTag, 'base64'));
  
  let dec = decipher.update(encryptedValue, 'base64', 'utf8');
  dec += decipher.final('utf8');
  return dec;
}
```
As the payload from Rails is a concatenation of the encrypted string, initialization vector, and auth tag (which checks for the accuracy of the decrypted message) we have everything we need to decrypt the text except for the secret.

## Decrypt Encrypted Message
To decrypt the encrypted message it's as simple as calling the `digest_and_decrypt` function. This will return just the string of the decoded message if everything decrypted correctly. It will throw `Error`s should the auth_tag check fail, fails decryption, or the IV is incorrect. You should wrap this call in a `try {...} catch {...}` for proper error handling.
```js
digest_and_decrypt("qlJQV0IZ9+I=--dLV4tXRTa+ZbC59x--9rD7KYLddxQ7p/mQqY5SOQ==")
=> "tacotime"
```
If you Base64 encoded before or after you encrypted the payload in Rails, be sure to reverse that process when decrypting.

Encode after encrypting because you used it in a URL parameter? Your call should look like this:

```js
digest_and_decrypt(Buffer.from("cWxKUVYwSVo5K0k9LS1kTFY0dFhSVGErWmJDNTl4LS05ckQ3S1lMZGR4UTdwL21RcVk1U09RPT0=", 'base64').toString('utf-8'))
=> "tacotime"
```

## Summary
- Don't copy and past this and use this in production code. Please. It misses a bunch of error handling and edge cases.
- Store your secrets securely. Seriously.
- Novel solutions can minimize a ton of code for relatively simple problems.