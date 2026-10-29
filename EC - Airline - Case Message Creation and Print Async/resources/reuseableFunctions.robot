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

*** Variables ***
#Regression testing
# ${Sample3}            sample3.txt
# ${CAP}                CAP- Test Image.jpeg
# ${CopadoTestAppIcon}    CopadoTestAppIcon.png
# ${lorem_ipsum_3kb}    lorem_ipsum_3kb.pdf

#live testing
# ${Sample3}            ../resources/files/sample3.txt
# ${CAP}                ../resources/files/CAP- Test Image.jpeg
# ${CopadoTestAppIcon}    ../resources/files/CopadoTestAppIcon.png
# ${lorem_ipsum_3kb}    ../resources/files/lorem_ipsum_3kb.pdf

*** Keywords ***
Login to Experience cloud with customer account
    [Documentation]    Login successful / User directed to homepage
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

    
Navigate to homepage and create new case message
    [Documentation]    Initial service request page displays
    TRY
        VerifyText         Boeing Communication System
        ClickText          Create A Case
        Log                Clicked on Create a Case
        Log To Console     Clicked on Create a Case
        VerifyText         Contact Customer Support    60
        Log To Console     Contact Customer Support fields are visible
        Log                Contact Customer Support fields are visible
    EXCEPT    AS    ${error}
        Log         Navigate to homepage and create new case message Block failed: ${error}
        Log To Console     Navigate to homepage and create new case message Block failed: ${error}
        LogScreenshot      filename=error_click_Create_A_Case_failure.png    fullpage=False
        Fail               Navigate to homepage and create new case message Block failed: ${error}
    END

Populate Subject, Description, Desired Action and Service Category fields and click next button
    [Documentation]    Case message draft page displays
    TRY
        Log            Populate Subject, Description, Desired Action and Service Category fields
        Log To Console    Populate Subject, Description, Desired Action and Service Category fields
        TypeText           Subject    Subject- This Case Message is being sent for testing purposes.
        TypeText           xpath\=(//div[@class\="ql-editor ql-blank slds-rich-text-area__content slds-grow slds-g-color-neutral-base-10"])/p  This Case Message is being sent for testing purposes - description.
        TypeText           xpath\=((//LIGHTNING-INPUT-RICH-TEXT[@class\="slds-form-element"][2]/div/div/div/div[2]/div/p))  This Case Message is being sent for testing purposes - desiredAction.
        PickList           *Service Category    Airplane Repair
        Log                Click on Next
        Log To Console     Click on Next
        ClickText          Next
        VerifyElement      xpath\=//label[normalize-space()\="*Due Date"]
        Log To Console     New Draft Case message detail page Loaded
        Log                New Draft Case message detail page Loaded
    EXCEPT    AS    ${error}
        Log         Navigate to homepage and create new case message Block failed: ${error}
        Log To Console     Populate Subject, Description, Desired Action and Service Category fields and click next button Block failed: ${error}
        LogScreenshot      filename=error_add_subject_description_desired_action_and_service_category_field_failure.png    fullpage=False
        Fail               Populate Subject, Description, Desired Action and Service Category fields and click next button Block failed: ${error}
    END

Populate all required fields and add files of various supported formats and references and submit the case message
    [Documentation]    BMN should get generated for case message
    TRY
        VerifyText         Do not put ITAR data in BCS as BCS is not authorized to contain ITAR data    60
        Log                Started Adding Date and Airplane details
        Log To Console     Started Adding Date and Airplane details
        
        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${caseMsgId}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${caseMsgId}

        ClickText                    xpath\=(//Label[normalize-space(text())\="Due Date"]/following-sibling::div//input[@class\="slds-input"])[last()]
        VerifyText                   xpath\=//lightning-layout-item[@c-bcsdatepickerwebcomponent_bcsdatepickerwebcomponent]//div[normalize-space()\="(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)"]
        ClickText                    Next Month
        ClickText                    Next Month
        ClickText                    12                        anchor=Selected Due Date is
        ClickText                    xpath\=(//button[@class\="slds-button slds-button_brand"])
    
        ClickText                    Add Airplanes
    
        ClickText                    Global Airplane Search
        TypeText                     search by keyword...    12345DoNotDelete
        ClickCheckbox                Select Item 1                        on               partial_match=False
        ClickText                    Edit Cycles
        TypeText                     Cycles                        3
        ClickText                    Edit Hours
        TypeText                     Hours                        6
        ClickText                    Add      partial_match=False
        ComboBox                     Search ATA Codes...           1000
        PickList                     Repair Approval        No
        ClickText                    Add Parts
        TypeText                     *Part Number       121
        TypeText                     Serial Number      231
        ClickText                    Save
        Log To Console               Added Date and Airplane details in Case Detail Page
        Log                        Added Date and Airplane details in Case Detail Page

        Click Text                 2 - Message Details 
        Log                        Clicked On 2 - Message Details
        Log To Console             Clicked On 2 - Message Details
        ClickText                  Upload Files
        UseModal                   On
        # Upload File                xpath\=//input[@type\="file"]          ../resources/files/sample3.txt    ${Sample3}
        Upload File                xpath\=//input[@type\="file"]          ${CURDIR}/../resources/files/sample3.txt
        VerifyText                 1 of 1 file uploaded                   60
        sleep                      1
        ClickText                  Done
        UseModal                   Off

        ClickText                  Upload Files
        UseModal                   On
        # Upload File                xpath\=//input[@type\="file"]          ../resources/files/CAP- Test Image.jpeg    ${CAP}
        Upload File                xpath\=//input[@type\="file"]          ${CURDIR}/../resources/files/CAP- Test Image.jpeg
        VerifyText                 1 of 1 file uploaded                   60
        sleep                      1
        ClickText                  Done
        UseModal                   Off

        ClickText                  Upload Files
        UseModal                   On
        # Upload File                xpath\=//input[@type\="file"]          ../resources/files/CopadoTestAppIcon.png    ${CopadoTestAppIcon}
        Upload File                xpath\=//input[@type\="file"]          ${CURDIR}/../resources/files/CopadoTestAppIcon.png
        VerifyText                 1 of 1 file uploaded                   60
        sleep                      1
        ClickText                  Done
        UseModal                   Off
        
        ClickText                  Upload Files
        UseModal                   On
        # Upload File                xpath\=//input[@type\="file"]          ../resources/files/lorem_ipsum_3kb.pdf    ${lorem_ipsum_3kb}
        Upload File                xpath\=//input[@type\="file"]          ${CURDIR}/..//resources/files/lorem_ipsum_3kb.pdf
        VerifyText                 1 of 1 file uploaded                   60
        sleep                      1
        ClickText                  Done
        UseModal                   Off
        
        VerifyText                 Files (4)                        20
        Log                        Uploaded 4 files : txt, jpeg, png and pdf
        Log To Console             Uploaded 4 files : txt, jpeg, png and pdf

        ClickText                    New
        VerifyText                   New Reference
        TypeText                     *Title    First Reference
        ClickText                    Save
        ClickText                    New
        VerifyText                   New Reference
        TypeText                     *Title    second reference
        ClickText                    Save

        Log                        Added 2 References
        Log To Console             Added 2 References
        VerifyText                 Submit
        ClickText                  Submit
        VerifyText                 The Case Message has been submitted successfully        60
        Log                        Submitted Case Message Id : ${caseMsgId}
        Log To Console             Submitted Case Message Id : ${caseMsgId}
    EXCEPT    AS    ${error}
        Log         Populate all required fields and add files of various supported formats and references and submit the case message Block failed: ${error}
        Log To Console     Populate all required fields and add files of various supported formats and references and submit the case message Block failed: ${error}
        LogScreenshot      filename=error_message_creation_failure.png    fullpage=False
        Fail               Populate all required fields and add files of various supported formats and references and submit the case message Block failed: ${error}
    END
    
Open created case message and click on Print button
    [Documentation]    Print Message pop up window should get open with following options: Messages(s) - by default selected, Message(s) and Attachment(s), Attachment(s), Custom
    TRY
        VerifyText    Multi Operator Messages    60
        sleep         5s
        RefreshPage
        VerifyText    Boeing Communication System    60
        VerifyText    xpath\=(//lightning-primitive-cell-factory[@data-label\="Message #"]//A[@href\="/${caseMsgId}"])[1]    60
        ClickText     xpath\=(//lightning-primitive-cell-factory[@data-label\="Message #"]//A[@href\="/${caseMsgId}"])[1]
        SwitchWindow    NEW
        SwitchWindow    2
        VerifyText      Request    60
        VerifyText    xpath\=//div[@title\="Status"]/following-sibling::div[@title\="Not Started"]

        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${caseMsgBMN}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${caseMsgBMN}
        
        Log                        Open Case Message BMN : ${caseMsgBMN}
        Log To Console             Open Case Message BMN : ${caseMsgBMN}

        #Follow-On Case Message
        ClickText                  Follow-on
        VerifyText                 xpath\=//div[@title\="Status"]/following-sibling::div[@title\="Draft"]
        Log                        Follow-On Draft Loaded
        Log To Console             Follow-On Draft Loaded
        ClickText                    xpath\=(//Label[normalize-space(text())\="Due Date"]/following-sibling::div//input[@class\="slds-input"])[last()]
        VerifyText                   xpath\=//lightning-layout-item[@c-bcsdatepickerwebcomponent_bcsdatepickerwebcomponent]//div[normalize-space()\="(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)"]
        ClickText                    Next Month
        ClickText                    Next Month
        ClickText                    12                        anchor=Selected Due Date is
        ClickText                    xpath\=(//button[@class\="slds-button slds-button_brand"])
        ClickElement                 xpath\=(//button[@class\="slds-button slds-button_icon slds-button_icon-border"])[1]
        VerifyElement                xpath\=((//lightning-input-rich-text[@class\="slds-form-element"])/div/div/div/div[3]/div[1])[2]    60
        ClickElement                 xpath\=((//lightning-input-rich-text[@class\="slds-form-element"])/div/div/div/div[3]/div[1])[2]
        TypeText                     xpath\=((//lightning-input-rich-text[@class\="slds-form-element"])/div/div/div/div//p)[2]    This Case Message is being sent for testing purposes.
        ClickText                    Save
        ClickText                    Submit
        VerifyNoElement              //lightning-spinner                        60
        VerifyText                   Boeing Communication System
        Log                        Follow-On Submitted
        Log To Console             Follow-On Submitted
        CloseWindow
        SwitchWindow                 1
        RefreshPage
        VerifyText                   Boeing Communication System
        ClickText                    ${caseMsgBMN}
        SwitchWindow    NEW
        SwitchWindow    2

        VerifyText    xpath\=//div[@title\="Status"]/following-sibling::div[@title\="Not Started"]
        Log                        Re-Open Case Message BMN : ${caseMsgBMN}
        Log To Console             Re-Open Case Message BMN : ${caseMsgBMN}


        #Extract Values to validate with print preview
        Log                Extract Values to validate with print preview
        Log To Console     Extract Values to validate with print preview
        
        ${text_nodes}=     GetWebElement    xpath\=//p[contains(normalize-space(),"PRIORITY")]
        ${raw_priority}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        ${priority}=                    Split To Lines                     ${raw_priority}
        Set Global Variable          ${priority}
        
        ${text_nodes}=     GetWebElement    xpath\=//p[contains(normalize-space(),"PART(S):")]
        ${raw_parts}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        ${parts}=                    Split To Lines                     ${raw_parts}
        Set Global Variable          ${parts}

        ${text_nodes}=     GetWebElement    xpath\=//p[contains(normalize-space(),"AIRPLANE(S):")]
        ${raw_airplane}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        ${airplane}                     Split To Lines                     ${raw_airplane}
        Set Global Variable          ${airplane}

        ${text_nodes}=     GetWebElement    xpath\=//p[contains(normalize-space(),"SUBJECT: Subject-")]
        ${subject}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        Set Global Variable          ${subject}

        ${text_nodes}=     GetWebElement    xpath\=//p[contains(normalize-space(),"REFERENCES:")]
        ${raw_references}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        ${references}                     Split To Lines                     ${raw_references}
        Set Global Variable          ${references}
        
        ${text_nodes}=     GetWebElement    xpath\=(//p[contains(normalize-space(),"DESCRIPTION:")]/following-sibling::p)[1]
        ${description}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        Set Global Variable          ${description}

        ${text_nodes}=     GetWebElement    xpath\=(//p[contains(normalize-space(),"DESIRED ACTION:")]/following-sibling::p)[1]
        ${desiredAction}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        Set Global Variable          ${desiredAction}

        ${text_nodes}=     GetWebElement    xpath\=//p[contains(normalize-space(),"The following files are attached to this message:")]
        ${raw_attachments}=                Call Method                        ${text_nodes}[0]   get_attribute    innerText
        ${attachments}                     Split To Lines                     ${raw_attachments}
        Set Global Variable          ${attachments}

        VerifyElement              xpath\=//Button[@title\="Print"]
        ClickElement               xpath\=//Button[@title\="Print"]
        
        VerifyText                 Print Record
        TRY
            VerifyAttribute    xpath\=//label[normalize-space()\="Message(s)"]/preceding-sibling::input[@type\="radio"]    checked    true
            Log                        Verified: Message(s) radio button is select by default
            Log To Console             Verified: Message(s) radio button is select by default
        EXCEPT
            Fail               Message(s) radio button is not selected by default
        END

        VerifyText                 Message(s)
        Log                        Verified: Message(s) is visible
        Log To Console             Verified: Message(s) is visible
        VerifyText                 Attachment(s)
        Log                        Verified: Attachment(s) is visible
        Log To Console             Verified: Attachment(s) is visible
        VerifyText                 Show All Related Case Message(s)
        Log                        Verified: Show All Related Case Message(s) is visible
        Log To Console             Verified: Show All Related Case Message(s) is visible
        VerifyText                 Message(s) and Attachment(s)
        Log                        Verified: Message(s) and Attachment(s) is visible
        Log To Console             Verified: Message(s) and Attachment(s) is visible
        VErifyText                 Custom
        Log                        Verified: Custom is visible
        Log To Console             Verified: Custom is visible
    EXCEPT    AS    ${error}
        Log         Open created case message and click on Print button Block failed: ${error}
        Log To Console     Open created case message and click on Print button Block failed: ${error}
        LogScreenshot      filename=error_repoen_and_click_button_failure.png    fullpage=False
        Fail               Open created case message and click on Print button Block failed: ${error}   
    END

Click Print button on popup
    [Documentation]    Print preview successfully opens up to display message details as populated on message detail page
    TRY
        ClickElement       xpath\=//button[@class\="slds-button slds-button_brand"]
        Log                Clicked on Print
        Log To Console     Clicked on Print
        SwitchWindow       3
        sleep              5
        SetConfig          VerifyAppAccuracy    0.99
        VerifyApp          ./images/boeing.png
        VerifyApp          ./images/clickAbless.png
        Log                Verified : Print preview is visible
        Log To Console     Verified : Print preview is visible

        ${print_url}=      GetUrl
        Open Browser       ${login_url}    chrome
        ...                prefs=download.prompt_for_download: False, plugins.always_open_pdf_externally: True
        TypeText           Username    ${username}
        TypeSecret         Password    ${password}
        ClickText          Log In to Sandbox
        VerifyText         Boeing Communication System    60
        Log To Console     Logged in successfully
        Log To Console     Logged in via second browser
        Log                Logged in successfully
        Log                Logged in via second browser
        ExpectFileDownload
        ClickText    Search    anchor=Boeing Communication System
        TypeText    Ask a question...    ${caseMsgBMN}
        ClickText                        xpath\=(//button[@title\="Search"])[1]
        VerifyText                       Search Results
        ${caseMsgFound}=                 IsText            1 Result    timeout=5s
        IF                        ${caseMsgFound} == False
            Log                        Did Not Found ${caseMsgBMN} in fist attempt
            Log To Console             Did Not Found ${caseMsgBMN} in fist attempt
            sleep                      5
            RefreshPage
            VerifyText                   1 Result
        END
        ClickText                        Case Messages    anchor=1 Result
        ClickText                        xpath\=(//table[@class\="forceRecordLayout slds-table slds-table_cell-buffer slds-table_bordered uiVirtualDataGrid--default uiVirtualDataGrid"]/tbody/tr//a)[1]
        ClickText                        Print
        VerifyText                       Print Record
        ClickElement       xpath\=//button[@class\="slds-button slds-button_brand"]
        ${pdf_path}=       VerifyFileDownload    timeout=30s
        Log To Console     PDF downloaded: ${pdf_path}
        UsePdf             ${pdf_path}
        
        #Validating Details on print preview
        Log                Validating Details on print preview
        Log To Console     Validating Details on print preview
        VerifyPdfText      ${caseMsgBMN}
        Log                Validated : PDF contains Case Message bmn ${caseMsgBMN}
        Log To Console     Validated : PDF contains Case Message bmn ${caseMsgBMN}
        
        FOR                ${p}                  IN      @{priority}
            VerifyPdfText                        ${p}
        END
        Log                Validated : PDF contains product details as ${priority}
        Log To Console     Validated : PDF contains product details as ${priority}
        
        FOR                ${p}                  IN      @{parts}
            VerifyPdfText                        ${p}
        END
        Log                Validated : PDF contains parts details as ${parts}
        Log To Console     Validated : PDF contains parts details as ${parts}
        
        FOR                ${p}                  IN      @{airplane}
            ${clean_p}=      Evaluate         " ".join($p.split())
        
            IF    '${clean_p}' != '${EMPTY}'
                ${has_colon}=    Evaluate    ':' in $clean_p
            
                IF    ${has_colon}
                    ${airplaneParts}=       Evaluate    [x.strip() for x in $clean_p.split(':', 1)]
                    ${label}=       Set Variable    ${airplaneParts[0]}
                    ${value}=       Set Variable    ${airplaneParts[1]}
                    VerifyPdfText    ${label}
                    VerifyPdfText    ${value}
                ELSE
                    VerifyPdfText    ${clean_p}
                    END
                END
        END
        Log                Validated : PDF contains airplane details as ${airplane}
        Log To Console     Validated : PDF contains airplane details as ${airplane}
        
        VerifyPdfText      ${subject}
        Log                Validated : PDF contains subject details as ${subject}
        Log To Console     Validated : PDF contains subject details as ${subject}

        FOR                ${p}                  IN      @{references}
            VerifyPdfText                        ${p}
        END
        Log                Validated : PDF contains references details as ${references}
        Log To Console     Validated : PDF contains references details as ${references}
        
        VerifyPdfText      ${desiredAction}
        Log                Validated : PDF contains desiredAction details as ${desiredAction}
        Log To Console     Validated : PDF contains desiredAction details as ${desiredAction}

        FOR                ${p}                  IN      @{attachments}
            VerifyPdfText                        ${p}
        END
        Log                Validated : attachments details as ${attachments}
        Log To Console     Validated : attachments details as ${attachments}
        
        Log                PDF content verified successfully
        Log To Console     PDF content verified successfully
        RemovePdf
        CloseOthers
    EXCEPT    AS    ${error}
        Log         Click Print button on popup Block failed: ${error}
        Log To Console     Click Print button on popup Block failed: ${error}
        LogScreenshot      filename=error_preview_popup_and_validation_failure.png    fullpage=False
        Fail               Click Print button on popup Block failed: ${error} 
    END

Repeat Step 5 for validating Attachment(s) in Print Popup
    [Documentation]    "Direct Download" toggle should be displayed only when files are selected. Toggle is automatically set to ON
    TRY
        Log            validating Attachment(s) in Print Popup
        Log To Console    validating Attachment(s) in Print Popup
        Log            Open Home Page
        Log To Console    Open Home Page
        ClickElement    xpath\=//A[@href\="/s/"]
        ClickText    Search    anchor=Boeing Communication System
        Log          Reopening case message : ${caseMsgBMN}
        Log To Console         Reopening case message : ${caseMsgBMN}
        TypeText    Ask a question...    ${caseMsgBMN}
        ClickText                        xpath\=(//button[@title\="Search"])[1]
        VerifyText                       Search Results
        ${caseMsgFound}=                 IsText            1 Result    timeout=5s
        IF                        ${caseMsgFound} == False
            Log                        Did Not Found ${caseMsgBMN} in fist attempt
            Log To Console             Did Not Found ${caseMsgBMN} in fist attempt
            sleep                      5
            VerifyText                   No results for \"${caseMsgBMN}\"
            RefreshPage
            VerifyText                   1 Result
        END
        ClickText                        Case Messages    anchor=1 Result
        ClickText                        xpath\=(//table[@class\="forceRecordLayout slds-table slds-table_cell-buffer slds-table_bordered uiVirtualDataGrid--default uiVirtualDataGrid"]/tbody/tr//a)[1]
        ClickText                        Print
        VerifyText                       Print Record
        VerifyApp                        ./images/ToggleNotVisible.png
        Log                        Toggle is not visible without selecting attachments
        Log To Console             Toggle is not visible without selecting attachments
        ClickText                  Select All
        VerifyApp                        ./images/ToggleVisible.png
        Log                        Toggle is visible After selecting attachments
        Log To Console             Toggle is visible After selecting attachments
    EXCEPT    AS    ${error}
        Log         Repeat Step 5 for validating Attachment(s) in Print Popup Block failed: ${error}
        Log To Console     Repeat Step 5 for validating Attachment(s) in Print Popup Block failed: ${error}
        LogScreenshot      filename=error_direct_download_toggle_button_failure.png    fullpage=False
        Fail               Repeat Step 5 for validating Attachment(s) in Print Popup Block failed: ${error} 
    END

Verify Direct Download Toggle 
    [Documentation]    Direct Download Toggle remains ON until user click OFF. If User turns OFF Direct Download, upon Print, User receives Print Task pop-up.
    TRY
        ClickCheckbox    Direct Download    off
        VerifyApp          ./images/ToggleOffWhenClickOff.png   
        Log                Direct Download set OFF When click Off
        Log To Console     Direct Download set OFF When click Off
        ClickElement       xpath\=//button[@class\="slds-button slds-button_brand"]
        Log                Clicked on Print
        Log To Console     Clicked on Print
        VerifyNoElement    //lightning-spinner    60
        VerifyText         Task ${caseMsgBMN} created Successfully. You will need to navigate to the Home Page
        Log                Task ${caseMsgBMN} created Successfully. Whilt testing direct download toggle button.
        Log To Console     Task ${caseMsgBMN} created Successfully. Whilt testing direct download toggle button.
        ClickElement       xpath\=//button[@class\="slds-button slds-button_icon toastClose slds-button_icon-inverse slds-button_icon-bare"]
    EXCEPT    AS    ${error}
        Log         Verify Direct Download Toggle Block failed: ${error}
        Log To Console     Verify Direct Download Toggle Block failed: ${error}
        LogScreenshot      filename=error_verify_direct_download_failure.png    fullpage=False
        Fail               Verify Direct Download Toggle Block failed: ${error} 
    END

Navigate to homepage and click print tasks (if Direct Download was toggled off)
    [Documentation]    Print Task should get created successfully and User should be able to download print PDF from Print Task Tab present on home page if the On-Screen Preview toggle is off. 
    TRY
        Log            Navigate to homepage and click print tasks:
        Log To Console    Navigate to homepage and click print tasks:
        Log            Open Home Page
        Log To Console    Open Home Page
        ClickElement    xpath\=//A[@href\="/s/"]
        VerifyText      Boeing Communication System
        ClickText       Print Tasks
        Log             Navigate Print Tasks
        Log To Console    Navigate Print Tasks
        ${IsTaskPresent}=    IsText    ${caseMsgBMN}
        IF                   ${IsTaskPresent} != True
            Log              Requested Task is not available
            Log To Console             Requested Task is not available
            Fail                       Requested Task is not available
        END
        VerifyText                     DownLoad Link    60
        ${target_xpath}=    Set Variable    xpath=(//th[normalize-space()="${caseMsgBMN}"]/following-sibling::td//A[contains(normalize-space(),"Click Here")])[1]
        ${counter}=         Set Variable    ${0}
        ${IsLinkPresent}=   IsElement       ${target_xpath}    timeout=0
        WHILE               not ${IsLinkPresent} and ${counter} < 10
            RefreshPage
            Log To Console        Refresh Print Task page Counter : ${Counter + 1}/10
            Log                   Refresh Print Task page Counter : ${Counter + 1}/10
            ClickElement          xpath=(//button[@title="Refresh list"])[2]
            Sleep                 15s
            ${IsLinkPresent}=   IsElement       ${target_xpath}    timeout=0
            ${counter}=         Evaluate        ${counter} + 1
        END
        
        IF    not ${IsLinkPresent}
            Log                   Download Link for Given Task is not available after 200 seconds
            Log To Console        Download Link for Given Task is not available after 200 seconds
            Fail                  Download Link for Given Task is not available after 200 seconds
                ELSE
            Log To Console        SUCCESS: Download Link found!
            Log                   SUCCESS: Download Link found!
        END
        ExpectFileDownload
        ClickElement                   xpath\=(//th[normalize-space()\="${caseMsgBMN}"]/following-sibling::td//A[contains(normalize-space(),"Click Here")])[1]
        ${pdf_path}=                   VerifyFileDownload    timeout=30s
        RemoveFile                     ${pdf_path}        
    EXCEPT    AS    ${error}
        Log         Navigate to homepage and click print tasks (if Direct Download was toggled off) Block failed: ${error}
        Log To Console     Navigate to homepage and click print tasks (if Direct Download was toggled off) Block failed: ${error}
        LogScreenshot      filename=error_navigate_home_page_and_click_print_failure.png    fullpage=False
        Fail               Navigate to homepage and click print tasks (if Direct Download was toggled off) Block failed: ${error} 
    END

Validate print functionality all other radio buttons present in modal (Attachment(s), Show All Related Case Message(s), Message(s) & Attachment(s), and Custom)
    [Documentation]    Print Task should get created successfully and User should be able to download print PDF from Print Task Tab present on home page if the Direct Download toggle is off. and Print Task should not get created if the Direct Download toggle is on. Print Preview of selected messages/attachments should appear. 
    TRY
        ClickElement    xpath\=//A[@href\="/s/"]
        VerifyText      Boeing Communication System
        ClickText    Search    anchor=Boeing Communication System
        Log          Reopening case message : ${caseMsgBMN}
        Log To Console         Reopening case message : ${caseMsgBMN}
        TypeText    Ask a question...    ${caseMsgBMN}
        ClickText                        xpath\=(//button[@title\="Search"])[1]
        VerifyText                       Search Results
        ${caseMsgFound}=                 IsText            1 Result    timeout=5s
        IF                        ${caseMsgFound} == False
            Log                        Did Not Found ${caseMsgBMN} in fist attempt
            Log To Console             Did Not Found ${caseMsgBMN} in fist attempt
            sleep                      5
            VerifyText                   No results for \"${caseMsgBMN}\"
            RefreshPage
            VerifyText                   1 Result
        END
        ClickText                        Case Messages    anchor=1 Result
        ClickText                        xpath\=(//table[@class\="forceRecordLayout slds-table slds-table_cell-buffer slds-table_bordered uiVirtualDataGrid--default uiVirtualDataGrid"]/tbody/tr//a)[1]
        
        #Attachment(s) with direct download ON
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Attachment(s)
        ExpectFileDownload
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_brand"]
        ${pdf_path}=                     VerifyFileDownload            timeout=30s
        RemoveFile                       ${pdf_path} 
        sleep                        3s

        #Attachment(s) with direct download OFF
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Attachment(s)
        ClickCheckbox                    Direct Download     off
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_brand"]
        VerifyText                       Task ${caseMsgBMN} created Successfully. You will need to navigate to the Home Page
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_icon toastClose slds-button_icon-inverse slds-button_icon-bare"]
        sleep                        3s
        
        #Message(s) and Attachment(s) with direct download ON
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Message(s) and Attachment(s)
        ExpectFileDownload
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_brand"]
        ${pdf_path}=                     VerifyFileDownload            timeout=30s
        RemoveFile                       ${pdf_path} 
        sleep                        3s
        
        #Message(s) and Attachment(s) with direct download OFF
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Message(s) and Attachment(s)
        ClickCheckbox                    Direct Download     off
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_brand"]
        VerifyText                       Task ${caseMsgBMN} created Successfully. You will need to navigate to the Home Page
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_icon toastClose slds-button_icon-inverse slds-button_icon-bare"]
        sleep                        3s
        
        #Show All Related Case Message(s) with direct download ON
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Show All Related Case Message(s)
        ExpectFileDownload
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_brand"]
        ${pdf_path}=                     VerifyFileDownload            timeout=30s
        RemoveFile                       ${pdf_path} 
        sleep                        3s
        
        #Show All Related Case Message(s) with direct download OFF
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Show All Related Case Message(s)
        ClickCheckbox                    Direct Download     off
        ClickElement                     xpath\=//button[contains(@class,"slds-button slds-button_brand")]
        VerifyText                       Task ${caseMsgBMN} created Successfully. You will need to navigate to the Home Page
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_icon toastClose slds-button_icon-inverse slds-button_icon-bare"]
        sleep                        3s
        
        #Custom with direct download ON
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Custom
        ClickElement                     xpath\=//button[contains(@class,"slds-button slds-button_brand")]
        VerifyText                       Select at least one message or attachment to initiate print
        sleep                        2s
        ClickText                        Select All
        ExpectFileDownload
        ClickElement                     xpath\=//button[contains(@class,"slds-button slds-button_brand")]
        ${pdf_path}=                     VerifyFileDownload            timeout=30s
        RemoveFile                       ${pdf_path} 
        sleep                        3s

        #Custom with direct download OFF
        ClickText                        Print
        VerifyText                       Print Record
        ClickText                        Custom
        ClickText                        Select All
        ClickCheckbox                    Direct Download     off
        ClickElement                     xpath\=//button[contains(@class,"slds-button slds-button_brand")]
        VerifyText                       Task ${caseMsgBMN} created Successfully. You will need to navigate to the Home Page
        ClickElement                     xpath\=//button[@class\="slds-button slds-button_icon toastClose slds-button_icon-inverse slds-button_icon-bare"]
        sleep                        3s
    EXCEPT    AS    ${error}
        Log         Validate print functionality all other radio buttons present in modal (Attachment(s), Show All Related Case Message(s), Message(s) & Attachment(s), and Custom) Block failed: ${error}
        Log To Console     Validate print functionality all other radio buttons present in modal (Attachment(s), Show All Related Case Message(s), Message(s) & Attachment(s), and Custom) Block failed: ${error}
        LogScreenshot      filename=error_validate_functionality_for_all_radio_button_failure.png    fullpage=False
        Fail               Validate print functionality all other radio buttons present in modal (Attachment(s), Show All Related Case Message(s), Message(s) & Attachment(s), and Custom) Block failed: ${error} 
    END
    
Navigate to homepage and click print tasks
    [Documentation]    Case message number displays along with link to download print file
    TRY
        Log            Navigate to homepage and click print tasks:
        Log To Console    Navigate to homepage and click print tasks:
        Log            Open Home Page
        Log To Console    Open Home Page
        ClickElement    xpath\=//A[@href\="/s/"]
        VerifyText      Boeing Communication System
        ClickText       Print Tasks
        Log             Navigate Print Tasks
        Log To Console    Navigate Print Tasks
        ${IsTaskPresent}=    IsText    ${caseMsgBMN}
        IF                   ${IsTaskPresent} != True
            Log              Requested Task is not available
            Log To Console             Requested Task is not available
            Fail                       Requested Task is not available
        END
        ${IsLinkPresent}=              IsElement    xpath\=(//th[normalize-space()\="${caseMsgBMN}"]/following-sibling::td//A[contains(normalize-space(),"Click Here")])[1]
        IF                        ${IsLinkPresent} != True
            Log                   Download Link for Given Task is not available
            Log To Console        Download Link for Given Task is not available
            Fail                  Download Link for Given Task is not available
        END
        Log                   Download Link for Given Task is available
        Log To Console        Download Link for Given Task is available
    EXCEPT    AS    ${error}
        Log         Navigate to homepage and click print tasks Block failed: ${error}
        Log To Console     Navigate to homepage and click print tasks Block failed: ${error}
        LogScreenshot      filename=error_validate_functionality_for_all_radio_button_failure.png    fullpage=False
        Fail               Navigate to homepage and click print tasks Block failed: ${error} 
    END