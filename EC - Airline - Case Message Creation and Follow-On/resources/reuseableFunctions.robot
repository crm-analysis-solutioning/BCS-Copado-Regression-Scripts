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

*** Variables ***
${RTFValues}=    This Case Message is being sent for testing purposes. If you have received this case message in error, please disregard

*** Keywords ***
Login to BCS Homepage
    [Documentation]    login script for EC Homepage non-fsr
    TRY
        Log To Console     \n\n*****Execution Steps*****
        #Log                *****Execution Steps*****
        GoTo     ${login_url}
        VerifyText         Username
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
        Log                Clicked on Create A Case
        Log To Console     Clicked on Create A Case
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
        TypeText           Subject    ${RTFValues}
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
        TypeText           xpath\=(//div[@class\="ql-editor ql-blank slds-rich-text-area__content slds-grow slds-g-color-neutral-base-10"])/p  ${RTFValues}
        TypeText           xpath\=((//LIGHTNING-INPUT-RICH-TEXT[@class\="slds-form-element"][2]/div/div/div/div[2]/div/p))  ${RTFValues}
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
        ClickText                    12
        ClickText                    xpath\=(//button[@class\="slds-button slds-button_brand"])
        
        ClickText                    Add Airplanes
        ClickText                    Global Airplane Search
        TypeText                     Global Airplane Search                12345DoNotDelete
        ClickText                    Search
        ClickCheckbox                Select Item 1                        on               partial_match=False
        ClickText                    Edit Cycles
        TypeText                     Cycles                        3
        ClickText                    Edit Hours
        TypeText                     Hours                        6
        ClickText                    Add                        partial_match=False
        ComboBox                     Search ATA Codes...        1000
        PickList                     Repair Approval            No
        ClickText                    Add Parts
        TypeText                     *Part Number               121
        TypeText                     Serial Number              231
        ClickText                    Save
        Log To Console               Added Date and Airplane details in Case Detail Page
        Log                        Added Date and Airplane details in Case Detail Page
    EXCEPT    AS    ${error}
        Log         Enter all required details in each tab Block failed: ${error}
        Log To Console     Enter all required details in each tab Block failed: ${error}
        LogScreenshot      filename=error_Enter_all_required_details_in_each_tab.png    fullpage=False
        Fail               Enter all required details in each tab Block failed: ${error}
    END

Add files and references
    [Documentation]    Add files and references
    TRY
        Log                Started Adding 2 reference and uploading file
        ClickText                    2 - Message Details  
        ClickText                    New
        TypeText                     *Title                     First Reference
        ClickText                    Save
        ClickText                    New
        TypeText                     *Title                     second reference
        ClickText                    Save
        
        Create File    ${OUTPUT DIR}/sample.txt   	Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!Hello, world! Hello, world!
        ClickText      Upload Files
        Upload File    xpath\=//input[@type\="file"]    ${OUTPUT DIR}/sample.txt
        VerifyText     1 of 1 file uploaded             60
        sleep          3
        ClickText      Done
        VerifyText     Files (1)                        60

        Log To Console               Uploaded 2 References and attachment
        Log                        Uploaded 2 References and attachment

        ClickText    3 - Contacts
        VerifyText    Add Contacts
        ClickText    4 - Additional Details
        VerifyText       Airplane Location
        ClickText    5 - Overview
        VerifyText       Inquiry Additional Details
        
    EXCEPT    AS    ${error}
        Log         Add multiple files and references Block failed: ${error}
        Log To Console     Add multiple files and references Block failed: ${error}
        LogScreenshot      filename=error_Add_multiple_files_and_references.png    fullpage=False
        Fail               Add multiple files and references Block failed: ${error}
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

    EXCEPT    AS    ${error}
        Log         Open created case message Block failed: ${error}
        Log To Console     Open created case message Block failed: ${error}
        LogScreenshot      filename=error_Open_created_case_message.png    fullpage=False
        Fail               Open created case message Block failed: ${error}
    END

    TRY
        Log                Extract values from 01C to validate on follow-on form
        Log To Console     Extract values from 01C to validate on follow-on form
        #Get values from 01C to validate on follow-on form
        #BMN Number and Case Message Number
        ${element}=    GetWebElement                   xpath\=(//h1[@c-bcsrecordbannerwebcomponent_bcsrecordbannerwebcomponent]//span)[2]
        ${html_content}=                Call Method                        ${element}[0]   get_attribute    innerHTML
        ${bmn_value}=     Evaluate                          """${html_content[:-4]}"""
        Set Global Variable                        ${bmn}                ${bmn_value}
        Set Global Variable                        ${Case_Message_Number}                  ${html_content}
        Log                                        Case Message Number : ${Case_Message_Number}
        Log To Console                        Case Message Number : ${Case_Message_Number}

        #Service Category
        ${element}=    GetWebElement    xpath\=//div[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="Service Category"]//following-sibling::div
        ${ServiceCategory}=                Call Method                        ${element}[0]   get_attribute    innerText
        Set Global Variable          ${ServiceCategory}
        Log To Console               Service Category : ${ServiceCategory}
        Log                        Service Category : ${ServiceCategory}

        #Ata Code
        ${element}=    GetWebElement    xpath\=//div[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="ATA Code"]//following-sibling::div
        ${AtaCode}=                Call Method                        ${element}[0]   get_attribute    innerText
        Set Global Variable          ${AtaCode}
        Log To Console               Ata Code : ${AtaCode}
        Log                        Ata Code : ${AtaCode}

        #Product Type
        ${element}=    GetWebElement    xpath\=//div[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="Product Type"]//following-sibling::div
        ${ProductType}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${ProductType}
        Log To Console               Product Type : ${ProductType}
        Log                        Product Type : ${ProductType}

        #Product Line
        ${element}=    GetWebElement    xpath\=//div[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="Product Line"]//following-sibling::div
        ${ProductLine}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${ProductLine}
        Log To Console               Product Line : ${ProductLine}
        Log                        Product Line : ${ProductLine}

        #Product
        ${element}=    GetWebElement    xpath\=//div[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="Product"]//following-sibling::div
        ${Product}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${Product}
        Log To Console               Product : ${Product}
        Log                        Product : ${Product}

        #Inquiry Additional Details
        ${element}=    GetWebElement    xpath\=//span[normalize-space()\="Inquiry Additional Details"]/..
        ${InquiryAdditionalDetails}=    Call Method    ${element}[0]    get_attribute    aria-expanded
        Set Global Variable    ${InquiryAdditionalDetails}
        Log To Console               Inquiry Additional Details : ${InquiryAdditionalDetails}
        Log                        Inquiry Additional Details : ${InquiryAdditionalDetails}

        IF    "${InquiryAdditionalDetails}" == "false"
            ClickElement             xpath\=//span[normalize-space()\="Inquiry Additional Details"]/..        
        END
        
        #Repair Approval
        ${element}=    GetWebElement    xpath\=//div[@c-bcscasemessagereadonly_bcscasemessagereadonly]//span[normalize-space()\="Repair Approval"]//following-sibling::div
        ${RepairApproval}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${RepairApproval}
        Log To Console               Repair Approval : ${RepairApproval}
        Log                        Repair Approval : ${RepairApproval}

        #Affected Airplane Details
        VerifyText                   Affected Airplanes
        ScrollTo                     Affected Airplanes
        sleep                        1s

        #Serial Number
        ${element}=    GetWebElement    xpath\=(//td[@data-label\="Serial #"])
        ${SerialNumber}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${SerialNumber}
        Log To Console               Serial Number : ${SerialNumber}
        Log                        Serial Number : ${SerialNumber}

        #VAR Number
        ${element}=    GetWebElement    xpath\=(//td[@data-label\="VAR #"])
        ${VARNumber}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${VARNumber}
        Log To Console               VAR Number : ${VARNumber}
        Log                        VAR Number : ${VARNumber}

        #Regsitry Number
        ${element}=    GetWebElement    xpath\=(//td[@data-label\="Registry #"])
        ${RegistryNumber}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${RegistryNumber}
        Log To Console               Registry Number : ${RegistryNumber}
        Log                        Registry Number : ${RegistryNumber}

        #Cycles
        ${element}=    GetWebElement    xpath\=(//td[@data-label\="Cycles"])
        ${Cycles}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${Cycles}
        Log To Console               Cycles : ${Cycles}
        Log                        Cycles : ${Cycles}

        #Hours
        ${element}=    GetWebElement    xpath\=(//td[@data-label\="Hours"])
        ${Hours}=    Call Method    ${element}[0]    get_attribute    innerText
        Set Global Variable    ${Hours}
        Log To Console               Hours : ${Hours}
        Log                        Hours : ${Hours}

        #References
        ${references_elements}=      GetWebElement                    xpath\=//header[contains(normalize-space(),"References")]/../following-sibling::div//tbody//tr//td[@data-label\="Title"]
        ${all_titles}=               Create List
        FOR                        ${element}                        IN       @{references_elements}
            ${inner_reference_text}=         Call Method             ${element}       get_attribute         innerText
            ${all_titles}=             Evaluate                      ${all_titles} + ["${inner_reference_text}"]
        END
        Log To Console             Reference Table Title Values: ${all_titles}
        Log                        Reference Table Title Values: ${all_titles}
        ${referenceValidationList}=             Evaluate                      ["${html_content}"] + ${all_titles}
        Set Global Variable                      ${referenceValidationList}

        #Contact
        ${contactTextElement}                      GetWebElement                xpath\=//header[contains(normalize-space(),"Contacts")]//div//A
        ${contactText}=                        Call Method                   ${contactTextElement}[0]    get_attribute    innerText
        ${numberOfContact}=                        Evaluate                        int("${contactText}".split('(')[-1].split(')')[0].strip())
        Set Global Variable               ${numberOfContact}
        IF                        ${numberOfContact} > 0
            ${contact_elements}=      GetWebElement                    xpath\=//header[contains(normalize-space(),"Contacts")]/../following-sibling::div//tbody//tr//td[@data-label\="Name: "]
            ${all_Names}=               Create List
            FOR                        ${element}                        IN       @{contact_elements}
                ${inner_contact_text}=         Call Method             ${element}       get_attribute         innerText
                ${all_Names}=             Evaluate                      ${all_Names} + ["${inner_contact_text}"]
            END
            Log To Console             Contact Table Name Values: ${all_Names}
            Log                        Contact Table Name Values: ${all_Names}
            Set Global Variable                      ${all_Names}
            ${contact_row_count}=              Get Length                        ${all_Names}
        END
        
        # Log                        Total rows found today: ${row_count}

        # FOR                        ${element}                        IN        @{all_titles}
        #     Log To Console         ${element}
        # END

        #Affected Parts
        ${AffectedParts}=                  GetWebElement                     xpath\=//header[contains(normalize-space(),"Affected Parts")]/../following-sibling::div//tbody//tr//th[@data-label\="Part #"]
        ${allParts}                        Create List
        FOR                        ${element}                        IN             @{allParts}
            ${inner_affected_parts}=                        Call Method             ${element}            get_attribute    innerText
            ${allParts}=                        Evaluate                        ${allParts} + ["${inner_affected_parts}"]
        END
        Log To Console             Affected Parts Values: ${allParts}
        Log                        Affected Parts Values: ${allParts}
        Set Global Variable        ${allParts}

        Log                        All requried Values are extracted from 01C form
        Log To Console             All requried Values are extracted from 01C form
    EXCEPT    AS    ${error}
        Log         Open created case message Block failed during extracting values: ${error}
        Log To Console     Open created case message Block failed during extracting values: ${error}
        LogScreenshot      filename=error_Extract_Values_From_01C.png    fullpage=False
        Fail               Open created case message Block failed during extracting values: ${error}
    END
    
On above created case message detail page, Click on Follow-On button
    [Documentation]    A new draft case message should get created
    TRY
        Log            Click On Follow-on Button
        Log To Console    Click On Follow-on Button
        ClickText    Follow-on
        VerifyElement    xpath\=//div[@title\="Status"]/following-sibling::div[@title\="Draft"]    60
        Log              Follow-On Draft Loaded
        Log To Console                        Follow-On Draft Loaded
    EXCEPT    AS    ${error}
        Log         On above created case message detail page, Click on Follow-On button Block failed: ${error}
        Log To Console     On above created case message detail page, Click on Follow-On button Block failed: ${error}
        LogScreenshot      filename=error_Click_Follow_On_Button.png    fullpage=False
        Fail               On above created case message detail page, Click on Follow-On button Block failed: ${error}
    END

Validate that All details on Follow-on Draft
    [Documentation]    All details except Due date and files should get copied to follow on draft message from previous 01C message
    TRY
        Log            Validating All details on Follow-On Draft
        Log To Console    Validating All details on Follow-On Draft

        #Product Details
        VerifyElement                           xpath\=//span[normalize-space()\="Service Category"]/following-sibling::div//button[normalize-space()\="${ServiceCategory}"]
        VerifyElement                        xpath\=//span[normalize-space()\="Product Type"]/following-sibling::div//button[normalize-space()\="${ProductType}"]
        VerifyElement                        xpath\=//span[normalize-space()\="ATA Code"]/../following-sibling::div//input[@data-value\="${ATACode}"]
        VerifyElement                        xpath\=//span[normalize-space()\="Product Line"]/following-sibling::div//button[@data-value\="${ProductLine}"]
        VerifyElement                        xpath\=//span[normalize-space()\="Product"]/../following-sibling::div//input[@data-value\="${Product}"]
        Log                        Validation Passed for : Product Details
        Log To Console             Validation Passed for : Product Details

        #Inquiry Additional Details
        VerifyElement                        xpath\=//label[normalize-space()\="Repair Approval"]/../following-sibling::div//button[normalize-space()\="${RepairApproval}"]                      
        Log                        Validation Passed for : Inquiry Additional Details
        Log To Console             Validation Passed for : Inquiry Additional Details

        #Message Details
        VerifyElement                        xpath\=//lightning-textarea[@data-name\="Subject"]//textarea[normalize-space()\="${RTFValues}"]                        
        VerifyElement                        xpath\=//label[normalize-space()\="Description"]/following-sibling::lightning-input-rich-text//p[normalize-space()\="${RTFValues}"]
        Log                        Validation Passed for : Message Details
        Log To Console             Validation Passed for : Message Details

        #Affected Airplanes
        VerifyElement                        xpath\=//td[normalize-space()\="${SerialNumber}"]/following-sibling::td[normalize-space()\="${VARNumber}"]/following-sibling::td[normalize-space()\="${RegistryNumber}"]/following-sibling::td[normalize-space()\="${Cycles}"]/following-sibling::td[normalize-space()\="${Hours}"]
        Log                        Validation Passed for : Affected Airplane
        Log To Console             Validation Passed for : Affected Airplane

        #Files
        VerifyText                        Files (0)
        Log                        Validation Passed for : Files (0)
        Log To Console             Validation Passed for : Files (0)

        #References
        FOR                        ${element}    IN    @{referenceValidationList}
            VerifyElement                     xpath\=//header[contains(normalize-space(),"References")]/../following-sibling::div//tbody//tr//td[@data-label\="Title" and normalize-space()\="${element}"]
        END
        Log                        Validation Passed for : References${referenceValidationList}
        Log To Console             Validation Passed for : References${referenceValidationList}

        #Contact
        ${f_contactTextElement}      GetWebElement       xpath\=//header[contains(normalize-space(),"Contacts")]//h2[contains(normalize-space(),"Contacts")]
        ${f_contactText}=                        Call Method                   ${f_contactTextElement}[0]    get_attribute    innerText
        ${f_numberOfContact}=                        Evaluate                        int("${f_contactText}".split('(')[-1].split(')')[0].strip())
        IF                        ${numberOfContact} > 0
            FOR                        ${element}    IN    @{all_Names}
                VerifyElement                     xpath\=//header[contains(normalize-space(),"Contacts")]/../following-sibling::div//tbody//tr//td[@data-label\="Name: " and normalize-space()\="${element}"]
            END
            Log                        Validation Passed for : Contact${all_Names}
            Log To Console             Validation Passed for : Contact${all_Names}
        END
        IF                        ${numberOfContact} != ${f_numberOfContact}
            Log To Console        Number of contacts on 01C and Follow-On are different
            Log                   Number of contacts on 01C and Follow-On are different
        END

        #Affected Parts
        FOR                        ${element}    IN    @{allParts}
            VerifyElement                     xpath\=//header[contains(normalize-space(),"Affected Parts")]/../following-sibling::div//tbody//tr//th[@data-label\="Part #"]
        END
        Log                        Validation Passed for : Affected Parts${allParts}
        Log To Console             Validation Passed for : Affected Parts${allParts}

        Log                        Data Validation Completed
        Log To Console             Data Validation Completed
    EXCEPT    AS    ${error}
        Log         Validate that All details on Follow-on Draft Block failed: ${error}
        Log To Console     Validate that All details on Follow-on Draft Block failed: ${error}
        LogScreenshot      filename=error_Validate_Details_on_follow-on_draft.png    fullpage=False
        Fail               Validate that All details on Follow-on Draft Block failed: ${error}
    END                  
    
Enter Due Date and Response
    [Documentation]    A follow-on case message with sequence - 02C should get created successfully
    TRY
        Log            Enter Due Date and Response
        Log To Console    Enter Due Date and Response
        ClickText    xpath\=(//Label[normalize-space(text())\="Due Date"]/following-sibling::div//input[@class\="slds-input"])[last()]
        ClickText    Next Month
        ClickText    24
        ClickText     xpath\=(//button[@class\="slds-button slds-button_brand"])
        ClickElement    xpath\=(//button[@class\="slds-button slds-button_icon slds-button_icon-border"])[1]
        ClickElement     xpath\=(//lightning-input-rich-text[@class\="slds-form-element"])[2]/div/div/div
        TypeText   xpath\=(//lightning-input-rich-text[@class\="slds-form-element"])[2]/div/div/div/div[2]/div/p    FOLLOW ON RESPONSE
        ClickText    Save
        Log          Added Due Date and Response
    EXCEPT    AS    ${error}
        Log         Enter Due Date and Response Block failed: ${error}
        Log To Console     Enter Due Date and Response Block failed: ${error}
        LogScreenshot      filename=error_Enter_Due_Date_and_Respnse.png    fullpage=False
        Fail               Enter Due Date and Response Block failed: ${error}
    END 

Submit, Verify and Log Final Result
    [Documentation]    Submit follow-on and Validate
    TRY
        ClickText    Submit
        Log                              Submitted Follow-On Case Message
        Log To Console                   Submitted Follow-On Case Message
        VerifyText                       Follow-on ${bmn}-02C has been created
        Log to Console                   Follow-on ${bmn}-02C has been created
        Log                              Follow-on ${bmn}-02C has been created
    EXCEPT    AS    ${error}
        Log         Submit, Verify and Log Final Result Block failed: ${error}
        Log To Console     Submit, Verify and Log Final Result Block failed: ${error}
        LogScreenshot      filename=error_Submit_Verify_and_Log_Final_Result.png    fullpage=False
        Fail               Submit, Verify and Log Final Result Block failed: ${error}
    END 