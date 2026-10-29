*** Settings ***
Documentation           Test Case created using the QEditor
Library                 QForce
Library                 OperatingSystem
#Library                 QWeb
Library                 String
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers
Library                 BuiltIn
Resource                ../resources/reuseableFunctions.robot

*** Test Cases ***
EC - Airline - Case Message Create
    Login to BCS Homepage
    Click on Create A Case button
    Click on Next button without entering any data
    Enter any data in subject field
    Enter all required details and then click on Next button
    Enter all required details in each tab
    Add multiple files and references
    Add contacts of same account code, different account code and Boeing contacts
    Click on Submit
    Open created case message
    Verify sequence of attachment in file and reference section
    Validate contact on sent messages
    #Check mail of the contacts added in case message 