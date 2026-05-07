*** Settings ***
Documentation     Sample Suite for learning Robot Framework
Default Tags    sample
Force Tags     sample1
Suite Setup    Log To Console    Starting Sample Test Suite
Suite Teardown    Log To Console    Ending Sample Test Suite
Test Setup    Log To Console    Starting Test Case
Test Teardown    Log To Console    Ending Test Case
#Test Template    Log Response

*** Variables ***
@{list}   1   2    3
&{dict}   key1=value1    key2=value2


*** Test Cases ***
1. Test Case 1
    [Template]    Log Response 
    This is the first test case.

#2. Test Case 2      This is the second test case.
3. Test Case 3      #This is the third test case.
    [Tags]    sample2
    FOR   ${item}    IN    @{list}
        Log To Console   Item: ${item}
    END

4.Test Case 4
    [Tags]    sample3
    FOR    ${key}    ${value}    IN    &{dict}
        Exit For Loop If    "${key}" == "key2"
        Log To Console    Key: ${key}, Value: ${value}
    END

*** Keywords ***
Log Response
    [Arguments]    ${arguments}
    Log    Arguments: ${arguments}

## Run Commands ##
#robot sample.robot
#robot -T sample.robot (gives log files with time stamp rather than overwriting)
#robot -i sample3 sample.robot (Execute only test case 4)
#robot -i sample3 -i sample1 sample.robot (execute all since sample1 is force tag)
#robot -d /Desktop sample.robot (log files are stored in desktop folder)
#python -m robot --rerunfailed output.xml tests.robot
#python -m robot --merge output.xml rerun.xml


# Templetes
1. One way: refer testcase 1
2. Another: Refer Test case 2 and test template

#Inbuilt keywords in Robot
Log    Hello World
Log To Console    Running Test
Log Many    Apple    Banana    Mango
${name}=    Set Variable    Deepa
Log    ${name}
Set Global Variable    ${ENV}    QA
Set Test Variable    ${browser}    Chrome

Run Keyword If    ${status} == 200    Log    Success
Run Keywords
...    Log    Step1
...    AND
...    Log    Step2
Return From Keyword If    ${flag} == True

JOSN
====
${json}=    Set Variable    ${response.json()}

FOR    ${i}    IN RANGE    5
    Log To Console    ${i}
END
Exit For Loop
Continue For Loop
Sleep    5s

Wait Until Keyword Succeeds    10s    2s    My Keyword
Should Be Equal    ${a}    ${b}
Should Be Equal As Integers    10    10
Should Contain    Hello World    World
Should Not Be Empty    ${response}
Should Be True    ${status} == 200

Strings keywords
${msg}=    Catenate    Hello    World
${text}=    Convert To Upper Case    deepa
${text}=    Convert To Lower Case    DEEPA

Collection keywords
Library    Collections
@{list}=    Create List    apple    mango    banana
Append To List    ${list}    orange
${item}=    Get From List    ${list}    0
&{dict}=    Create Dictionary    name=Deepa    role=QA
${name}=    Get From Dictionary    ${dict}    name
Dictionary Should Contain Key    ${dict}    role

OS Keywords
Library    OperatingSystem
Create File    test.txt    Hello
File Should Exist    test.txt
Remove File    test.txt
${files}=    List Files In Directory    .

Error Handling
${status}    ${msg}=    Run Keyword And Ignore Error    Fail    Error
${status}=    Run Keyword And Return Status    Should Be Equal    1    1

Request
Library    RequestsLibrary
Create Session    mysession    https://reqres.in
${response}=    GET On Session    mysession    /api/users/2
${response}=    POST On Session    mysession    /api/users    json=${body}
Should Be Equal As Integers    ${response.status_code}    200


Wait Until Keyword Succeeds
...    1 min
...    5 sec
...    Check Service Status
TRY
    Fail    Error happened

EXCEPT
    Log    Exception handled
END

Evaluate
${sum}=    Evaluate    10 + 20
${random}=    Evaluate    random.randint(1,100)    modules=random

SeleniumLibrary + Robot Framework Cheat Sheet
1. Import Library
*** Settings ***
Library    SeleniumLibrary

2. Browser Keywords
Open Browser    https://google.com    chrome
Maximize Browser Window
Close Browser
Close All Browsers
Go To    https://example.com
Reload Page
Go Back

3. Input & Click Actions
Input Text        id=username    admin
Input Password    id=password    admin123
Click Element     xpath=//button
Click Button      Login
Click Link        Forgot Password
Clear Element Text    id=username

4. Wait Keywords (Most Important)
Wait Until Element Is Visible    id=login    10s
Wait Until Element Is Enabled    id=submit
Wait Until Page Contains         Dashboard

Wait Until Keyword Succeeds
...    1 min
...    5 sec
...    Click Element    id=retry
5. Validation Keywords
Element Should Be Visible    id=username
Page Should Contain          Welcome
Title Should Be              OrangeHRM
Should Be Equal              ${a}    ${b}
Should Contain               ${text}    success

6. Get Keywords
${text}=     Get Text     xpath=//h1
${value}=    Get Value    id=username
${title}=    Get Title

7. Dropdown / Checkbox
Select From List By Label    id=country    India
Select Checkbox              id=remember
Unselect Checkbox            id=remember
Select Radio Button          gender    male

8. Screenshot & Alerts
Capture Page Screenshot
Capture Element Screenshot    id=logo
Handle Alert
Alert Should Be Present

9. XPath Cheat Sheet
//input[@id='username']
//button[contains(text(),'Login')]
//input[starts-with(@id,'user')]

Using command line variables

python -m robot -v browser:chrome test.robot
*** Test Cases ***
Open Application
    Log To Console    ${browser}

Multiple variables
python -m robot ^
-v browser:chrome ^
-v env:QA ^
-v url:https://google.com ^
test.robot
