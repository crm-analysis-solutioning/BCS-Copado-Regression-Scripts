*** Settings ***
Documentation           Test Case created using the QEditor
# You can change imported library to "QWeb" if testing generic web application, not Salesforce.
#Resource                /Resources/common.robot
Library                 QForce
Library                 OperatingSystem
#Library                 QWeb
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
        Log         Login to BCS Homepage Block failed: ${error}
        Log To Console     Login to BCS Homepage Block failed: ${error}
        LogScreenshot      filename=error_login_failure.png    fullpage=False
        Fail               Login to BCS Homepage Block failed: ${error}
    END

    
Click on Create A Case button
    [Documentation]    "Contact Customer Support" page should get displayed with following fields: Subject, Description, Desired Action, Service Category (Mandatory)
    TRY
        VerifyText         Boeing Communication System
        ClickText          Create A Case
        Log                Clicked on Create a Case
        Log To Console     Clicked on Create a Case
        VerifyText         Contact Customer Support    60
        VerifyText         Subject
        VerifyText         Description
        VerifyText         Desired Action
        VerifyText         Service Category
        Log To Console     Subject, Description, Desired Action and Service Category fields are visible
        Log                Subject, Description, Desired Action and Service Category fields are visible
    EXCEPT    AS    ${error}
        Log         Click on Create A Case button Block failed: ${error}
        Log To Console     Click on Create A Case button Block failed: ${error}
        LogScreenshot      filename=error_click_Create_A_Case_buton.png    fullpage=False
        Fail               Click on Create A Case button Block failed: ${error}
    END

Click on Next button without entering any data
    [Documentation]    "Service Category" field should get highlighted with message "Complete this field"
    TRY    
        Log            Click on Next button without entering any data to test Service Category
        Log To Console    Click on Next button without entering any data to test Service Category
        VerifyNoElement    xpath\=//button[@aria-invalid\="true"]
        ClickText          Next
        VerifyElement      xpath\=//button[@aria-invalid\="true"]
        VerifyText         Complete this field
        Log To Console     Verified : Service Category is mandatory
        Log                Verified : Service Category is mandatory
    EXCEPT    AS    ${error}
        Log         Click on Next button without entering any data Block failed: ${error}
        Log To Console     Click on Next button without entering any data Block failed: ${error}
        LogScreenshot      filename=error_click_exit_without_entering_data.png    fullpage=False
        Fail               Click on Next button without entering any data Block failed: ${error}
    END

Enter any data in subject field
    [Documentation]    Related suggestions should get populated on screen at right side when subject is entered
    TRY
        Log            Enter any data in subject field
        Log To Console    Enter any data in subject field
        TypeText           Subject    Subject- This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
        sleep              1
        VerifyElement      xpath\=(//div[@class\="slds-grid_vertical slds-wrap slds-has-block-links caseDeflectionList"]//ul//a/following-sibling::ul//li)[1]
        Log                Verified : Related Suggestion are visible
        Log To Console     Verified : Related Suggestion are visible
    EXCEPT    AS    ${error}
        Log         Enter any data in subject field Block failed: ${error}
        Log To Console     Enter any data in subject field Block failed: ${error}
        LogScreenshot      filename=error_Enter_any_data_in_subject_field.png    fullpage=False
        Fail               Enter any data in subject field Block failed: ${error}
    END

Enter all required details and then click on Next button
    [Documentation]    New Draft Case message detail page should get displayed
    TRY
        Log            Enter all required details and then click on Next button
        TypeText           xpath\=(//div[@class\="ql-editor ql-blank slds-rich-text-area__content slds-grow slds-g-color-neutral-base-10"])/p  This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
        TypeText           xpath\=((//LIGHTNING-INPUT-RICH-TEXT[@class\="slds-form-element"][2]/div/div/div/div[2]/div/p))  This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard
        PickList           *Service Category    Airplane Repair
        ClickText          Complete this field 
        sleep              2
        ClickText          Next
        VerifyElement      xpath\=//label[normalize-space()\="*Due Date"]
        Log To Console     New Draft Case message detail page Loaded
        Log                New Draft Case message detail page Loaded
    EXCEPT    AS    ${error}
        Log         Enter all required details and then click on Next button Block failed: ${error}
        Log To Console     Enter all required details and then click on Next button Block failed: ${error}
        LogScreenshot      filename=error_Enter_all_required_details_and_then_click_on_next_button.png    fullpage=False
        Fail               Enter all required details and then click on Next button Block failed: ${error}
    END

Enter all required details in each tab
    [Documentation]    Add Date and Airplane details    
    TRY
        VerifyText         Do not put ITAR data in BCS as BCS is not authorized to contain ITAR data    60
        Log                Started Adding Date and Airplane details
        
        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${html_content}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${html_content}

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
    EXCEPT    AS    ${error}
        Log         Enter all required details in each tab Block failed: ${error}
        Log To Console     Enter all required details in each tab Block failed: ${error}
        LogScreenshot      filename=error_Enter_all_required_details_in_each_tab.png    fullpage=False
        Fail               Enter all required details in each tab Block failed: ${error}
    END
    
Add multiple files and references
    [Documentation]    Add 2 References and Upload 3 files
    TRY
        Log                Started Adding 2 references and uploading 3 files
        ClickText                    2 - Message Details
        ClickText                    New
        VerifyText                   New Reference
        TypeText                     *Title    First Reference
        ClickText                    Save
        ClickText                    New
        VerifyText                   New Reference
        TypeText                     *Title    second reference
        ClickText                    Save
        
        Create File                  ${OUTPUT DIR}/sample1.txt    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!
        Create File                  ${OUTPUT DIR}/sample2.txt    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sodales tincidunt justo, quis facilisis turpis fringilla vel. Mauris elementum imperdiet nulla, a eleifend purus accumsan non. Quisque lacus libero, tempus a elit porta, auctor euismod ante. Donec ac mauris mi. Morbi id nisl purus. In tempus ullamcorper tristique. Vestibulum blandit.
        Create File                  ${OUTPUT DIR}/sample3.txt    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vel dui ornare, elementum leo sit amet, efficitur mauris. Nullam diam justo, luctus eget maximus sit amet, laoreet id libero. Morbi porttitor lacus in dui congue, a sollicitudin enim elementum. Sed non diam efficitur lacus placerat pellentesque semper nec augue. Quisque tincidunt porta lacus egestas ornare. Curabitur id metus mattis, tempor lorem non, mollis purus. Cras tincidunt ligula hendrerit sem cursus fermentum sit amet quis justo. Morbi mollis purus eget condimentum elementum. Phasellus neque dui, commodo nec magna at, pretium fermentum ipsum. Nulla auctor cursus sapien in rutrum. Mauris tellus massa.
        ClickText                    Upload Files
        
        Upload File                  xpath\=//input[@type\="file"]    ${OUTPUT DIR}/sample1.txt
        VerifyText                   1 of 1 file uploaded             60
        sleep                        1
        ClickText                    Done
        ClickText                    Upload Files
        Upload File                  xpath\=//input[@type\="file"]    ${OUTPUT DIR}/sample2.txt
        VerifyText                   1 of 1 file uploaded             60
        sleep                        1
        ClickText                    Done
        ClickText                    Upload Files
        Upload File                  xpath\=//input[@type\="file"]    ${OUTPUT DIR}/sample3.txt
        VerifyText                   1 of 1 file uploaded             60
        sleep                        1
        ClickText                    Done

        VerifyText                   Files (3)                        60

        Log To Console               Uploaded 2 References and 3 attachment
        Log                        Uploaded 2 References and 3 attachment

    EXCEPT    AS    ${error}
        Log         Add multiple files and references Block failed: ${error}
        Log To Console     Add multiple files and references Block failed: ${error}
        LogScreenshot      filename=error_Add_multiple_files_and_references.png    fullpage=False
        Fail               Add multiple files and references Block failed: ${error}
    END
    
Add contacts of same account code, different account code and Boeing contacts
    [Documentation]    Add contacts of same account code_ different account code and Boeing contacts
    TRY
        ClickText    3 - Contacts
        ClickText    Add Contacts
        ClickText    Global Contact Search
        TypeText     search by email...    donotdelete.copadotestuser@boeing.com
        ClickCheckbox                        Select Item 1    on    partial_match=False
        ClickCheckbox                        Select Item 2    on    partial_match=False

        ClickText                        xpath\=//button[normalize-space()\="Add"]  
        Log                        Beginning of Grace Added Addtional Contacts
        Log to Console             Beginning of Grace Added Addtional Contacts
        ClickText    Add Contacts
        ClickText    Global Contact Search
        TypeText     search by email...    testcm03@ain.com
        ClickCheckbox                        Select Item 1    on    partial_match=False
        ClickText                        xpath\=//button[normalize-space()\="Add"] 
        ClickText    Add Contacts
        ClickText    Global Contact Search
        TypeText     search by email...    grace.t.do@boeing.com
        ClickCheckbox                        Select Item 1    on    partial_match=False
        ClickText                        xpath\=//button[normalize-space()\="Add"] 
        Log                         End of Grace's addition to contacts
        Log to Console              End of Grace's addition to contacts

        ClickText                        4 - Additional Details
        VerifyText                       Airplane Location

        ClickText                        5 - Overview
        VerifyText                       Inquiry Additional Details
    
        Log To Console                   Added Contacts with email 'donotdelete.copadotestuser@boeing.com'
        Log                        Added Contacts with email 'donotdelete.copadotestuser@boeing.com'
    
    EXCEPT    AS    ${error}
        Log         Add contacts of same account code, different account code and Boeing contacts Block failed: ${error}
        Log To Console     Add contacts of same account code, different account code and Boeing contacts Block failed: ${error}
        LogScreenshot      filename=error_Add_Contact.png    fullpage=False
        Fail               Add contacts of same account code, different account code and Boeing contacts Block failed: ${error}
    END

Click on Submit
    [Documentation]    Case message should get created successfully
    TRY
        VerifyText         Submit
        ClickText                        Submit
        VerifyText                       The Case Message has been submitted successfully    60
        Log To Console                   Case Message Submited for id : ${html_content}
        Log                        Case Message Submited for id : ${html_content}
    EXCEPT    AS    ${error}
        Log         Click on Submit Block failed: ${error}
        Log To Console     Click on Submit Block failed: ${error}
        LogScreenshot      filename=error_Click_on_Submit.png    fullpage=False
        Fail               Click on Submit Block failed: ${error}
    END

Open created case message
    [Documentation]    Recently created case message should be displayed
    TRY
        VerifyText    Multi Operator Messages    60
        sleep         5s
        RefreshPage
        VerifyText    Boeing Communication System    60
        Log           Open created case message
        Log To Console                        Open created case message
        ClickElement    xpath\=(//lightning-formatted-url//a[contains(@title,${html_content})])[1]
        SwitchWindow    NEW
        SwitchWindow    2
        VerifyText      Request    60
    
        ${element}=    GetWebElement    xpath\=(//H1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${CaseMsgBMN}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        Set Global Variable          ${CaseMsgBMN}

        Log to Console               Case Message BMN : ${CaseMsgBMN}
        Log                        Case Message BMN : ${CaseMsgBMN}
    EXCEPT    AS    ${error}
        Log         Open created case message Block failed: ${error}
        Log To Console     Open created case message Block failed: ${error}
        LogScreenshot      filename=error_Open_created_case_message.png    fullpage=False
        Fail               Open created case message Block failed: ${error}
    END

Verify sequence of attachment in file and reference section 
    [Documentation]    The sequence of attachment should be same in file and reference section
    TRY
        VerifyText         Files
        ${validate-files}=    Set Variable    xpath\=//lightning-datatable[@c-bcsdatatablewebcomponent_bcsdatatabletemplate]//tbody//tr//th[normalize-space()\="sample3"]/../preceding-sibling::tr//th[normalize-space()\="sample2"]/../preceding-sibling::tr//th[normalize-space()\="sample1"]
        VerifyElement         ${validate-files}

        ${validate-reference}=                Set Variable    xpath\=//lightning-datatable[@c-bcsreferencelistview_bcsreferencelistview]//tbody//tr//td[normalize-space()\="sample3"]/../preceding-sibling::tr//td[normalize-space()\="sample2"]/../preceding-sibling::tr//td[normalize-space()\="sample1"]/../preceding-sibling::tr//td[normalize-space()\="second reference"]/../preceding-sibling::tr//td[normalize-space()\="First Reference"]
        VerifyElement                        ${validate-reference}
    
        Log To Console                       Validated : file and reference sequence
        Log                        Validated : file and reference sequence
    EXCEPT    AS    ${error}
        Log         Verify sequence of attachment in file and reference section Block failed: ${error}
        Log To Console     Verify sequence of attachment in file and reference section Block failed: ${error}
        LogScreenshot      filename=error_Verify_sequence_of_attachment_in_file_and_reference_section.png    fullpage=False
        Fail               Verify sequence of attachment in file and reference section Block failed: ${error}
    END

Validate contact on sent messages
#GTD:  This is for the emails that got sent to the users.  Only emails that are not TBC or .boeing.com should displayed in the sent email. 
# Not on the message itself in EC
    [Documentation]    All contacts should be visible except boeing contacts (Users having email as Boeing.com and Account is TBC)
    VerifyText         Contacts
    ${elements}    GetWebElement    xpath\=(//table[@class\="slds-table slds-table_bordered slds-no-row-hover slds-table_cell-buffer "]/tbody//td[@data-label\="Account Name: "])
    FOR            ${element}       IN    @{elements}
        ${inner_html}=              Call Method    ${element}    get_attribute    innerText
        IF                        "TBC" in """${inner_html}"""
            ScrollTo           Damage Report
            ${screenshot_Account}=    LogScreenshot    filename=error_EC_Airlie_Case_Create_AccountFailure_${CaseMsgBMN}.png    fullpage=False
            Log To Console             ${screenshot_Account}
            Log                        Error occur for : ${inner_html}, TBC is found in the contact  
            Fail    Error occur for : ${inner_html}, TBC is found in the contact
        END
        Log to Console            Verifing Account under Contact : ${inner_html}\n
        Log                       Verifing Account under Contact : ${inner_html}
    END
    
    # ${elements}                   GetWebElement                       xpath\=(//table[@class\="slds-table slds-table_bordered slds-no-row-hover slds-table_cell-buffer "]/tbody//td[@data-label\="Email: "]//div//lightning-formatted-text)
    # FOR                        ${element}                        IN                    @{elements}
    #     ${inner_html}=         Call Method                       ${element}            get_attribute    innerText
    #     IF                     "boeing.com" in """${inner_html}"""            Fail                  Error occur for : ${inner_html}, as boeing email found in the contact
    #     Log to Console         Email : ${inner_html}
    # END

    ${elements}                   GetWebElement                       xpath\=(//table[@class\="slds-table slds-table_bordered slds-no-row-hover slds-table_cell-buffer "]/tbody//td[@data-label\="Email: "]//div//lightning-formatted-text)
    FOR                        ${element}                        IN                    @{elements}
        ${inner_html}=         Call Method                       ${element}            get_attribute    innerText
        IF                     "boeing.com" in """${inner_html}"""            
            VerifyText         ${inner_html}
            ScrollTo           Damage Report
            ${screenshot_Contact}=    LogScreenshot    filename=error_EC_Airlie_Case_Create_ContactEmailFailure_${CaseMsgBMN}.png    fullpage=False
            Log To Console             ${screenshot_Contact}
            Log                        Error occur for : ${inner_html}, as boeing email found in the contact
            Fail                  Error occur for : ${inner_html}, as boeing email found in the contact
        END
        Log to Console         Email : ${inner_html}
    END

#Check mail of the contacts added in case message 
#  - cannot test outlook senario in CRT