*** Settings ***
Documentation           Test Case created using the QEditor
# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
#Resource                /Resources/common.robot
Library                 QForce
Library                 OperatingSystem
Library                 QWeb
Library                 String
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers
Library                 BuiltIn

*** Keywords ***
Login to BCS Homepage
    [Documentation]    login script for EC Homepage non-fsr
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

Search a x01C case message
    [Documentation]    Search and open a x01C case message
    TRY
        VerifyText         Communication
        VerifyText         Boeing Communication System
        TypeText           Ask a question...    01C
        ClickElement       xpath\=//button[@title\="Search"]
        Log                Searching x01C case message
        LogTo Console      Searching x01C case message
        ClickText          Case Messages        anchor=5+ Results
        ClickText          xpath\=//a[@data-refid\="recordId"][1]
        VerifyElement      xpath\=//button[@title\="Forward"]
        
        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${CaseMsgBMN}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${CaseMsgBMN}

        Log to Console               Opened Case Message BMN : ${CaseMsgBMN}
        Log                        Opened Case Message BMN : ${CaseMsgBMN}

    EXCEPT    AS    ${error}
        Log         Search a x01C case message Block failed: ${error}
        Log To Console     Search a x01C case message Block failed: ${error}
        LogScreenshot      filename=error_search_x01C_failure.png    fullpage=False
        Fail               Search a x01C case message Block failed: ${error}
    END

Click on forward button present on case message detail page
    [Documentation]    Forward popup should get opened
    TRY
        Log To Console    Click On Forward Button
        Log               Click On Forward Button
        ClickElement       xpath\=//button[@title\="Forward"]
        VerifyElement      xpath\=//H2[normalize-space()\="Forward"]
        Log To Console    Forward Wizard Opened
        Log               Forward Wizard Opened
    EXCEPT    AS    ${error}
        Log         Click on forward button present on case message detail page Block failed: ${error}
        Log To Console     Click on forward button present on case message detail page Block failed: ${error}
        LogScreenshot      filename=error_Click_on_Forward_Button_failure.png    fullpage=False
        Fail               Click on forward button present on case message detail page Block failed: ${error}
    END

Search any contact by using email address and then select the required contact and click on Next
    [Documentation]    Message should appear "Case Message forwarded to &user&" where user is selected user
    TRY
        Log            Searching Contact to forward case
        Log To Console    Searching Contact to forward case
        TypeText           search by contact's email...    donotdelete.copadotestuser@boeing.com
        ClickText          Search                        anchor=Airplane In Transition
        ClickElement       xpath\=//th[normalize-space()\="Copado"]/..//td//input[@type\="checkbox"]
        ClickElement       xpath\=//flowruntime-navigation-bar//button[normalize-space()\="Next"]
        VerifyText         Case Message forwarded to Copado user 1
        Log                Case Message forwarded to Copado user 1
        Log To Console     Case Message forwarded to Copado user 1
    EXCEPT    AS    ${error}
        Log         Search any contact by using email address and then select the required contact and click on Next Block failed: ${error}
        Log To Console     Search any contact by using email address and then select the required contact and click on Next Block failed: ${error}
        LogScreenshot      filename=error_Select_Contact_to_Forward_failure.png    fullpage=False
        Fail               Search any contact by using email address and then select the required contact and click on Next Block failed: ${error}
    END

Click on Finish
    [Documentation]    Popup should get closed
    TRY
        VerifyElement      xpath\=//H2[normalize-space()\="Forward"]
        ClickText          Finish
        VerifyNoElement    xpath\=//H2[normalize-space()\="Forward"]
    EXCEPT    AS    ${error}
        Log         Click on Finish Block failed: ${error}
        Log To Console     Click on Finish Block failed: ${error}
        LogScreenshot      filename=error_close_forward_wizard_failure.png    fullpage=False
        Fail               Click on Finish Block failed: ${error}
    END

#Check mail of the user to which case message has been forwarded
#    [Documentation]    User should receive an email notification and email should contain forward comments and original message. All the contacts added in case message should also receive same email as CC