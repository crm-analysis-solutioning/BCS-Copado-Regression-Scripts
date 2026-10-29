*** Settings ***
Documentation           Test Case created using the QEditor
Library                 QForce
Library                 OperatingSystem
Library                 QWeb
Library                 String
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers
Library                 BuiltIn
Resource                ../resources/reuseableFunctions.robot

*** Test Cases ***
EC - Airline - Case Message Creation and Follow-On
    Login to BCS Homepage
    Click on Create A Case button
    Click on Next button without entering any data
    Enter any data in subject field
    Enter all required details and then click on Next button
    Enter all required details in each tab
    Add files and references
    Click on Submit
    Open created case message
    On above created case message detail page, Click on Follow-On button
    Validate that All details on Follow-on Draft
    Enter Due Date and Response
    Submit, Verify and Log Final Result
