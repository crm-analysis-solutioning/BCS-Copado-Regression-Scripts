*** Settings ***

Documentation            EC - Airline - Case Message Reply
# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
#Resource                /Resources/common.robot
Library                 QForce
Library                 OperatingSystem
Library                 String
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Keywords ***
Login to SC BCS Homepage
    [Documentation]    login script for SC Homepage non-fsr
    Log To Console     \n\n*****Execution Steps*****
    TRY
        GoTo     ${login_sc_url}
        ${IsLoginWithEmailPage}    IsText    Log In with Email
        IF                        ${IsLoginWithEmailPage} == True
            ClickText             Log In with Username
        END
        VerifyText         Username
        TypeText    Username    ${username_sc}
        ClickText    Log In to Sandbox
        VerifyText              Password        
        TypeSecret    Password    ${password_sc}
        ClickText    Log In to Sandbox
        ${totpVerified}=          Set Variable    False
        WHILE    ${totpVerified} != True
            VerifyText    Verify Your Identity
            ${totp}=      GetOtp       ${username}    ${totp_sc}
            TypeText     Verification Code           ${totp}
            ClickElement                        xpath\=//input[@title\="Verify"]
            sleep                        2
            ${IsError}=                  IsText      Error: Invalid or expired verification code. Try again.
            IF                        ${IsError} != True
                ${totpVerified}       Set Variable    True
            END
        END
        TRY
            VerifyElement                   xpath\=//input[@value\="Acknowledge"]    30
        EXCEPT                        AS                        ${error}
            Log To Console            login acknowledgement not visible with error : ${error}
            Log                       login acknowledgement not visible with error : ${error}
        END
        ${IsAcknowledgePresent}=                   IsElement    xpath\=//input[@value\="Acknowledge"]
        IF                        ${IsAcknowledgePresent}
            VerifyText                        I acknowledge that as a Boeing Communication System (BCS) User, I will not share BCS data with unauthorized parties (vendors, suppliers, and other 3rd parties).
            ClickElement                      xpath\=//input[@value\="Acknowledge"]
        END
        VerifyText    BCS
        Log To Console     Logged in successfully
        Log                Logged in successfully
    EXCEPT    AS    ${error}
        Log         Login to BCS Block failed: ${error}
        Log To Console     Login to BCS Block failed: ${error}
        LogScreenshot      filename=error_login_failure.png    fullpage=False
        Fail               Login to BCS Block failed: ${error}
    END

Check If Tab Exist
    [Documentation]    Run the code if new tabs exist
    TRY
        ${COUNT}           GetElementCount             xpath\=//Button[contains(@title, "Close") and @class\="slds-button slds-button_icon slds-button_icon-small slds-button_icon-container"]
        IF                 ${COUNT} > 0
            Log            Closing ${COUNT} Open Tabs
            Log To Console                        Closing ${COUNT} Open Tabs
        END
        WHILE   ${COUNT} > 0
            ClickElement                               xpath\=//Button[contains(@title, "Close") and @class\="slds-button slds-button_icon slds-button_icon-small slds-button_icon-container"]
            Sleep                        1s
            ${COUNT}       GetElementCount             xpath\=//Button[contains(@title, "Close") and @class\="slds-button slds-button_icon slds-button_icon-small slds-button_icon-container"]
        END
        Log                Closed All Extra Tabs
        Log To Console     Closed All Extra Tabs
    EXCEPT    AS    ${error}
        Log         Check If Tab Exist Block failed: ${error}
        Log To Console     Check If Tab Exist Block failed: ${error}
        LogScreenshot      filename=error_close_extra_tabs_failure.png    fullpage=False
        Fail               Check If Tab Exist Block failed: ${error}
    END

Case Message Creation
    [Documentation]    Goto Case Message, Create Case message and Submit
    TRY
        ClickText    Show Navigation Menu
        ClickText    Case Messages
        VerifyText    Change Owner
        Log            Opened Case Messages Page
        Log To Console    Opened Case Messages Page
        ClickText     New
        VerifyText    Inbound or Outbound
        ClickText    xpath\=//label[@part\="input-radio" and normalize-space()\="Inbound"]
        ClickText    Next
        VerifyText    Yes
        VerifyText    *Do you want to use an existing Template
        ClickText    Yes
        ClickText    Next
        VerifyText    copado service 1 - Template
        ClickText    Select Item 1    anchor=copado service 1 - Template
        ClickText    Create New Case Message
        VerifyText                    *Due Date
        Log          Created Draft Case Message using template
        Log To Console                Created Draft Case Message using template
        
        
        VerifyText    xpath\=//div[normalize-space()\="Status"]/following-sibling::div[normalize-space()\="Draft"]
        ${element}=    GetWebElement    xpath\=//*[contains(@data-target-selection-name,'BCS_Case_Message__c.Name')]//lightning-formatted-text
        ${CaseMsgId01C}=                Call Method                        ${element}[0]   get_attribute    value
        Set Global Variable          ${CaseMsgId01C}

        Log          Created Draft Case Message using template with Id : ${CaseMsgId01C}
        Log To Console                Created Draft Case Message using template with Id : ${CaseMsgId01C}
        
        Log                        Add Date and Submit Case Message
        Log To Console             Add Date and Submit Case Message
        
        ClickText                     xpath\=//label[contains(normalize-space(),"Due Date")]/following-sibling::div/input
        VerifyText    Priority Guidelines
        ClickText    Next Month
        ClickText    Next Month
        ClickText                    22                        anchor=Selected Due Date is
        ClickText    Ok
        ClickText    Send
        UseModal    On
        VerifyText    Are you sure you want to Send this Case Message?
        ClickText    xpath\=//button[normalize-space()\="Send" and @class\="slds-button slds-button_brand"]
        UseModal    Off

        VerifyText    xpath\=//div[normalize-space()\="Status"]/following-sibling::div[normalize-space()\="Not Started"]
        ${element}=    GetWebElement    xpath\=//*[contains(@data-target-selection-name,'BCS_Case_Message__c.Name')]//lightning-formatted-text
        ${CaseMsg01C}=                Call Method                        ${element}[0]   get_attribute    value
        Set Global Variable          ${CaseMsg01C}

        Log                        Case Message Submitted : ${CaseMsg01C}
        Log To Console             Case Message Submitted : ${CaseMsg01C}

        VerifyText                   xpath\=//button[normalize-space()\="Accept"]
        ClickText                    xpath\=//button[normalize-space()\="Accept"]
        VerifyText                   You have accepted message ${CaseMsg01C} and will receive a COSP Assessment Task if needed.
        ClickText                    Next
        
        Log                        Accepted Case message : ${CaseMsg01C}
        Log To Console             Accepted Case message : ${CaseMsg01C}

        VerifyText                   xpath\=//button[normalize-space()\="Reply"]
        ClickText                    Reply
        VerifyText                   Loading
        UseModal                     On
        VerifyText                   xpath\=//button[normalize-space()\="Delete"]
        
        Log                        Reply Draft Loaded
        Log To Console             Reply Draft Loaded

        ClickText                    xpath\=//button[normalize-space()\="Select Response Type"]
        ClickText                    xpath\=(//div[@aria-label\="Response Type"]//span[normalize-space()\="Request Further Action"])[2]
        
        VerifyText                   xpath\=//label[contains(normalize-space(),"Updated Due Date")]       60
        TypeText                     xpath\=//label[contains(normalize-space(),"Hours Worked")]/following-sibling::div//input    2

        VerifyText                    xpath\=//label[contains(normalize-space(),"Due Date")]
        ClickText                     xpath\=//label[contains(normalize-space(),"Due Date")]/following-sibling::div//input       60
        ${priority_guidelines_visible}=    Run Keyword And Return Status                        VerifyElement    //lightning-layout-item[@c-bcsdatepickerwebcomponentreplysection_bcsdatepickerwebcomponentreplysection]//b[normalize-space()\="Priority Guidelines"]    timeout=3s
        IF                        ${priority_guidelines_visible} == False
            ClickElement    //label[contains(normalize-space(),"Due Date")]/following-sibling::div//input
        END
        VerifyText                    xpath\=//lightning-layout-item[@c-bcsdatepickerwebcomponentreplysection_bcsdatepickerwebcomponentreplysection]//b[normalize-space()\="Priority Guidelines"]    20
        ClickText                     xpath\=//button[normalize-space()\="Next Month"]
        ClickText                     xpath\=//button[normalize-space()\="Next Month"]
        ClickText                     xpath\=//button[normalize-space()\="Next Month"]
        ClickText                     xpath\=//ul[@c-bcsdatepickerwebcomponentreplysection_bcsdatepickerwebcomponentreplysection]//li[normalize-space()\="16"]                        anchor=Selected Updated Due Date is:
        ClickText                     xpath\=//button[normalize-space()\="Ok"]

        ClickElement   xpath\=(//button[@class\="slds-button slds-button_icon slds-button_icon-border"])[last()]
        #ClickElement                  xpath\=//label[normalize-space()="Response"]/../following-sibling::lightning-input-rich-text//lightning-formatted-rich-text[@class="slds-rich-text-editor__output"]
        ClickElement   xpath\=((//lightning-input-rich-text[@c-bcsautosaverecordformservice_bcsautosaverecordformservice])/div/div/div/div[2])[last()]
        TypeText   xpath\=((//lightning-input-rich-text[@c-bcsautosaverecordformservice_bcsautosaverecordformservice])/div/div/div/div[2]//p)[last()]                        Response text
        ClickText    xpath\=//button[normalize-space()\="Save"]
        VerifyNoText                        //lightning-spinner                        timeout=60    
        ClickText    xpath\=//button[normalize-space()\="Send"]
        VerifyText    Are you sure you want to Send this Case Message?

        ClickText     xpath\=//footer[@class\="slds-scope footerContainer slds-grid slds-grid_align-spread slds-grid_vertical-align-center slds-grow"]//button[normalize-space()\="Send"]

        VerifyText    xpath\=//div[normalize-space()\="Status"]/following-sibling::div[normalize-space()\="Customer Input Required"]
        ${element}=    GetWebElement    xpath\=//*[contains(@data-target-selection-name,'BCS_Case_Message__c.Name')]//lightning-formatted-text
        ${CaseMsg02B}=                Call Method                        ${element}[0]   get_attribute    value
        Set Global Variable          ${CaseMsg02B}
        
        Log                        Reply case message submitted : ${CaseMsg02B}
        Log To Console             Reply case message submitted : ${CaseMsg02B}
    EXCEPT    AS    ${error}
        Log         Case Message Creation Block failed: ${error}
        Log To Console     Case Message Creation Block failed: ${error}
        LogScreenshot      filename=error_create_case_message_failure.png    fullpage=False
        Fail               Case Message Creation Block failed: ${error}
    END

Login to BCS Homepage
    [Documentation]    login script for EC Homepage non-fsr
    TRY
        GoTo     ${login_url}
        VerifyText         Username    60
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
    

Search a xB case message and open it
    [Documentation]    Case message detail page should get opened
    TRY
        ClickText    Search    anchor=Boeing Communication System
        TypeText    Ask a question...    ${CaseMsg02B}
        ClickText                        xpath\=(//button[@title\="Search"])[1]
        Log            Searching ${CaseMsg02B} Case Message
        Log To Console                   Searching ${CaseMsg02B} Case Message
        VerifyText                       Search Results    60
        ${caseMsgFound}=                 IsText            1 Result    timeout=300
        IF                        ${caseMsgFound} == False
            Log                        Did Not Found ${CaseMsg02B} in fist attempt
            Log To Console             Did Not Found ${CaseMsg02B} in fist attempt
            sleep                      5
            VerifyText                   No results for \"${CaseMsg02B}\"
            RefreshPage
            VerifyText                   1 Result
        END
        ClickText                        Case Messages    anchor=1 Result
        ClickText                        xpath\=(//table[@class\="forceRecordLayout slds-table slds-table_cell-buffer slds-table_bordered uiVirtualDataGrid--default uiVirtualDataGrid"]/tbody/tr//a)[1]
        VerifyText                       Reply
        Log                        Opend ${CaseMsg02B} Case Message
        Log To Console             Opend ${CaseMsg02B} Case Message
    EXCEPT    AS    ${error}
        Log         Search a xB case message and open it Block failed: ${error}
        Log To Console     Search a xB case message and open it Block failed: ${error}
        LogScreenshot      filename=error_search_02B_failure.png    fullpage=False
        Fail               Search a xB case message and open it Block failed: ${error}
    END

Click on Reply
    [Documentation]    Response draft message detail page should get opened
    TRY 
        Log                Click on Reply
        Log To Console     Click on Reply   
        VerifyText         Reply
        ClickText          Reply
        VerifyText         xpath\=//div[normalize-space()\="Status"]/following-sibling::div[normalize-space()\="Draft"]    60
    EXCEPT    AS    ${error}
        Log         Click on Reply Block failed: ${error}
        Log To Console     Click on Reply Block failed: ${error}
        LogScreenshot      filename=error_search_02B_failure.png    fullpage=False
        Fail               Click on Reply Block failed: ${error}
    END

Enter all mandatory fields and click on Submit
    [Documentation]    xC case message should get created successfully #and number of this case message should be one more than of xB case message. For eg - if xB msg is 2B then xC message is 3C
    TRY
        Log            Enter all mandatory fields and click on Submit
        Log To Console    Enter all mandatory fields and click on Submit
        ClickText    xpath\=(//Label[normalize-space(text())\="Due Date"]/following-sibling::div//input[@class\="slds-input"])[last()]
        ClickText    Next Month
        ClickText    24
        ClickText    xpath\=(//button[@class\="slds-button slds-button_brand"])
        ClickElement    xpath\=(//button[@class\="slds-button slds-button_icon slds-button_icon-border"])[1]
        ClickElement    xpath\=(//lightning-input-rich-text[@class\="slds-form-element"])[2]/div/div/div
        TypeText        xpath\=(//lightning-input-rich-text[@class\="slds-form-element"])[2]/div/div/div/div[2]/div/p    RESPONSE FOR REPLY MESSAGE
        ClickText       Save
        VerifyNoElement                        lightning-spinner                        60
        ClickText       Submit
        VerifyText      has been created
        Log             Reply Case Message Submitted
        Log To Console                        Reply Case Message Submitted
        
        ${SubmitString}=    GetWebElement    xpath\=//div[contains(normalize-space(),"has been created")]/div[2]
        ${ReplyString}=     Call Method      ${SubmitString}[0]    get_attribute    innerHTML
        ${value}=           Evaluate         """${ReplyString}""".replace('\\n', ' ').split('Reply ')[1].split(' has')[0].strip()
        Set Global Variable                  ${bmn}                ${value}
        
        Log                        Reply BMN : ${bmn}
        Log To Console             Reply BMN : ${bmn}
        
        ${is_valid_sequence}=           Evaluate                   """${CaseMsg02B}""".split('-')[:-1] == """${bmn}""".split('-')[:-1] and """${CaseMsg02B}""".endswith('02B') and """${bmn}""".endswith('03C')

        IF    ${is_valid_sequence}
            Log to Console    Validation Successful: 02B correctly progressed to 03C
            Log               Validation Successful: 02B correctly progressed to 03C
        ELSE
            Log               Validation Failed! suffixes are not sequentially 02B -> 03C.
            Log To Console    Validation Failed! suffixes are not sequentially 02B -> 03C.
            Fail              Validation Failed! suffixes are not sequentially 02B -> 03C.
        END
    EXCEPT    AS    ${error}
        Log         Enter all mandatory fields and click on Submit Block failed: ${error}
        Log To Console     Enter all mandatory fields and click on Submit Block failed: ${error}
        LogScreenshot      filename=error_enter_all_mandatory_fields_and_submit_failure.png    fullpage=False
        Fail               Enter all mandatory fields and click on Submit Block failed: ${error}
    END
    
Validate the status of xC message created
    [Documentation]    Case message status should be Not Started
    TRY
        Log            Validate the status of xC message created
        Log To Console    Validate the status of xC message created
        TypeText                        Ask a question...          ${bmn}   
        sleep       5s
        ClickElement                    xpath\=//button[@title\="Search"]
        VerifyText                      Search Results
        ClickElement                    xpath\=//a[normalize-space()\="${bmn}"] 
        VerifyText                      xpath\=//*[normalize-space()\='Status']/following::*[normalize-space()\='Not Started']
        Log                        Validated : Status is Not Started
        Log To Console             Validated : Status is Not Started
    EXCEPT    AS    ${error}
        Log         Validate the status of xC message created Block failed: ${error}
        Log To Console     Validate the status of xC message created Block failed: ${error}
        LogScreenshot      filename=error_case_message_status_validation_failure.png    fullpage=False
        Fail               Validate the status of xC message created Block failed: ${error}
    END

# Click on Create A Case button
#     [Documentation]    "Contact Customer Support" page should get displayed with following fields: Subject, Description, Desired Action, Service Category (Mandatory)
#     VerifyText         Boeing Communication System
#     ClickText          Create A Case
#     VerifyText         Contact Customer Support
#     VerifyText         Subject
#     VerifyText         Description
#     VerifyText         Desired Action
#     VerifyText         Service Category

# Click on Next button without entering any data
#     [Documentation]    "Service Category" field should get highlighted with message "Complete this field"
#     VerifyNoElement    xpath\=//button[@aria-invalid\="true"]
#     ClickText          Next
#     VerifyElement      xpath\=//button[@aria-invalid\="true"]
#     VerifyText         Complete this field

# Enter any data in subject field
#     [Documentation]    Related suggestions should get populated on screen at right side when subject is entered
#     TypeText           Subject    Subject- This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
#     sleep              1
#     VerifyElement      xpath\=(//div[@class\="slds-grid_vertical slds-wrap slds-has-block-links caseDeflectionList"]//ul//a/following-sibling::ul//li)[1]
   
# Enter all required details and then click on Next button  
#     [Documentation]    New Draft Case message detail page should get displayed
#     TypeText           xpath\=(//div[@class\="ql-editor ql-blank slds-rich-text-area__content slds-grow slds-g-color-neutral-base-10"])/p  This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
#     TypeText           xpath\=((//LIGHTNING-INPUT-RICH-TEXT[@class\="slds-form-element"][2]/div/div/div/div[2]/div/p))  This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
#     PickList           *Service Category    Airplane Repair
#     ClickText          Complete this field 
#     sleep              2
#     ClickText          Next
#     VerifyElement      xpath\=//label[normalize-space()\="*Due Date"]
    
# Enter all required details in each tab
#     [Documentation]    Add Date and Airplane details
#     VerifyText                   Do not put ITAR data in BCS as BCS is not authorized to contain ITAR data

#     ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
#     ${html_content}=                Call Method                        ${element}[0]   get_attribute    innerHTML
#     Set Global Variable          ${html_content}

#     ClickText    xpath\=(//Label[normalize-space(text())\="Due Date"]/following-sibling::div//input[@class\="slds-input"])[last()]
#     ClickText    Next Month
#     ClickText    12
#     ClickText    xpath\=(//button[@class\="slds-button slds-button_brand"])
    
#     ClickText    Add Airplanes
#     ClickCheckbox                Select Item 2                        on               partial_match=False
#     ClickText                    Edit Cycles
#     TypeText                     Cycles                        3
#     ClickText                    Edit Hours
#     TypeText                     Hours                        6
#     ClickText                    Add                        partial_match=False
#     ComboBox                     Search ATA Codes...        1000
#     PickList                     Repair Approval            No
#     ClickText                    Add Parts
#     TypeText                     *Part Number               121
#     TypeText                     Serial Number              231
#     ClickText                    Save

# Add files and references
#     [Documentation]    Add files and references
#     ClickText                    2 - Message Details  
#     ClickText                    New
#     TypeText                     *Title                     First Reference
#     ClickText                    Save
#     ClickText                    New
#     TypeText                     *Title                     second reference
#     ClickText                    Save
    
#     Create File    ${OUTPUT DIR}/sample.txt   	Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!
#     ClickText      Upload Files
#     Upload File    xpath\=//input[@type\="file"]    ${OUTPUT DIR}/sample.txt
#     VerifyText     1 of 1 file uploaded             60
#     sleep          3
#     ClickText      Done
#     VerifyText     Files (1)                        60

#     ClickText    3 - Contacts
#     VerifyText    Add Contacts
#     ClickText    4 - Additional Details
#     VerifyText       Airplane Location
#     ClickText    5 - Overview
#     VerifyText       Inquiry Additional Details
   
# Submit the Case Message Wait and Refresh Homepage
#     [Documentation]  Submit the Case Message Wait and Refresh Homepage
#     ClickText    Submit
#     VerifyText    Multi Operator Messages
#     sleep   5s
#     RefreshPage

# Search above created message and open it
#     [Documentation]    Search and open above case message and store the BMN number to variable
#     VerifyText       Boeing Communication System
#     ClickElement     xpath\=(//lightning-formatted-url//a[contains(@title,${html_content})])[1]
#     SwitchWindow     NEW
#     SwitchWindow     2
#     VerifyText       Request

#     ${element}=    GetWebElement                   xpath\=(//h1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
#     ${bmn}=                Call Method                        ${element}[0]   get_attribute    innerHTML
#     ${bmn_value}=     Evaluate                          """${bmn[:-4]}"""
#     Set Global Variable                        ${html_content}                     ${bmn_value}    