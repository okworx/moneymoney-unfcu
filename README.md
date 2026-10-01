# moneymoney-unfcu

[MoneyMoney](https://moneymoney-app.com) extension for [UNFCU](https://www.unfcu.org/).
Fetches balances, transactions and statements (PDF).

Not a signed extension; requires a MoneyMoney beta with unsigned extensions enabled.

## Installation

Copy `unfcu.lua` to the Extensions folder, where you installed MoneyMoney

## Changes in 0.2

- Login via UNFCU's new sign-in (auth.unfcu.org), including verification code (2FA)
- Banking API moved to digitalsso.unfcu.org
- First refresh of an account loads the full transaction history
- Account type read from the core banking record; loan accounts supported
- Transactions show the merchant as name and the booking type as purpose
