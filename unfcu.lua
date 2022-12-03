WebBanking{version     = 0.1,
           url         = "https://www.unfcu.org/",
           services    = {"UNFCU"},
           description = "Get balances, transactions and statements for UNFCU accounts"}

apiBaseUrl = "https://digital.unfcu.org/Apps/"

urlUserNameVerify = apiBaseUrl .. "AppAccessPasscodeSignin/UsernameVerify"
urlPasswordVerify = apiBaseUrl .. "AppAccessPasscodeSignin/PasswordVerify"
url2FAVerify = apiBaseUrl .. "AppAccessPasscodeSignin/PasscodeGoogleVerify"
urlSetupRun = apiBaseUrl .. "AppAccessPasscodeSignin/SetupRun"
urlAccountInfo = apiBaseUrl .. "AppCustomMainAccountList/Select"
urlTxInfo = apiBaseUrl .. "AppMainTransactionList/Select"
urlStatements = apiBaseUrl .. "AppMainDocumentList/Select"
urlDlStatement = apiBaseUrl .. "AppMainDocumentList/ViewPdf/"
urlSignout = apiBaseUrl .. "AppAccessPing/Term"

defaultHeaders = {}
defaultHeaders["Accept"] = "application/json"


function SupportsBank (protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "UNFCU"
end


function InitializeSession2 (protocol, bankCode, step, credentials, interactive)

  if step == 1 then
    MM.printStatus("setting up connection")

    connection = Connection()

    connection.useragent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15"

    username = credentials[1]
    password = credentials[2]

    -- we have removed the regexes as they have been causing trouble with escaping
    local json_username = '{"uxFlow":{"id":{"schema":{"type":"PK","parent":false,"name":"Id","size":0,"userMark":"DbFlowAccess Id :","userShow":"ShowText|#10","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":0,"valueNew":0},"insertAt":{"schema":{"type":"DT","parent":false,"name":"InsertAt","label":"InsertAt","size":0,"userMark":"Insert Date :","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"updateAt":{"schema":{"type":"DT","parent":false,"name":"UpdateAt","label":"UpdateAt","size":0,"userMark":"Update Date :","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"dbAccessId":{"schema":{"type":"FK","reference":"DbAccess","parent":true,"name":"DbAccessId","label":"","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":0,"valueNew":0},"tether":{"schema":{"type":"S3","parent":false,"name":"Tether","label":"Tether","desc":"","info":"","help":"","size":0,"userMark":"Tether :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"username":{"schema":{"type":"S3","parent":false,"name":"Username","label":"Username :","desc":"","info":"","help":"","size":0,"userMark":"Username :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":1,"lengthMax":0,"length":0,"message":""}],"valueList":[],"descList":[],"errorList":[]},"value":"' .. username .. '","valueNew":"' .. username .. '","valueLabel":"","valueNewLabel":""},"usernameChangeAt":{"schema":{"type":"DT","parent":false,"name":"UsernameChangeAt","size":0,"userMark":"Last changed :","userEdit":"","userShow":"ShowDate|MMM Do YYYY, hh:mm:ss a","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"usernameSet":{"schema":{"type":"S3","parent":false,"name":"UsernameSet","label":"Username :","desc":"","info":"","help":"","size":0,"userMark":"Username :","userEdit":"EditTextChooseUsername","userShow":"ShowText","userDescList":["minimum of 8 characters","letters and numbers only","at least 1 letter","no spaces","must be available"],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Letters and numbers only"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[A-Za-z]","message":"At least 1 letter"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":8,"lengthMax":0,"length":0,"message":"minimum of 8 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":64,"length":0,"message":"Must be 64 or fewer characters"}],"valueList":[],"descList":["minimum of 8 characters","letters and numbers only","no spaces"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"password":{"schema":{"type":"S3","parent":false,"name":"Password","label":"Password :","desc":"","info":"","help":"","size":0,"userMark":"Password :","userEdit":"EditPassword","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":1,"lengthMax":0,"length":0,"message":""}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passwordChangeAt":{"schema":{"type":"DT","parent":false,"name":"PasswordChangeAt","size":0,"userMark":"Last changed :","userEdit":"","userShow":"ShowDate|MMM Do YYYY, hh:mm:ss a","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passwordSet":{"schema":{"type":"S3","parent":false,"name":"PasswordSet","label":"Password :","desc":"","info":"","help":"","size":0,"userMark":"Password :","userEdit":"EditPasswordConfirm","userShow":"ShowText","userDescList":["minimum of 8 characters","only letters, numbers, and allowed symbols: !@#$%^&*(){}[]","at least one upper case letter","at least one lower case letter","at least one number","no spaces"],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Invalid character, letters, numbers, some symbols only"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[A-Z]","message":"Must have at least 1 upper-case letter"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[a-z]","message":"Must have at least 1 lower-case letter"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[0-9]","message":"Must have at least 1 number"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":8,"lengthMax":0,"length":0,"message":"minimum of 8 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":64,"length":0,"message":"Must be 64 or fewer characters"}],"valueList":[],"descList":["minimum of 8 characters","only letters, numbers, and allowed symbols: !@#$%^&*(){}[]","at least one upper case letter","at least one lower case letter","at least one number","no spaces"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"timeoutSeconds":{"schema":{"type":"LN","parent":false,"name":"TimeoutSeconds","size":0,"userMark":"Idle session timeout :","userEdit":"EditListDrop","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[{"key":"120","label":"2 Minutes","desc":""},{"key":"300","label":"5 Minutes","desc":""},{"key":"600","label":"10 Minutes","desc":""},{"key":"900","label":"15 Minutes","desc":""},{"key":"1200","label":"20 Minutes","desc":""}],"descList":[],"errorList":[]}},"number":{"schema":{"type":"S3","parent":false,"name":"Number","label":"Member Number :","desc":"","info":"","help":"","size":10,"userMark":"Member Number :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be all digits"},{"type":"XRegex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be 7 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"account":{"schema":{"type":"S3","parent":false,"name":"Account","label":"Account Number :","desc":"The full XX digit account number for one of your accounts","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be all digits"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":6,"lengthMax":0,"length":0,"message":"Must be at least 6 digits"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":10,"length":0,"message":"Must be 10 or fewer digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"social":{"schema":{"type":"S3","parent":false,"name":"Social","label":"SSN :","desc":"","info":"","help":"","size":0,"userMark":"SSN :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleSocial","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid social security number or taxid"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"social4":{"schema":{"type":"S3","parent":false,"name":"Social4","label":"Last 4 SSN :","desc":"","info":"","help":"","size":0,"userMark":"Last 4 of SSN :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleSocial4","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be last 4 digits of a social security number or taxid"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"name":{"schema":{"type":"S3","parent":false,"name":"Name","label":"Last Name :","desc":"","info":"","help":"","size":0,"userMark":"Last Name :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"phone":{"schema":{"type":"S3","parent":false,"name":"Phone","label":"Phone Number :","desc":"","info":"","help":"","size":0,"userMark":"Phone Number :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RulePhoneUsa","number":0,"numberMin":0,"numberMax":0,"lengthMin":2,"lengthMax":0,"length":0,"message":"Must be a valid US number"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"email":{"schema":{"type":"S3","parent":false,"name":"Email","label":"Email Address :","desc":"","info":"","help":"","size":0,"userMark":"Email Address :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleEmail","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid email address"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"zipcode":{"schema":{"type":"S3","parent":false,"name":"Zipcode","label":"Postal Code :","desc":"","info":"","help":"","size":0,"userMark":"Postal Code :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleZipcode","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid zipcode"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"age":{"schema":{"type":"S3","parent":false,"name":"Age","label":"Age in Years :","desc":"","info":"","help":"","size":0,"userMark":"Age in Years :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"birthday":{"schema":{"type":"S2","parent":false,"name":"Birthday","label":"Birth Date :","desc":"","info":"","help":"","size":0,"userMark":"Birth Date :","userEdit":"EditDateBirth","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleDate","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a full date"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"securePhrase":{"schema":{"type":"S3","parent":false,"name":"SecurePhrase","label":"Security Phrase :","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"secureImage":{"schema":{"type":"S3","parent":false,"name":"SecureImage","label":"Security Image :","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeBasicActive":{"schema":{"type":"BL","parent":false,"name":"PasscodeBasicActive","label":"","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passcodeBasicChoose":{"schema":{"type":"S3","parent":false,"name":"PasscodeBasicChoose","label":"","desc":"","info":"","help":"","size":0,"userMark":"Send security code to :","userEdit":"EditPasscodeChoose","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeBasicVerify":{"schema":{"type":"S3","parent":false,"name":"PasscodeBasicVerify","label":"Enter security code:","desc":"Enter the 6 digit security code you have received.<br/>Security code may take a few minutes to arrive.","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Your code must be all digits"},{"type":"Length","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":6,"message":"Your code must be 6 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleActive":{"schema":{"type":"BL","parent":false,"name":"PasscodeGoogleActive","label":"","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passcodeGoogleVerify":{"schema":{"type":"S1","parent":false,"name":"PasscodeGoogleVerify","label":"Enter security code displayed in Google Authenticator App :","desc":"You have enabled Google Authenticator for security verification. Please start the Google Authenticator app to retrieve security code.","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Your code must be all digits"},{"type":"Length","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":6,"message":"Your code must be 6 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleScanQr":{"schema":{"type":"S3","parent":false,"name":"PasscodeGoogleScanQr","label":"Scan this Config Code :","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":["Launch the Authenticator App","Tap Begin Setup","Tap Scan Barcode","Use your camera to scan this barcode","or ... ","If Authenticator was already setup","Tap the plus icon on the top right","Tap Scan Barcode","Use your camera to scan this barcode"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleTextQr":{"schema":{"type":"S3","parent":false,"name":"PasscodeGoogleTextQr","label":"Or Type in this Code :","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":["Launch the Google Authenticator App","Tap the Plus icon on the top right","You may manually type in this code"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"remember":{"schema":{"type":"BL","parent":false,"name":"Remember","label":"Use this Computer Often ?","desc":"<b>Save Time !</b> When you remember your device, you will not have to go thru this security code process each time you sign in.  This can make things quicker and easier for you.  Please note, DO NOT select this option if you are on a public computer, such as at a library or hotel.","info":"","help":"","size":0,"userMark":"Use this Computer Often ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"rememberName":{"schema":{"type":"S3","parent":false,"name":"RememberName","label":"Device Name :","info":"","help":"","size":0,"userMark":"Name this Device :","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"deviceSerial":{"schema":{"type":"S3","parent":false,"name":"DeviceSerial","label":"","info":"","help":"","size":0,"userMark":"DeviceSerial :","userDesc":"","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":"","valueNew":""},"deviceTouchEnable":{"schema":{"type":"BL","parent":false,"name":"DeviceTouchEnable","label":"Enable Touch ID ?","info":"","help":"","size":0,"userMark":"Enable Touch ID ?","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":false,"valueNew":false},"deviceTouchName":{"schema":{"type":"S3","parent":false,"name":"DeviceTouchName","label":"","info":"","help":"","size":0,"userMark":"Device Name :","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":4,"lengthMax":0,"length":0,"message":"Must be between 4 and 20 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":20,"length":0,"message":"Must be between 4 and 20 characters"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"signinLockAt":{"schema":{"type":"DT","parent":false,"name":"SigninLockAt","label":"","info":"","help":"","size":0,"userMark":"Access Locked Date :","userDesc":"Your access has been locked because of too many failed signin attempts.","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"signinBlock":{"schema":{"type":"BL","parent":false,"name":"SigninBlock","label":"","info":"","help":"","size":0,"userMark":"Access Blocked :","userDesc":"Your access is blocked.","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"signinFailCount":{"schema":{"type":"LN","parent":false,"name":"SigninFailCount","label":"Device Name :","info":"","help":"","size":0,"userMark":"Failed Sign In Count :","userDesc":"","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"agreement":{"schema":{"type":"S3","parent":false,"name":"Agreement","desc":"Please review the entire agreement by scrolling to the bottom to proceed.","info":"","help":"","size":0,"userMark":"Agreement :","userEdit":"","userShow":"ShowWrap","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"gravatarEmail":{"schema":{"type":"S3","parent":false,"name":"GravatarEmail","desc":"","info":"","help":"","size":0,"userMark":"Gravatar Email :","userEdit":"EditTextGravatar","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"BlankOk","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":""},{"type":"RuleEmail","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid email address"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""}},"deviceId":""}'

    local result = sendRequest( connection, urlUserNameVerify, defaultHeaders, json_username, "Sending username" )

    local json_password = '{"uxFlow":{"id":{"schema":{"type":"PK","parent":false,"name":"Id","size":0,"userMark":"DbFlowAccess Id :","userShow":"ShowText|#10","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":0,"valueNew":0},"insertAt":{"schema":{"type":"DT","parent":false,"name":"InsertAt","label":"InsertAt","size":0,"userMark":"Insert Date :","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"updateAt":{"schema":{"type":"DT","parent":false,"name":"UpdateAt","label":"UpdateAt","size":0,"userMark":"Update Date :","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"dbAccessId":{"schema":{"type":"FK","reference":"DbAccess","parent":true,"name":"DbAccessId","label":"","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":0,"valueNew":0},"tether":{"schema":{"type":"S3","parent":false,"name":"Tether","label":"Tether","desc":"","info":"","help":"","size":0,"userMark":"Tether :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"username":{"schema":{"type":"S3","parent":false,"name":"Username","label":"Username :","desc":"","info":"","help":"","size":0,"userMark":"Username :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":1,"lengthMax":0,"length":0,"message":""}],"valueList":[],"descList":[],"errorList":[]},"value":"' .. username .. '","valueNew":"' .. username .. '","valueLabel":"","valueNewLabel":""},"usernameChangeAt":{"schema":{"type":"DT","parent":false,"name":"UsernameChangeAt","size":0,"userMark":"Last changed :","userEdit":"","userShow":"ShowDate|MMM Do YYYY, hh:mm:ss a","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"usernameSet":{"schema":{"type":"S3","parent":false,"name":"UsernameSet","label":"Username :","desc":"","info":"","help":"","size":0,"userMark":"Username :","userEdit":"EditTextChooseUsername","userShow":"ShowText","userDescList":["minimum of 8 characters","letters and numbers only","at least 1 letter","no spaces","must be available"],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Letters and numbers only"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[A-Za-z]","message":"At least 1 letter"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":8,"lengthMax":0,"length":0,"message":"minimum of 8 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":64,"length":0,"message":"Must be 64 or fewer characters"}],"valueList":[],"descList":["minimum of 8 characters","letters and numbers only","no spaces"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"password":{"schema":{"type":"S3","parent":false,"name":"Password","label":"Password :","desc":"","info":"","help":"","size":0,"userMark":"Password :","userEdit":"EditPassword","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":1,"lengthMax":0,"length":0,"message":""}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":"", "valueNew":"' .. password .. '"},"passwordChangeAt":{"schema":{"type":"DT","parent":false,"name":"PasswordChangeAt","size":0,"userMark":"Last changed :","userEdit":"","userShow":"ShowDate|MMM Do YYYY, hh:mm:ss a","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passwordSet":{"schema":{"type":"S3","parent":false,"name":"PasswordSet","label":"Password :","desc":"","info":"","help":"","size":0,"userMark":"Password :","userEdit":"EditPasswordConfirm","userShow":"ShowText","userDescList":["minimum of 8 characters","only letters, numbers, and allowed symbols: !@#$%^&*(){}[]","at least one upper case letter","at least one lower case letter","at least one number","no spaces"],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Invalid character, letters, numbers, some symbols only"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[A-Z]","message":"Must have at least 1 upper-case letter"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[a-z]","message":"Must have at least 1 lower-case letter"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[0-9]","message":"Must have at least 1 number"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":8,"lengthMax":0,"length":0,"message":"minimum of 8 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":64,"length":0,"message":"Must be 64 or fewer characters"}],"valueList":[],"descList":["minimum of 8 characters","only letters, numbers, and allowed symbols: !@#$%^&*(){}[]","at least one upper case letter","at least one lower case letter","at least one number","no spaces"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"timeoutSeconds":{"schema":{"type":"LN","parent":false,"name":"TimeoutSeconds","size":0,"userMark":"Idle session timeout :","userEdit":"EditListDrop","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[{"key":"120","label":"2 Minutes","desc":""},{"key":"300","label":"5 Minutes","desc":""},{"key":"600","label":"10 Minutes","desc":""},{"key":"900","label":"15 Minutes","desc":""},{"key":"1200","label":"20 Minutes","desc":""}],"descList":[],"errorList":[]}},"number":{"schema":{"type":"S3","parent":false,"name":"Number","label":"Member Number :","desc":"","info":"","help":"","size":10,"userMark":"Member Number :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be all digits"},{"type":"XRegex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be 7 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"account":{"schema":{"type":"S3","parent":false,"name":"Account","label":"Account Number :","desc":"The full XX digit account number for one of your accounts","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be all digits"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":6,"lengthMax":0,"length":0,"message":"Must be at least 6 digits"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":10,"length":0,"message":"Must be 10 or fewer digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"social":{"schema":{"type":"S3","parent":false,"name":"Social","label":"SSN :","desc":"","info":"","help":"","size":0,"userMark":"SSN :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleSocial","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid social security number or taxid"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"social4":{"schema":{"type":"S3","parent":false,"name":"Social4","label":"Last 4 SSN :","desc":"","info":"","help":"","size":0,"userMark":"Last 4 of SSN :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleSocial4","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be last 4 digits of a social security number or taxid"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"name":{"schema":{"type":"S3","parent":false,"name":"Name","label":"Last Name :","desc":"","info":"","help":"","size":0,"userMark":"Last Name :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"phone":{"schema":{"type":"S3","parent":false,"name":"Phone","label":"Phone Number :","desc":"","info":"","help":"","size":0,"userMark":"Phone Number :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RulePhoneUsa","number":0,"numberMin":0,"numberMax":0,"lengthMin":2,"lengthMax":0,"length":0,"message":"Must be a valid US number"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"email":{"schema":{"type":"S3","parent":false,"name":"Email","label":"Email Address :","desc":"","info":"","help":"","size":0,"userMark":"Email Address :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleEmail","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid email address"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"zipcode":{"schema":{"type":"S3","parent":false,"name":"Zipcode","label":"Postal Code :","desc":"","info":"","help":"","size":0,"userMark":"Postal Code :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleZipcode","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid zipcode"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"age":{"schema":{"type":"S3","parent":false,"name":"Age","label":"Age in Years :","desc":"","info":"","help":"","size":0,"userMark":"Age in Years :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"birthday":{"schema":{"type":"S2","parent":false,"name":"Birthday","label":"Birth Date :","desc":"","info":"","help":"","size":0,"userMark":"Birth Date :","userEdit":"EditDateBirth","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleDate","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a full date"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"securePhrase":{"schema":{"type":"S3","parent":false,"name":"SecurePhrase","label":"Security Phrase :","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"secureImage":{"schema":{"type":"S3","parent":false,"name":"SecureImage","label":"Security Image :","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeBasicActive":{"schema":{"type":"BL","parent":false,"name":"PasscodeBasicActive","label":"","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passcodeBasicChoose":{"schema":{"type":"S3","parent":false,"name":"PasscodeBasicChoose","label":"","desc":"","info":"","help":"","size":0,"userMark":"Send security code to :","userEdit":"EditPasscodeChoose","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeBasicVerify":{"schema":{"type":"S3","parent":false,"name":"PasscodeBasicVerify","label":"Enter security code:","desc":"Enter the 6 digit security code you have received.<br/>Security code may take a few minutes to arrive.","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Your code must be all digits"},{"type":"Length","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":6,"message":"Your code must be 6 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleActive":{"schema":{"type":"BL","parent":false,"name":"PasscodeGoogleActive","label":"","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passcodeGoogleVerify":{"schema":{"type":"S1","parent":false,"name":"PasscodeGoogleVerify","label":"Enter security code displayed in Google Authenticator App :","desc":"You have enabled Google Authenticator for security verification. Please start the Google Authenticator app to retrieve security code.","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Your code must be all digits"},{"type":"Length","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":6,"message":"Your code must be 6 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleScanQr":{"schema":{"type":"S3","parent":false,"name":"PasscodeGoogleScanQr","label":"Scan this Config Code :","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":["Launch the Authenticator App","Tap Begin Setup","Tap Scan Barcode","Use your camera to scan this barcode","or ... ","If Authenticator was already setup","Tap the plus icon on the top right","Tap Scan Barcode","Use your camera to scan this barcode"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleTextQr":{"schema":{"type":"S3","parent":false,"name":"PasscodeGoogleTextQr","label":"Or Type in this Code :","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":["Launch the Google Authenticator App","Tap the Plus icon on the top right","You may manually type in this code"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"remember":{"schema":{"type":"BL","parent":false,"name":"Remember","label":"Use this Computer Often ?","desc":"<b>Save Time !</b> When you remember your device, you will not have to go thru this security code process each time you sign in.  This can make things quicker and easier for you.  Please note, DO NOT select this option if you are on a public computer, such as at a library or hotel.","info":"","help":"","size":0,"userMark":"Use this Computer Often ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"rememberName":{"schema":{"type":"S3","parent":false,"name":"RememberName","label":"Device Name :","info":"","help":"","size":0,"userMark":"Name this Device :","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"deviceSerial":{"schema":{"type":"S3","parent":false,"name":"DeviceSerial","label":"","info":"","help":"","size":0,"userMark":"DeviceSerial :","userDesc":"","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":"","valueNew":""},"deviceTouchEnable":{"schema":{"type":"BL","parent":false,"name":"DeviceTouchEnable","label":"Enable Touch ID ?","info":"","help":"","size":0,"userMark":"Enable Touch ID ?","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":false,"valueNew":false},"deviceTouchName":{"schema":{"type":"S3","parent":false,"name":"DeviceTouchName","label":"","info":"","help":"","size":0,"userMark":"Device Name :","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":4,"lengthMax":0,"length":0,"message":"Must be between 4 and 20 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":20,"length":0,"message":"Must be between 4 and 20 characters"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"signinLockAt":{"schema":{"type":"DT","parent":false,"name":"SigninLockAt","label":"","info":"","help":"","size":0,"userMark":"Access Locked Date :","userDesc":"Your access has been locked because of too many failed signin attempts.","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"signinBlock":{"schema":{"type":"BL","parent":false,"name":"SigninBlock","label":"","info":"","help":"","size":0,"userMark":"Access Blocked :","userDesc":"Your access is blocked.","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"signinFailCount":{"schema":{"type":"LN","parent":false,"name":"SigninFailCount","label":"Device Name :","info":"","help":"","size":0,"userMark":"Failed Sign In Count :","userDesc":"","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"agreement":{"schema":{"type":"S3","parent":false,"name":"Agreement","desc":"Please review the entire agreement by scrolling to the bottom to proceed.","info":"","help":"","size":0,"userMark":"Agreement :","userEdit":"","userShow":"ShowWrap","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"gravatarEmail":{"schema":{"type":"S3","parent":false,"name":"GravatarEmail","desc":"","info":"","help":"","size":0,"userMark":"Gravatar Email :","userEdit":"EditTextGravatar","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"BlankOk","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":""},{"type":"RuleEmail","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid email address"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""}},"deviceId":""}'

    local result = sendRequest( connection, urlPasswordVerify, defaultHeaders, json_password, "Sending password" )

    return { title="Enter Google Authenticator One Time Password (OTP) for UNFCU", challenge="", label="OTP" }

  else

    local twofa_response = credentials[1]

    local json_2fa = '{"uxFlow":{"id":{"schema":{"type":"PK","parent":false,"name":"Id","size":0,"userMark":"DbFlowAccess Id :","userShow":"ShowText|#10","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":0,"valueNew":0},"insertAt":{"schema":{"type":"DT","parent":false,"name":"InsertAt","label":"InsertAt","size":0,"userMark":"Insert Date :","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"updateAt":{"schema":{"type":"DT","parent":false,"name":"UpdateAt","label":"UpdateAt","size":0,"userMark":"Update Date :","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"dbAccessId":{"schema":{"type":"FK","reference":"DbAccess","parent":true,"name":"DbAccessId","label":"","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":0,"valueNew":0},"tether":{"schema":{"type":"S3","parent":false,"name":"Tether","label":"Tether","desc":"","info":"","help":"","size":0,"userMark":"Tether :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"username":{"schema":{"type":"S3","parent":false,"name":"Username","label":"Username :","desc":"","info":"","help":"","size":0,"userMark":"Username :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":1,"lengthMax":0,"length":0,"message":""}],"valueList":[],"descList":[],"errorList":[]},"value":"' .. username .. '","valueNew":"' .. username .. '","valueLabel":"","valueNewLabel":""},"usernameChangeAt":{"schema":{"type":"DT","parent":false,"name":"UsernameChangeAt","size":0,"userMark":"Last changed :","userEdit":"","userShow":"ShowDate|MMM Do YYYY, hh:mm:ss a","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"usernameSet":{"schema":{"type":"S3","parent":false,"name":"UsernameSet","label":"Username :","desc":"","info":"","help":"","size":0,"userMark":"Username :","userEdit":"EditTextChooseUsername","userShow":"ShowText","userDescList":["minimum of 8 characters","letters and numbers only","at least 1 letter","no spaces","must be available"],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Letters and numbers only"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[A-Za-z]","message":"At least 1 letter"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":8,"lengthMax":0,"length":0,"message":"minimum of 8 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":64,"length":0,"message":"Must be 64 or fewer characters"}],"valueList":[],"descList":["minimum of 8 characters","letters and numbers only","no spaces"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"password":{"schema":{"type":"S3","parent":false,"name":"Password","label":"Password :","desc":"","info":"","help":"","size":0,"userMark":"Password :","userEdit":"EditPassword","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":1,"lengthMax":0,"length":0,"message":""}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passwordChangeAt":{"schema":{"type":"DT","parent":false,"name":"PasswordChangeAt","size":0,"userMark":"Last changed :","userEdit":"","userShow":"ShowDate|MMM Do YYYY, hh:mm:ss a","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passwordSet":{"schema":{"type":"S3","parent":false,"name":"PasswordSet","label":"Password :","desc":"","info":"","help":"","size":0,"userMark":"Password :","userEdit":"EditPasswordConfirm","userShow":"ShowText","userDescList":["minimum of 8 characters","only letters, numbers, and allowed symbols: !@#$%^&*(){}[]","at least one upper case letter","at least one lower case letter","at least one number","no spaces"],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Invalid character, letters, numbers, some symbols only"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[A-Z]","message":"Must have at least 1 upper-case letter"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[a-z]","message":"Must have at least 1 lower-case letter"},{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"[0-9]","message":"Must have at least 1 number"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":8,"lengthMax":0,"length":0,"message":"minimum of 8 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":64,"length":0,"message":"Must be 64 or fewer characters"}],"valueList":[],"descList":["minimum of 8 characters","only letters, numbers, and allowed symbols: !@#$%^&*(){}[]","at least one upper case letter","at least one lower case letter","at least one number","no spaces"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"timeoutSeconds":{"schema":{"type":"LN","parent":false,"name":"TimeoutSeconds","size":0,"userMark":"Idle session timeout :","userEdit":"EditListDrop","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[{"key":"120","label":"2 Minutes","desc":""},{"key":"300","label":"5 Minutes","desc":""},{"key":"600","label":"10 Minutes","desc":""},{"key":"900","label":"15 Minutes","desc":""},{"key":"1200","label":"20 Minutes","desc":""}],"descList":[],"errorList":[]}},"number":{"schema":{"type":"S3","parent":false,"name":"Number","label":"Member Number :","desc":"","info":"","help":"","size":10,"userMark":"Member Number :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be all digits"},{"type":"XRegex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be 7 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"account":{"schema":{"type":"S3","parent":false,"name":"Account","label":"Account Number :","desc":"The full XX digit account number for one of your accounts","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Must be all digits"},{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":6,"lengthMax":0,"length":0,"message":"Must be at least 6 digits"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":10,"length":0,"message":"Must be 10 or fewer digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"social":{"schema":{"type":"S3","parent":false,"name":"Social","label":"SSN :","desc":"","info":"","help":"","size":0,"userMark":"SSN :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleSocial","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid social security number or taxid"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"social4":{"schema":{"type":"S3","parent":false,"name":"Social4","label":"Last 4 SSN :","desc":"","info":"","help":"","size":0,"userMark":"Last 4 of SSN :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleSocial4","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be last 4 digits of a social security number or taxid"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"name":{"schema":{"type":"S3","parent":false,"name":"Name","label":"Last Name :","desc":"","info":"","help":"","size":0,"userMark":"Last Name :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"phone":{"schema":{"type":"S3","parent":false,"name":"Phone","label":"Phone Number :","desc":"","info":"","help":"","size":0,"userMark":"Phone Number :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RulePhoneUsa","number":0,"numberMin":0,"numberMax":0,"lengthMin":2,"lengthMax":0,"length":0,"message":"Must be a valid US number"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"email":{"schema":{"type":"S3","parent":false,"name":"Email","label":"Email Address :","desc":"","info":"","help":"","size":0,"userMark":"Email Address :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleEmail","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid email address"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"zipcode":{"schema":{"type":"S3","parent":false,"name":"Zipcode","label":"Postal Code :","desc":"","info":"","help":"","size":0,"userMark":"Postal Code :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleZipcode","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid zipcode"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"age":{"schema":{"type":"S3","parent":false,"name":"Age","label":"Age in Years :","desc":"","info":"","help":"","size":0,"userMark":"Age in Years :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"birthday":{"schema":{"type":"S2","parent":false,"name":"Birthday","label":"Birth Date :","desc":"","info":"","help":"","size":0,"userMark":"Birth Date :","userEdit":"EditDateBirth","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"RuleDate","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a full date"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"securePhrase":{"schema":{"type":"S3","parent":false,"name":"SecurePhrase","label":"Security Phrase :","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"secureImage":{"schema":{"type":"S3","parent":false,"name":"SecureImage","label":"Security Image :","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeBasicActive":{"schema":{"type":"BL","parent":false,"name":"PasscodeBasicActive","label":"","desc":"","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passcodeBasicChoose":{"schema":{"type":"S3","parent":false,"name":"PasscodeBasicChoose","label":"","desc":"","info":"","help":"","size":0,"userMark":"Send security code to :","userEdit":"EditPasscodeChoose","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeBasicVerify":{"schema":{"type":"S3","parent":false,"name":"PasscodeBasicVerify","label":"Enter security code:","desc":"Enter the 6 digit security code you have received.<br/>Security code may take a few minutes to arrive.","info":"","help":"","size":0,"userMark":"Remember Device ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Your code must be all digits"},{"type":"Length","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":6,"message":"Your code must be 6 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleActive":{"schema":{"type":"BL","parent":false,"name":"PasscodeGoogleActive","label":"","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"passcodeGoogleVerify":{"schema":{"type":"S1","parent":false,"name":"PasscodeGoogleVerify","label":"Enter security code displayed in Google Authenticator App :","desc":"You have enabled Google Authenticator for security verification. Please start the Google Authenticator app to retrieve security code.","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"Regex","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"regex":"","message":"Your code must be all digits"},{"type":"Length","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":6,"message":"Your code must be 6 digits"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":"","valueNew":"'.. twofa_response ..'"},"passcodeGoogleScanQr":{"schema":{"type":"S3","parent":false,"name":"PasscodeGoogleScanQr","label":"Scan this Config Code :","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":["Launch the Authenticator App","Tap Begin Setup","Tap Scan Barcode","Use your camera to scan this barcode","or ... ","If Authenticator was already setup","Tap the plus icon on the top right","Tap Scan Barcode","Use your camera to scan this barcode"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"passcodeGoogleTextQr":{"schema":{"type":"S3","parent":false,"name":"PasscodeGoogleTextQr","label":"Or Type in this Code :","desc":"","info":"","help":"","size":0,"userMark":"XXX :","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":["Launch the Google Authenticator App","Tap the Plus icon on the top right","You may manually type in this code"],"errorList":[]},"valueLabel":"","valueNewLabel":""},"remember":{"schema":{"type":"BL","parent":false,"name":"Remember","label":"Use this Computer Often ?","desc":"<b>Save Time !</b> When you remember your device, you will not have to go thru this security code process each time you sign in.  This can make things quicker and easier for you.  Please note, DO NOT select this option if you are on a public computer, such as at a library or hotel.","info":"","help":"","size":0,"userMark":"Use this Computer Often ?","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"rememberName":{"schema":{"type":"S3","parent":false,"name":"RememberName","label":"Device Name :","info":"","help":"","size":0,"userMark":"Name this Device :","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"deviceSerial":{"schema":{"type":"S3","parent":false,"name":"DeviceSerial","label":"","info":"","help":"","size":0,"userMark":"DeviceSerial :","userDesc":"","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":"","valueNew":""},"deviceTouchEnable":{"schema":{"type":"BL","parent":false,"name":"DeviceTouchEnable","label":"Enable Touch ID ?","info":"","help":"","size":0,"userMark":"Enable Touch ID ?","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"value":false,"valueNew":false},"deviceTouchName":{"schema":{"type":"S3","parent":false,"name":"DeviceTouchName","label":"","info":"","help":"","size":0,"userMark":"Device Name :","userDesc":"","userEdit":"EditText","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"LengthMin","number":0,"numberMin":0,"numberMax":0,"lengthMin":4,"lengthMax":0,"length":0,"message":"Must be between 4 and 20 characters"},{"type":"LengthMax","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":20,"length":0,"message":"Must be between 4 and 20 characters"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"signinLockAt":{"schema":{"type":"DT","parent":false,"name":"SigninLockAt","label":"","info":"","help":"","size":0,"userMark":"Access Locked Date :","userDesc":"Your access has been locked because of too many failed signin attempts.","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"signinBlock":{"schema":{"type":"BL","parent":false,"name":"SigninBlock","label":"","info":"","help":"","size":0,"userMark":"Access Blocked :","userDesc":"Your access is blocked.","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"signinFailCount":{"schema":{"type":"LN","parent":false,"name":"SigninFailCount","label":"Device Name :","info":"","help":"","size":0,"userMark":"Failed Sign In Count :","userDesc":"","userEdit":"","userShow":"ShowText","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]}},"agreement":{"schema":{"type":"S3","parent":false,"name":"Agreement","desc":"Please review the entire agreement by scrolling to the bottom to proceed.","info":"","help":"","size":0,"userMark":"Agreement :","userEdit":"","userShow":"ShowWrap","userDescList":[],"verifyList":[],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""},"gravatarEmail":{"schema":{"type":"S3","parent":false,"name":"GravatarEmail","desc":"","info":"","help":"","size":0,"userMark":"Gravatar Email :","userEdit":"EditTextGravatar","userShow":"ShowText","userDescList":[],"verifyList":[{"type":"BlankOk","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":""},{"type":"RuleEmail","number":0,"numberMin":0,"numberMax":0,"lengthMin":0,"lengthMax":0,"length":0,"message":"Must be a valid email address"}],"valueList":[],"descList":[],"errorList":[]},"valueLabel":"","valueNewLabel":""}},"deviceId":""}'

    local result = sendRequest( connection, url2FAVerify, defaultHeaders, json_2fa, "Sending 2FA response" )

    local result = sendRequest( connection, urlSetupRun, defaultHeaders, '{}', "Setting up" )

    if result.ok then
      print("request succeeded")
    else
      print("request failed")
    end

    -- TODO: implement proper conditions for failure: content is empty / timeout / result.ok is false

    if result.accessOk then
      print("access granted")
    else
      print("access denied")
      error ("failed to login with given username and password")
    end

  end
end


function ListAccounts (knownAccounts)

  local result = sendRequest( connection, urlAccountInfo, defaultHeaders, '{}', "Getting account info" )

  -- Return array of accounts.
  local numAccounts = result.dxAccountCount

  print(numAccounts .. " accounts found")

  local accounts = {}

  for i=1, numAccounts do
--    print("loop no. " .. i)
--    print(result.dxAccountList[i].name)

    local accountType
    if result.dxAccountList[i].name == 'Checking Account' then
      type = AccountTypeGiro
    elseif result.dxAccountList[i].name == 'High-Yield Savings Account' then
      type = AccountTypeSavings
    elseif result.dxAccountList[i].name == 'Membership Share' then
      type = AccountTypeOther
    else
      type = AccountTypeOther
    end

    -- we store the internal id of each account in the subAccount property
    local account = {
      name = result.dxAccountList[i].name,
      accountNumber = result.dxAccountList[i].number,
      subAccount = result.dxAccountList[i].id10,
      bankCode = "226078609",
      currency = "USD",
      type = accountType
    }

    accounts[i] = account
  end

  return accounts
end


function RefreshAccount (account, since)

  local result = sendRequest( connection, urlTxInfo, defaultHeaders, '{"uxAccountId":"' .. account.subAccount .. '"}', "Getting transactions" )

  local numTxs = result.searchResult.totalCount

  print(numTxs .. " transactions found")

  local transactions = {}

  -- build transaction list
  for i=1, numTxs do
    print("  tx no. " .. i)
    if (result.uxTransactionSearchList[i]) then
      print("   processing")

      local transaction = {}
      transaction.name = result.uxTransactionSearchList[i].dbTransactionId.value
      transaction.amount = result.uxTransactionSearchList[i].dbTransactionAmountDisp.value
      transaction.currency = "USD"
      transaction.bookingDate = convertDateToTimestamp(result.uxTransactionSearchList[i].dbTransactionDatePost.value)
      transaction.valueDate = convertDateToTimestamp(result.uxTransactionSearchList[i].dbTransactionDateDisp.value)
      transaction.purpose = result.uxTransactionSearchList[i].dbTransactionMemo.value
      transaction.transactionCode = result.uxTransactionSearchList[i].dbTransactionId.value

      -- for pending transactions
      if result.uxTransactionSearchList[i].dbTransactionGroupName.value == "Pend" then
        transaction.booked = false
        transaction.purpose = result.uxTransactionSearchList[i].dbTransactionDesc.value
      end

      transactions[i] = transaction
    end
  end

  -- now let's retrieve the balance
  local balance

  for i=1, #result.dxAccountList do
    if result.dxAccountList[i].id10 == account.subAccount then
      balance = result.dxAccountList[i].balance
    end
  end

  return {balance=balance, transactions=transactions}
end


function FetchStatements (accounts, knownIdentifiers)

  local statements = {}

  -- Load statements
  local result = sendRequest( connection, urlStatements, defaultHeaders, '{"search":""}', "Fetching statements..." )

  local numStmts = result.searchResult.totalCount

  print(numStmts .. " statements found")

  for i=1, numStmts do
    local statement = {}
    statement.creationDate = convertDateToTimestamp(result.uxDocumentList[i].date.value)
    statement.name = result.uxDocumentList[i].name.value
    statement.identifier = result.uxDocumentList[i].id.value

    if not knownIdentifiers[statement.identifier] then
      print("new statement")
      print(statement.creationDate)
      print(statement.name)
      print(statement.identifier)
      statement.pdf, _, _, statement.filename = connection:request("GET", urlDlStatement .. statement.identifier)
    end

    statements[i] = statement
  end

  return {statements=statements}
end


function EndSession ()
  -- Logout.
  local result = sendRequest( connection, urlSignout, defaultHeaders, '{"type":"Signout"}', "Signing out" )
end


-- internal functions
function sendRequest ( connection, url, requestheaders, body, status)

  MM.printStatus(status)

  content, charset, mimeType, headers = connection:request("POST",
          url,
          body,
          "application/json; charset=UTF-8",
          requestheaders)

--  local cookies = connection:getCookies()
--  print("content: " .. content)
--  print("charset: " .. charset)
--  print("mimeType:" .. mimeType)
--  print("headers:" .. headers)
--  print("cookies: " .. cookies)

  local result = parse(content)

  if result.ok then
    print("request succeeded")
  else
    print("request failed")
  end

  if result.accessOk then
    print("access granted")
  else
    print("access not granted")
  end

  return result

end


function convertDateToTimestamp(dateTimeToConvert)

  -- Assuming a date pattern like: yyyy-mm-dd hh:mm:ss
  local pattern = "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)"
  local runyear, runmonth, runday, runhour, runminute, runseconds = dateTimeToConvert:match(pattern)

  return os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})

end

-- Thanks to Tyler Neylon for this awesome code to parse JSON
-- https://gist.github.com/tylerneylon/59f4bcf316be525b30ab

-- Internal functions.

local function kind_of(obj)
  if type(obj) ~= 'table' then return type(obj) end
  local i = 1
  for _ in pairs(obj) do
    if obj[i] ~= nil then i = i + 1 else return 'table' end
  end
  if i == 1 then return 'table' else return 'array' end
end

local function escape_str(s)
  local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
  local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
  for i, c in ipairs(in_char) do
    s = s:gsub(c, '\\' .. out_char[i])
  end
  return s
end

-- Returns pos, did_find; there are two cases:
-- 1. Delimiter found: pos = pos after leading space + delim; did_find = true.
-- 2. Delimiter not found: pos = pos after leading space;     did_find = false.
-- This throws an error if err_if_missing is true and the delim is not found.
local function skip_delim(str, pos, delim, err_if_missing)
  pos = pos + #str:match('^%s*', pos)
  if str:sub(pos, pos) ~= delim then
    if err_if_missing then
      error('Expected ' .. delim .. ' near position ' .. pos)
    end
    return pos, false
  end
  return pos + 1, true
end

-- Expects the given pos to be the first character after the opening quote.
-- Returns val, pos; the returned pos is after the closing quote character.
local function parse_str_val(str, pos, val)
  val = val or ''
  local early_end_error = 'End of input found while parsing string.'
  if pos > #str then error(early_end_error) end
  local c = str:sub(pos, pos)
  if c == '"'  then return val, pos + 1 end
  if c ~= '\\' then return parse_str_val(str, pos + 1, val .. c) end
  -- We must have a \ character.
  local esc_map = {b = '\b', f = '\f', n = '\n', r = '\r', t = '\t'}
  local nextc = str:sub(pos + 1, pos + 1)
  if not nextc then error(early_end_error) end
  return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
end

-- Returns val, pos; the returned pos is after the number's final character.
local function parse_num_val(str, pos)
  local num_str = str:match('^-?%d+%.?%d*[eE]?[+-]?%d*', pos)
  local val = tonumber(num_str)
  if not val then error('Error parsing number at position ' .. pos .. '.') end
  return val, pos + #num_str
end


-- Public values and functions.

function stringify(obj, as_key)
  local s = {}  -- We'll build the string as an array of strings to be concatenated.
  local kind = kind_of(obj)  -- This is 'array' if it's an array or type(obj) otherwise.
  if kind == 'array' then
    if as_key then error('Can\'t encode array as key.') end
    s[#s + 1] = '['
    for i, val in ipairs(obj) do
      if i > 1 then s[#s + 1] = ', ' end
      s[#s + 1] = stringify(val)
    end
    s[#s + 1] = ']'
  elseif kind == 'table' then
    if as_key then error('Can\'t encode table as key.') end
    s[#s + 1] = '{'
    for k, v in pairs(obj) do
      if #s > 1 then s[#s + 1] = ', ' end
      s[#s + 1] = stringify(k, true)
      s[#s + 1] = ':'
      s[#s + 1] = stringify(v)
    end
    s[#s + 1] = '}'
  elseif kind == 'string' then
    return '"' .. escape_str(obj) .. '"'
  elseif kind == 'number' then
    if as_key then return '"' .. tostring(obj) .. '"' end
    return tostring(obj)
  elseif kind == 'boolean' then
    return tostring(obj)
  elseif kind == 'nil' then
    return 'null'
  else
    error('Unjsonifiable type: ' .. kind .. '.')
  end
  return table.concat(s)
end

function parse(str, pos, end_delim)
  local null = {}

  pos = pos or 1
  if pos > #str then error('Reached unexpected end of input.') end
  local pos = pos + #str:match('^%s*', pos)  -- Skip whitespace.
  local first = str:sub(pos, pos)
  if first == '{' then  -- Parse an object.
    local obj, key, delim_found = {}, true, true
    pos = pos + 1
    while true do
      key, pos = parse(str, pos, '}')
      if key == nil then return obj, pos end
      if not delim_found then error('Comma missing between object items.') end
      pos = skip_delim(str, pos, ':', true)  -- true -> error if missing.
      obj[key], pos = parse(str, pos)
      pos, delim_found = skip_delim(str, pos, ',')
    end
  elseif first == '[' then  -- Parse an array.
    local arr, val, delim_found = {}, true, true
    pos = pos + 1
    while true do
      val, pos = parse(str, pos, ']')
      if val == nil then return arr, pos end
      if not delim_found then error('Comma missing between array items.') end
      arr[#arr + 1] = val
      pos, delim_found = skip_delim(str, pos, ',')
    end
  elseif first == '"' then  -- Parse a string.
    return parse_str_val(str, pos + 1)
  elseif first == '-' or first:match('%d') then  -- Parse a number.
    return parse_num_val(str, pos)
  elseif first == end_delim then  -- End of an object or array.
    return nil, pos + 1
  else  -- Parse true, false, or null.
    local literals = {['true'] = true, ['false'] = false, ['null'] = null}
    for lit_str, lit_val in pairs(literals) do
      local lit_end = pos + #lit_str - 1
      if str:sub(pos, lit_end) == lit_str then return lit_val, lit_end + 1 end
    end
    local pos_info_str = 'position ' .. pos .. ': ' .. str:sub(pos, pos + 10)
    error('Invalid json syntax starting at ' .. pos_info_str)
  end
end
