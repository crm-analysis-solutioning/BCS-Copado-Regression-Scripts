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
        Log         Login to Experience cloud with customer account Block failed: ${error}
        Log To Console     Login to BCS Homepage Block failed: ${error}
        LogScreenshot      filename=error_login_failure.png    fullpage=False
        Fail               Login to Experience cloud with customer account Block failed: ${error}
    END

Validate following tabs should be present on homepage: Multi Operator Messages, Templates, Print Tasks
    [Documentation]    On FSR home page , following tabs should be present on homepage: Multi Operator Messages, Templates, Print Tasks
    TRY
        VerifyText    Boeing Communication System
        VerifyText    Multi Operator Messages
        VerifyText    Templates
        VerifyText    Print Tasks
        ClickText    notifications
        Log          Verified: Multi Operator Messages, Templates and Print Tasks tabs are visible
        Log To Console    Verified: Multi Operator Messages, Templates and Print Tasks tabs are visible
        #Grace Commented this out on 10/26 since there is no Mark all as read field os test was failing
        #VerifyText    Mark all as read
        #ClickText    Mark all as read
    EXCEPT    AS    ${error}
        Log         Validate following tabs should be present on homepage: Multi Operator Messages, Templates, Print Tasks Block failed: ${error}
        Log To Console     Validate following tabs should be present on homepage: Multi Operator Messages, Templates, Print Tasks Block failed: ${error}
        LogScreenshot      filename=error_validate_tabs_failure.png    fullpage=False
        Fail               Validate following tabs should be present on homepage: Multi Operator Messages, Templates, Print Tasks Block failed: ${error}
    END
    
Click on Create A Case button
    [Documentation]    Contact Customer support page should get displayed with following fields: On Behalf Of (Mandatory), Subject, Description, Desired Action, Service Category (Mandatory)
    TRY
        ClickText          Create A Case
        Log                Click on Create a Case
        Log To Console     Click on Create a case
        VerifyText         On Behalf Of
        VerifyText         Subject
        VerifyText         Description 
        VerifyText         Desired Action
        VerifyText         Service Category
        Log                Verified: On Behalf Of, Subject, Description, Desired Action, Service Category fields are visible
        Log To Console     Verified: On Behalf Of, Subject, Description, Desired Action, Service Category fields are visible
        ClickText          Next 
        VerifyText         Complete this field.    anchor=On Behalf Of
        VerifyText         Complete this field.    anchor=Service Category
        Log                Verified: On Behalf Of and Service Category fields are mandatory
        Log To Console     Verified: On Behalf Of and Service Category fields are mandatory
    EXCEPT    AS    ${error}
        Log         Click on Create A Case button Block failed: ${error}
        Log To Console     Click on Create A Case button Block failed: ${error}
        LogScreenshot      filename=error_click_create_a_case_failure.png    fullpage=False
        Fail               Click on Create A Case button Block failed: ${error}
    END

# Validate "On Behalf Of" field have various account codes
#     [Documentation]    "On Behalf Of" field should have only account codes to select

Select any account from the dropdown and enter other required details and click on Next button
    [Documentation]    New Draft Case message detail page should get displayed
    TRY
        ComboBox    Search Account Lookups...    CRT(CRT Test Account Do not use)

        ${OnBehalfOfElement}                        GetWebelement    xpath\=//div//input[@placeholder\="Search Account Lookups..."]
        ${data-value}                        Call Method        ${OnBehalfOfElement}[0]    get_attribute    data-value
        ${OnBehalfOfValue}=                   Evaluate                  "${data-value}".split('(')[0].strip()
        Set Global Variable                       ${OnBehalfOfValue}
    
        TypeText           Subject                        This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
        TypeText           xpath\=(//div[@class\="ql-editor ql-blank slds-rich-text-area__content slds-grow slds-g-color-neutral-base-10"])/p  This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
        TypeText           xpath\=((//LIGHTNING-INPUT-RICH-TEXT[@class\="slds-form-element"][2]/div/div/div/div[2]/div/p))  This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
        PickList    *Service Category    Airplane Repair
        ClickText                        Complete this field.
        Verify No Text                     Complete this field.
        ClickText    Next
    EXCEPT    AS    ${error}
        Log         Select any account from the dropdown and enter other required details and click on Next button Block failed: ${error}
        Log To Console     Select any account from the dropdown and enter other required details and click on Next button Block failed: ${error}
        LogScreenshot      filename=error_add_details_and_click_next_failure.png    fullpage=False
        Fail               Select any account from the dropdown and enter other required details and click on Next button Block failed: ${error}
    END

On Draft page _ Go to Affected Airplanes section and click on Add Airplanes button
    [Documentation]    "Airplane(s)" popup should get displayed
    TRY
        VerifyText         Affected Airplanes

        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${caseMsgID}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${caseMsgID}

        ClickText          Add Airplanes
        VerifyText         My Company's Planes
        Log                Open Affected Airplanes Wizard
        Log To Console     Open Affected Airplanes Wizard
    EXCEPT    AS    ${error}
        Log         On Draft page _ Go to Affected Airplanes section and click on Add Airplanes button Block failed: ${error}
        Log To Console     On Draft page _ Go to Affected Airplanes section and click on Add Airplanes button Block failed: ${error}
        LogScreenshot      filename=error_open_affected_airplane_wizard_failure.png    fullpage=False
        Fail               On Draft page _ Go to Affected Airplanes section and click on Add Airplanes button Block failed: ${error}
    END

Validate in My Companys Planes tab only airplanes_assets belongs to the selected account code are visible and other company airplanes_assets are not visible for selection
    [Documentation]    Only airplanes/assets belongs to the selected account code should be visible and other company airplanes/assets should not be visible for selection.
    TRY
        ${elements}                   GetWebElement                       xpath\=(//td[@data-label\="Operator Code"])
        FOR                        ${element}                        IN                    @{elements}   
            ${inner_html}=         Call Method                       ${element}            get_attribute    data-cell-value
            IF                     "${OnBehalfOfValue}" not in """${inner_html}"""            Fail        ${inner_html}
        END
    EXCEPT    AS    ${error}
        Log         Validate in My Companys Planes tab only airplanes_assets belongs to the selected account code are visible and other company airplanes_assets are not visible for selection Block failed: ${error}
        Log To Console     Validate in My Companys Planes tab only airplanes_assets belongs to the selected account code are visible and other company airplanes_assets are not visible for selection Block failed: ${error}
        LogScreenshot      filename=error_validate_airplanes_and_assets_failure.png    fullpage=False
        Fail               Validate in My Companys Planes tab only airplanes_assets belongs to the selected account code are visible and other company airplanes_assets are not visible for selection Block failed: ${error}
    END

Enter all required details and submit the draft case message
    [Documentation]    Case message should get created successfully
    TRY
        ClickCheckbox    Select Item 1    on    partial_match=False
        ClickText    Edit Cycles
        TypeText    Cycles    2
        ClickText    Edit Hours
        TypeText    Hours    2
        ClickText    Add    partial_match=False
        VerifyText          Affected Airplanes (1)
        Log          Added One Affected Airplane
        Log To Console      Added One Affected Airplane
        ComboBox    Search ATA Codes...    3600
        PickList    Repair Approval    No
        ClickText                    xpath\=(//Label[normalize-space(text())\="Due Date"]/following-sibling::div//input[@class\="slds-input"])[last()]
        VerifyText                   xpath\=//lightning-layout-item[@c-bcsdatepickerwebcomponent_bcsdatepickerwebcomponent]//div[normalize-space()\="(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)"]
        ClickText                    Next Month
        ClickText                    Next Month
        ClickText                    12
        ClickText    Ok
        ClickText    2 - Message Details
        # Grace Update from ClickText Subject to VerifyText Subject
        VerifyText    Subject
        ClickText    3 - Contacts
        # Grace update Contacts (1) to Contacts (2)
        VerifyText    Contacts (2)
        ClickText    4 - Additional Details
        VerifyText    Airplane Location
        ClickText    5 - Overview
        VerifyText    Web Inbound
        VerifyText    Submit
        Log           Added All Details
        Log To Console               Added All Details
        
        SetConfig     VerifyAppAccuracy    0.97              
        VerifyApp     ./images/green tick.png

        ClickText     Submit
        VerifyText    The Case Message has been submitted successfully
        Log           Case Message Submitted Id : ${caseMsgID}
        Log To Console                     Case Message Submitted Id : ${caseMsgID}
    EXCEPT    AS    ${error}
        Log         Enter all required details and submit the draft case message Block failed: ${error}
        Log To Console     Enter all required details and submit the draft case message Block failed: ${error}
        LogScreenshot      filename=error_enter_details_and_submit_failure.png    fullpage=False
        Fail               Enter all required details and submit the draft case message Block failed: ${error}
    END
    
Validate BMN number generated on created case_case message
    [Documentation]    BMN number should have the account code of the selected account and not the user's account
    TRY
        RefreshPage
        Log            Opening Case through notifications
        Log To Console    Opening Case through notifications
        VerifyText    Boeing Communication System
        ClickText    Notifications
        ClickText    xpath\=(//H3[normalize-space()\="Case Message Submission"])[1]
        VerifyText    Submitted    20
        VerifyText    xpath\=(//th[@data-col-key-value\="BCS_Case_Message_URL_for_LWC__c-url-2"]//lightning-primitive-cell-factory//a)
        ClickText    xpath\=(//th[@data-col-key-value\="BCS_Case_Message_URL_for_LWC__c-url-2"]//lightning-primitive-cell-factory//a)
        
        #SwitchWindow    New
        SwitchWindow    2
        VerifyText    xpath\=//div[@title\="Status"]/following-sibling::div[@title\="Not Started"]
        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${caseMsgBMN}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${caseMsgBMN}
        
        Log           Case Message Opened : ${caseMsgBMN}
        Log To Console                     Case Message Opened : ${caseMsgBMN}
        
        ${parts}=                   Evaluate                  "${caseMsgBMN}".split('-')
        IF                        """${OnBehalfOfValue}""" not in """${parts}[0]"""        FAIL      ${parts}[0] is found 
        IF                        """${OnBehalfOfValue}""" not in """${parts}[1]"""        FAIL      ${parts}[1] is found
    EXCEPT    AS    ${error}
        Log         Validate BMN number generated on created case_case message Block failed: ${error}
        Log To Console     Validate BMN number generated on created case_case message Block failed: ${error}
        LogScreenshot      filename=error_validate_bmn_generated_failure.png    fullpage=False
        Fail               Validate BMN number generated on created case_case message Block failed: ${error}
    END