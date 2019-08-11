# SecretKeeper

This is a WIP repo, a side project.
The aim of the repo is -
  * To provide a cloud based solution for safely storing keys, credentials, passwords of the users without worrying
  security.
  * All the data will be encrypted, and can only be decrypted using a key, (the key will be of two parts, one part
  will be your master password, the other part will be stored at our side). To get your credentials you will need 
  both of them.

## How will you register/login for the application?
  * Just register with your email and password, in return we will give you a key (time based key) to be fed into your
  time based authenticators (e.g. google auth) that will generate 2FA codes. How to add it is shown below. Enter the
  key returned in the register response to `Your Key` field, and then choose `Time Based`. Your 2FA is setup.
  

  ![alt text](https://img.gadgethacks.com/img/29/74/63651269383273/0/binance-101-enable-google-authenticator-for-withdrawals.w1456.jpg)
  
  * During login, apart from email and password, send the 2FA code from your google auth application. You will recieve
  the auth tokens.

## How are we storing your totp_key and passwords?
  * Passwords are hashed in our DB.
  * totp_keys are encrypted in our DB.
  * totp_keys are encrypted using your password, so we can't decrypt it as we don't have your passwords. (We have
  the hashed values only)
