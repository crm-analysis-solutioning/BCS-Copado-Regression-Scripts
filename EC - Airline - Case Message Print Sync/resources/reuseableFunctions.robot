*** Settings ***
Documentation           Test Case created using the QEditor
# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
#Resource                /Resources/common.robot
Library                 QForce
Library                 OperatingSystem
#Library                 QWeb
#Suite Setup             Open Browser    about:blank    chrome
#Suite Teardown          Close All Browsers
Library                 BuiltIn
Library                 Screenshot
    
*** Keywords ***
Login to BCS Homepage
    [Documentation]    login script for EC Homepage non-fsr
    TRY
        Log To Console     \n\n*****Execution Steps*****
        #Log                *****Execution Steps*****
        Log                Login to BCS Homepage
        GoTo     ${login_url}
        VerifyText         Username
        TypeText    Username    ${username}
        TypeSecret    Password    ${password}
        ClickText    Log In to Sandbox
        
        Log To Console     Logged in successfully
        Log                Logged in successfully
        VerifyText         Boeing Communication System
    EXCEPT    AS    ${error}
        Log         Login to BCS Homepage Block failed: ${error}
        Log To Console     Login to BCS Homepage Block failed: ${error}
        LogScreenshot      filename=error_login_failure.png    fullpage=False
        Fail               Login to BCS Homepage Block failed: ${error}
    END

On Case message detail page, Click on Print button
    [Documentation]    Print popup should get displayed
    TRY
        Log            On Case message detail page, Click on Print button
        Log To Console    On Case message detail page, Click on Print button
        VerifyText    xpath\=(//lightning-primitive-cell-factory[@data-label\="Message #"]//a)[1]    60
        ClickText     xpath\=(//lightning-primitive-cell-factory[@data-label\="Message #"]//a)[1]
        Log           Open Case Message
        Log To Console                        Open Case Message
        SwitchWindow              2
        VerifyText                Message Number
        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${BMN}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${BMN}
        Log                        Opened Case message : ${BMN}
        Log To Console             Opened Case message : ${BMN}
        VerifyText                   xpath\=//Button[@title\="Forward"]
        ClickText                    Print
        VerifyText                   Print Record
        Log                        Print popup Displayed
        Log To Console             Print popup Displayed
    EXCEPT    AS    ${error}
        Log         On Case message detail page, Click on Print button Block failed: ${error}
        Log To Console             On Case message detail page, Click on Print button Block failed: ${error}
        LogScreenshot      filename=error_case_message_detail_page.png    fullpage=False
        Fail               On Case message detail page, Click on Print button Block failed: ${error}
    END
    
Select any option from print popup and click on Print button
    [Documentation]    Selected documents should get printed successfully
    TRY
        Log                Select any option from print popup and click on Print button
        Log To Console     Select any option from print popup and click on Print button
        ClickText          Message(s)
        ClickText          Print    anchor=Cancel
        SwitchWindow          3
        sleep                 5
        SetConfig             VerifyAppAccuracy    0.99
        VerifyApp             ./images/boeing.png
        VerifyApp             ./images/clickAbless.png
        Log                   Print Operation Completed
        Log To Console        Print Operation Completed
        ${full_screeshot_01C}=    LogScreenshot    filename=sync_print_${BMN}.png    fullpage=True
        Log To Console             Screenshot saved : ${full_screeshot_01C}
    EXCEPT    AS    ${error}
        Log         Select any option from print popup and click on Print button Block failed: ${error}
        Log To Console             Select any option from print popup and click on Print button Block failed: ${error}
        LogScreenshot      filename=error_init_print.png    fullpage=False
        Fail               Select any option from print popup and click on Print button Block failed: ${error}
    END
           
                
    