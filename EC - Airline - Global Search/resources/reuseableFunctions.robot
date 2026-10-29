*** Settings ***

Documentation           New test suite
# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
#Resource                /Resources/common.robot
Library                 QForce
Library                 OperatingSystem
Library                 QWeb
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Variables ***
${caseMsgBMN}            AIN-AIN-26-1232-01C
${caseMsg}               AIN-AIN-26-1232
${SupersededMsg}         TBC-TBC-26-0001-01C(R1)

*** Keywords ***
Login to BCS Homepage
    [Documentation]    Login - Home Page should get displayed successfully 
    TRY
        Log To Console     \n\n*****Execution Steps*****
        #Log                *****Execution Steps*****
        GoTo               ${login_url}
        TypeText           Username    ${username}
        TypeSecret         Password    ${password}
        ClickText          Log In to Sandbox
        VerifyText         Boeing Communication System    60
        Log To Console     Logged in successfully
        Log                Logged in successfully
    EXCEPT    AS    ${error}
        Log         Login to BCS Homepage Block failed: ${error}
        Log To Console     Login to BCS Homepage Block failed: ${error}
        LogScreenshot      filename=error_login_failure.png    fullpage=False
        Fail               Login to BCS Homepage Block failed: ${error}
    END
  
Search CASEMSG1_CASE1 by entering Message number and BMN respectively in global search
    [Documentation]    System should display the searched case messages/Case in search result
    TRY
        #Search Case Message
        VerifyText    Boeing Communication System
        TypeText    Ask a question...    ${caseMsgBMN}
        ClickElement   xpath\=//button[@title\="Search"]
        Log            Searching case message BMN : ${caseMsgBMN}
        Log To Console                   Searching case message BMN : ${caseMsgBMN}
        ClickText    Case Messages    anchor=1 Result
        VerifyText                    ${caseMsgBMN}
        Log                        Validated : Case Message ${caseMsgBMN} Found using Global Search
        Log To Console             Validated : Case Message ${caseMsgBMN} Found using Global Search

        #Search Case
        Log                        Redirecting to Home Page
        Log To Console             Redirecting to Home Page
        ClickText    Home    partial_match=False
        VerifyText    Boeing Communication System    60
        TypeText    Ask a question...    ${caseMsg}
        ClickElement   xpath\=//button[@title\="Search"]
        Log            Searching case message BMN : ${caseMsg}
        Log To Console                   Searching case message BMN : ${caseMsg}
        ClickText    Case    anchor=1 Result
        VerifyText                    ${caseMsg}
        Log                        Validated : Case Message ${caseMsg} Found using Global Search
        Log To Console             Validated : Case Message ${caseMsg} Found using Global Search
    EXCEPT    AS    ${error}
        Log         Search CASEMSG1_CASE1 by entering Message number and BMN respectively in global search Block failed: ${error}
        Log To Console     Search CASEMSG1_CASE1 by entering Message number and BMN respectively in global search Block failed: ${error}
        LogScreenshot      filename=error_Search_CASEMSG1_and_CASE1_failure.png    fullpage=False
        Fail               Search CASEMSG1_CASE1 by entering Message number and BMN respectively in global search Block failed: ${error}
    END

Search COOR1_RESP1 in global search
    [Documentation]    System should not display the searched Coordination /Response to Coordination message to user
    TRY
        #Search COOR1
        Log                        Redirecting to Home Page
        Log To Console             Redirecting to Home Page
        ClickText    Home    partial_match=False
        VerifyText    Boeing Communication System
        TypeText    Ask a question...    -COOR1
        ClickElement   xpath\=//button[@title\="Search"]
        Log            Searching Coordination message
        Log To Console                   Searching Coordination message
        
        VerifyText    No results for "COOR1"
        Log           Verified Result : No results for "COOR1"
        Log To Console                   Verified Result : No results for "COOR1"

        #Search RESP1
        Log                        Redirecting to Home Page
        Log To Console             Redirecting to Home Page
        ClickText    Home    partial_match=False
        VerifyText    Boeing Communication System    60
        TypeText    Ask a question...    RESP1
        ClickElement   xpath\=//button[@title\="Search"]
        Log            Searching Response to Coordination message
        Log To Console                   Searching Response to Coordination message
        VerifyText    No results for "RESP1"
        Log           Verified Result : No results for "RESP1"
        Log To Console                   Verified Result : No results for "RESP1"
    EXCEPT    AS    ${error}
        Log         Search COOR1_RESP1 in global search Block failed: ${error}
        Log To Console     Search COOR1_RESP1 in global search Block failed: ${error}
        LogScreenshot      filename=error_Search_COOR1_and_RESP1_failure.png    fullpage=False
        Fail               Search COOR1_RESP1 in global search Block failed: ${error}
    END

Search SUP_CASEMSG1
    [Documentation]    System should not display the searched superseded case message to user, instead of it , its revised version if active should be visible
    TRY
        # Log                        Redirecting to Home Page
        # Log To Console             Redirecting to Home Page
        # ClickText    Home    partial_match=False
        # VerifyText    Boeing Communication System
        TypeText    Search...    ${SupersededMsg}
        ClickElement   xpath\=//button[@title\="Search"]
        ClickText      Case Message
        #TypeText       xpath\=//div[@data-aura-class\="forceSearchFilterInput forceSearchFilterInputText"]//label[normalize-space()\="Message Number"]/following-sibling::input    ${SupersededMsg}
        #ClickText      Apply filter
        Log            Searching superseded case message
        Log To Console                   Searching superseded case message
       #ClickText    Case Messages    anchor=1 Result
        VerifyText                       No results for \"${SupersededMsg}\" in Case Messages
        Log           Verified Result : No results for \"${SupersededMsg}\" in Case Messages
        Log To Console                   Verified Result : No results for \"${SupersededMsg}\" in Case Messages
       #VerifyText                    ${SupersededMsg}
       #ClickText    xpath\=//a[@data-refid\="recordId"][1]
       #VerifyText    xpath\=//lightning-output-field[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="Sub-Type"]/following-sibling::div//lightning-formatted-text[normalize-space()\="Revision"]
    EXCEPT    AS    ${error}
        Log         Search SUP_CASEMSG1 Block failed: ${error}
        Log To Console     Search SUP_CASEMSG1 Block failed: ${error}
        LogScreenshot      filename=error_Search_SUP_CASEMSG1_failure.png    fullpage=False
        Fail               Search SUP_CASEMSG1 Block failed: ${error}
    END