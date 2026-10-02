# moneymoney-unfcu

Fetches balances, transactions and statements (PDF) from [UNFCU](https://www.unfcu.org/) for [MoneyMoney](https://moneymoney-app.com).

## Extension Setup

You can get a signed version of this extension from

* the `dist` directory in this repository

Once downloaded, move `unfcu.lua` to your MoneyMoney Extensions folder.

The unsigned source is in `src`; it only runs in MoneyMoney beta versions with unsigned extensions enabled.

## Account Setup

### UNFCU

1. Make sure you can log in to UNFCU Digital Banking at https://www.unfcu.org
2. Make sure you can receive UNFCU verification codes (2FA)

### MoneyMoney

1. Choose "Account" → "Add Account…"
2. Select "Others" → "UNFCU"
3. Enter your UNFCU username and password
4. Enter the verification code when MoneyMoney asks for it

## Changes in 0.2

- Login via UNFCU's new sign-in (auth.unfcu.org), including verification code (2FA)
- Banking API moved to digitalsso.unfcu.org
- First refresh of an account loads the full transaction history
- Account type read from the core banking record; loan accounts supported
- Transactions show the merchant as name and the booking type as purpose
