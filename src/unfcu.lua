WebBanking{version     = 0.2,
            url         = "https://www.unfcu.org/",
            services    = {"UNFCU"},
            description = "Get balances, transactions and statements for UNFCU accounts"}

-- Login runs through ForgeRock (auth.unfcu.org), banking API lives on digitalsso.unfcu.org

authBaseUrl = "https://auth.unfcu.org/am/"
authQuery = "authIndexType=service&authIndexValue=AULoginWithWeb"
urlLoginPage = authBaseUrl .. "XUI/?realm=/alpha&" .. authQuery
urlAuthenticate = authBaseUrl .. "json/realms/root/realms/alpha/authenticate?" .. authQuery

apiBaseUrl = "https://digitalsso.unfcu.org/Apps/"

urlTether = apiBaseUrl .. "AppAccessPasscodeSignin/Tether"
urlAccountInfo = apiBaseUrl .. "AppCustomMainAccountList/Select"
urlTxInfo = apiBaseUrl .. "AppMainTransactionList/Select"
urlStatements = apiBaseUrl .. "AppMainDocumentList/Select"
urlDlStatement = apiBaseUrl .. "AppMainDocumentList/ViewPdf/"
urlSignout = apiBaseUrl .. "AppAccessPing/Term"

userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Safari/605.1.15"

authHeaders = {
  ["Accept"] = "application/json",
  ["accept-api-version"] = "protocol=1.0,resource=2.1",
  ["x-requested-with"] = "forgerock-sdk",
  ["Origin"] = "https://auth.unfcu.org",
  ["Referer"] = "https://auth.unfcu.org/"
}

-- banking API headers; sendRequest adds the anti-csrf-token once the API hands one out
apiHeaders = {
  ["Accept"] = "application/json, text/plain, */*",
  ["Origin"] = "https://digitalsso.unfcu.org",
  ["Referer"] = apiBaseUrl
}

accountTypes = { CK = AccountTypeGiro, SAV = AccountTypeSavings, LN = AccountTypeLoan }


function SupportsBank (protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "UNFCU"
end


function InitializeSession2 (protocol, bankCode, step, credentials, interactive)

  if step == 1 then
    MM.printStatus("setting up connection")

    connection = Connection()
    connection.useragent = userAgent

    username = credentials[1]
    password = credentials[2]
    apiHeaders["anti-csrf-token"] = nil
    accountListResult = nil
    passwordSent = false
    codeAttempts = 0

    -- load the login page once so we get the load balancer / bot protection cookies
    connection:request("GET", urlLoginPage)

    -- start the login journey, ForgeRock answers with the first set of callbacks
    authState = authenticate(nil, "Starting login")
  else
    -- user answered a challenge (OTP), put it into the pending callback
    setInput(pendingCallback, credentials[1])
    pendingCallback = nil
    codeAttempts = codeAttempts + 1
    authState = authenticate(authState, "Sending verification code")
  end

  -- walk through the journey until we're logged in or need input from the user
  local rounds = 0
  while authState and not authState.tokenId do

    rounds = rounds + 1
    if rounds > 15 then
      error("UNFCU login got stuck, see the extension log for the last callbacks")
    end

    local callback = fillCallbacks(authState)

    if authState.loginFailed then
      return LoginFailed
    end

    if callback then
      if not interactive then
        error("UNFCU asks for a verification code, please refresh manually")
      end
      pendingCallback = callback
      local challenge = authState.description or callbackPrompt(callback)
      if authState.codeRejected then
        challenge = "The code was incorrect, please try again. " .. challenge
      end
      return { title = authState.header or "UNFCU verification", challenge = challenge, label = "Code" }
    end

    authState = authenticate(authState, "Continuing login")
  end

  if not authState then
    error("UNFCU login did not return a response")
  end

  -- ForgeRock session cookie is set on .unfcu.org, Tether turns it into a banking session
  MM.printStatus("Opening banking session")
  connection:request("GET", urlTether)

  local result = sendRequest(urlAccountInfo, '{}', "Checking access")

  if not result.accessOk then
    print("access denied")
    return LoginFailed
  end

  -- ListAccounts usually runs right after login, let it reuse this answer instead of asking again
  accountListResult = result

  print("access granted")
end


function ListAccounts (knownAccounts)

  local result = accountListResult or sendRequest(urlAccountInfo, '{}', "Getting account info")
  accountListResult = nil

  local accounts = {}

  for i, acc in ipairs(result.dxAccountList or {}) do

    -- the core banking record (coreRaw) carries the real product type
    local majorType = (acc.coreRaw or ""):match("<MajorAccountTypeCode>(%w+)</MajorAccountTypeCode>")

    -- we store the internal id of each account in the subAccount property
    accounts[#accounts + 1] = {
      name = acc.niceName or acc.name,
      accountNumber = acc.number,
      subAccount = acc.id10,
      bankCode = "226078609",
      currency = "USD",
      type = accountTypes[majorType] or AccountTypeOther
    }
  end

  print(#accounts .. " accounts found")

  return accounts
end


function RefreshAccount (account, since)

  local transactions = {}
  local result
  local page = 0

  -- first refresh of an account: ignore MoneyMoney's date limit (12 months) and load the whole history.
  -- MoneyMoney itself skips transactions it already has, so later refreshes only need what's new.
  local fullImportKey = "fullHistoryLoaded_" .. account.subAccount
  if not LocalStorage[fullImportKey] then
    print("first refresh of this account, loading full history")
    since = nil
  end

  -- the API returns 50 transactions per page, newest first:
  -- keep paging until there is no next page or we are past the requested date
  repeat
    result = sendRequest(urlTxInfo, JSON():set({uxAccountId = account.subAccount, pageNumb = page}):json(),
                         "Getting transactions (page " .. (page + 1) .. ")")

    local reachedSince = false

    for i, tx in ipairs(result.uxTransactionSearchList or {}) do
      local desc = tx.dbTransactionDesc.value or ""
      local memo = tx.dbTransactionMemo.value or ""

      local transaction = {}
      -- memo holds the merchant / counterparty ("ATLASSIAN ATLASSIAN.COM CA US"),
      -- desc the kind of booking ("Point Of Sale Withdrawal")
      if memo ~= "" then
        transaction.name = memo
        transaction.purpose = desc
      else
        transaction.name = desc
      end
      transaction.amount = tx.dbTransactionAmountDisp.value
      transaction.currency = "USD"
      transaction.valueDate = convertDateToTimestamp(tx.dbTransactionDateDisp.value)
      -- pending transactions may not have a post date yet
      transaction.bookingDate = convertDateToTimestamp(tx.dbTransactionDatePost.value) or transaction.valueDate

      if tx.dbTransactionGroupName.value == "Pend" then
        transaction.booked = false
      end

      if since and transaction.bookingDate < since then
        reachedSince = true
      else
        transactions[#transactions + 1] = transaction
      end
    end

    local searchResult = result.searchResult or {}
    page = page + 1
  until reachedSince or not searchResult.hasNextPage or page >= 100

  LocalStorage[fullImportKey] = true

  print(#transactions .. " transactions found")

  -- now let's retrieve the balance
  local balance

  for i, acc in ipairs(result.dxAccountList or {}) do
    if acc.id10 == account.subAccount then
      balance = acc.balance
      break
    end
  end

  return {balance=balance, transactions=transactions}
end


function FetchStatements (accounts, knownIdentifiers)

  local statements = {}

  -- Load statements
  local result = sendRequest(urlStatements, '{"search":""}', "Fetching statements...")

  for i, doc in ipairs(result.uxDocumentList or {}) do
    local statement = {}
    statement.creationDate = convertDateToTimestamp(doc.date.value)
    statement.name = doc.name.value
    statement.identifier = doc.id.value

    if not knownIdentifiers[statement.identifier] then
      print("new statement: " .. statement.name)
      statement.pdf, _, _, statement.filename = connection:request("GET", urlDlStatement .. statement.identifier, nil, nil, apiHeaders)
    end

    statements[#statements + 1] = statement
  end

  return {statements=statements}
end


function EndSession ()
  -- Logout.
  sendRequest(urlSignout, '{"type":"Signout"}', "Signing out")
end


-- ForgeRock login journey

-- POST the current state (or nothing to start), returns the next state.
-- A rejected login comes back as HTTP 401 which the connection raises as an error.
function authenticate (state, status)

  MM.printStatus(status)

  local body = ""
  if state then
    body = JSON():set(state):json()
  end

  local ok, content = pcall(connection.request, connection, "POST", urlAuthenticate, body, "application/json", authHeaders)

  if not ok then
    print("authenticate failed: " .. tostring(content))
    return { loginFailed = true }
  end

  local result = JSON(content):dictionary()

  if result.code == 401 then
    print("authenticate rejected: " .. tostring(result.message))
    return { loginFailed = true }
  end

  logCallbacks(result)

  return result
end


-- Fill in everything we can answer ourselves.
-- Returns the callback that needs input from the user (OTP), or nil.
function fillCallbacks (state)

  for i, callback in ipairs(state.callbacks or {}) do
    local t = callback.type

    if t == "NameCallback" then
      -- the OTP step reuses NameCallback with a prompt like "Enter verification code"
      if isCodePrompt(string.lower(callbackPrompt(callback))) then
        return callback
      end
      setInput(callback, username)

    elseif t == "PasswordCallback" or t == "ValidatedCreatePasswordCallback" then
      if string.lower(callbackPrompt(callback)):find("password") then
        -- asked for the password a second time means it was rejected
        if passwordSent then
          state.loginFailed = true
          return nil
        end
        passwordSent = true
        setInput(callback, password)
      else
        return callback
      end

    elseif t == "TextInputCallback" or t == "ValidatedCreateStringCallback" or t == "StringAttributeInputCallback" then
      return callback

    elseif t == "ConfirmationCallback" then
      -- wrong OTP comes back as header "Error" with "Try ... again?" Yes/No
      if state.header == "Error" then
        if codeAttempts >= 3 then
          state.loginFailed = true
          return nil
        end
        state.codeRejected = true
      end
      -- options are like "Next"/"Back" or "Yes"/"No": always take the first one
      setInput(callback, 0)

    elseif t == "ChoiceCallback" then
      setInput(callback, getOutput(callback, "defaultChoice") or 0)

    elseif t == "DeviceProfileCallback" then
      setInput(callback, deviceProfile())

    elseif t == "TextOutputCallback" or t == "HiddenValueCallback" or t == "MetadataCallback"
        or t == "SuspendedTextOutputCallback" then
      -- nothing to answer; messageType 4 is a script the browser runs to auto-submit

    else
      error("UNFCU login step not supported yet: " .. tostring(t))
    end
  end

  return nil
end


function getOutput (callback, name)
  for i, output in ipairs(callback.output or {}) do
    if output.name == name then
      return output.value
    end
  end
  return nil
end


function setInput (callback, value)
  if callback.input and callback.input[1] then
    callback.input[1].value = value
  end
end


function isCodePrompt (prompt)
  return prompt:find("code") or prompt:find("verification") or prompt:find("otp") or prompt:find("passcode")
end


function callbackPrompt (callback)
  return tostring(getOutput(callback, "prompt") or getOutput(callback, "message") or "Verification code")
end


function logCallbacks (state)
  if state.tokenId then
    print("login journey finished")
    return
  end
  local types = {}
  for i, callback in ipairs(state.callbacks or {}) do
    types[#types + 1] = callback.type .. "(" .. callbackPrompt(callback):sub(1, 40) .. ")"
  end
  print("callbacks: " .. table.concat(types, ", "))
end


-- Device profile like the ForgeRock web SDK sends it. The identifier is generated once
-- and kept, so UNFCU can recognize MoneyMoney as the same device next time.
function deviceProfile ()

  if not LocalStorage.deviceIdentifier then
    math.randomseed(os.time())
    LocalStorage.deviceIdentifier = string.format("%d-%d-%d",
      math.random(1000000000, 4294967295), math.random(1000000000, 4294967295), math.random(1000000000, 4294967295))
  end

  return JSON():set({
    identifier = LocalStorage.deviceIdentifier,
    metadata = {
      hardware = {
        hardwareConcurrency = 8,
        maxTouchPoints = 0,
        display = { width = 1680, height = 1050, pixelDepth = 24, angle = 0 }
      },
      browser = {
        userAgent = userAgent,
        appName = "Netscape",
        appCodeName = "Mozilla",
        appVersion = userAgent:sub(9),
        product = "Gecko",
        productSub = "20030107",
        vendor = "Apple Computer, Inc.",
        vendorSub = "",
        plugins = "internal-pdf-viewer;"
      },
      platform = {
        language = "en-US",
        platform = "MacIntel",
        deviceName = "MoneyMoney",
        fonts = "cursive;monospace;sans-serif;fantasy;Arial;Courier;Georgia;Tahoma;Verdana;",
        timezone = -120
      }
    }
  }):json()
end


-- internal functions

function sendRequest (url, body, status)

  MM.printStatus(status)

  local content = connection:request("POST", url, body, "application/json", apiHeaders)

  local result = JSON(content):dictionary()

  -- the banking API hands out a CSRF token (e.g. with the account list) which later calls send back
  if result.csrfToken then
    apiHeaders["anti-csrf-token"] = result.csrfToken
  end

  if not result.ok then
    print("request failed: " .. url)
  end

  return result

end


function convertDateToTimestamp(dateTimeToConvert)

  if type(dateTimeToConvert) ~= "string" then
    return nil
  end

  -- Assuming a date pattern like: yyyy-mm-dd hh:mm:ss
  local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)"
  local runyear, runmonth, runday, runhour, runminute, runseconds = dateTimeToConvert:match(pattern)

  return os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})

end
