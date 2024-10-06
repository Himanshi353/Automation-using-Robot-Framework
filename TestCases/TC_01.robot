*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${url}                 https://magento.softwaretestingboard.com/
${browser}             chrome
${chrome_driver_path}  C:/Users/himan/Downloads/chromedriver-win64 (2)/chromedriver-win64/chromedriver.exe
${emailid}             himanshigupta777@gmail.com
${password}            hg777@123
${fname}               Himanshi
${lname}               Gupta
${fullname}            Himanshi Gupta
${incorrectpassword}   hg112@11
${searchitem}          jackets
${incorrectpswdmsg}    The account sign-in was incorrect or your account is disabled temporarily. Please wait and try again later.
${successfulregistrationmsg}    Thank you for registering with Main Website Store.
${alreadyexistingactmsg}    There is already an account with this email address. If you are sure that it is your email address,

*** Keywords ***
Open New Tab
    [Documentation]  This keyword opens a new browser tab and switches to it.
    Execute Javascript    window.open()  # Open a new blank tab
    Switch Window    NEW  # Switch to the newly opened tab

LogoutUserAccount
    [Documentation]   Log out User account.
    click element   xpath:(//button[@type='button'])[1]
    click link      xpath://li[@class='authorization-link']/a
    Sleep  6s

*** Test Cases ***
RegisterUserTest
    [Tags]     P1   Positive
    [Documentation]   Register new user.
    Open Browser    ${url}    ${browser}    executable_path=${chrome_driver_path}
    Maximize Browser Window
    Title Should Be     Home Page
    Sleep    2s
    Click Link      xpath://a[text()='Create an Account']
    Sleep    2s
    Input Text      id:firstname    ${fname}
    Input Text      id:lastname     ${lname}
    Input Text      id:email_address    ${emailid}
    Input Text      id:password  ${password}
    Input Text      id:password-confirmation   ${password}
    Click Element   xpath://span[text()='Create an Account']
    Sleep    2s

VerifyImmidiateLoginAfterRegistration
    [Tags]     P2   Positive
    [Documentation]   Verify that user has been successfully logged in.
    Sleep   2s
    Element Should Contain   xpath://span[@class='logged-in']   ${fname}
    LogoutUserAccount

SearchFunctionalityTest
    [Tags]     P4   Positive
    [Documentation]   Search Functionality Test.
    Go To    ${url}
    Maximize Browser Window
    Input Text      id:search   ${searchitem}
    Sleep   3s
    Click Element   xpath://li/span[text()=' Jackets for women']



LoginUser
    [Tags]  P3  Negative
    [Documentation]   Login with valid account.
    Go To   ${url}

    Wait Until Element Is Visible   xpath://a[normalize-space()='Sign In']      timeout=10s
    click link  xpath://a[normalize-space()='Sign In']
    Wait Until Element Is Visible  id:email    timeout=10s
    input text  id:email    ${emailid}
    Wait Until Element Is Visible    id:pass   timeout=10s
    input text  id:pass   ${password}
    Sleep  2s
    click element   id:send2
    Sleep  2s
    Element Should Contain   xpath://span[@class='logged-in']   ${fname}
    Sleep  2s
    LogoutUserAccount
    Sleep  2s

RegisterExistingUser
    [Tags]  P5  Negative
    [Documentation]   Register with existing emailid.
    Go To    ${url}
    Click Link      xpath://a[text()='Create an Account']
    Input Text      id:firstname    ${fname}
    Input Text      id:lastname     ${lname}
    Input Text      id:email_address    ${emailid}
    Input Text      id:password  ${password}
    Input Text      id:password-confirmation   ${password}
    Click Element   xpath://span[text()='Create an Account']
    Sleep    2s
    element should contain  xpath://div[@class='messages']/div/div      ${alreadyexistingactmsg}

LoginUsingIncorrectPassword
    [Tags]    P6    Negative
    [Documentation]   Logging in with incorrect password.
    Go To    ${url}
    click link  xpath://a[normalize-space()='Sign In']
    Sleep   2s
    input text  id:email    ${emailid}
    input text  id:pass   ${incorrectpassword}
    Sleep   3s
    click element   id:send2
    Sleep   2s
    Element Should contain  xpath://div[@class='messages']/div/div          ${incorrectpswdmsg}
    Close Browser
