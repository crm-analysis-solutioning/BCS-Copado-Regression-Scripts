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
EC - Airline - Case Message Creation and Print Async
    Login to Experience cloud with customer account
    Navigate to homepage and create new case message
    Populate Subject, Description, Desired Action and Service Category fields and click next button
    Populate all required fields and add files of various supported formats and references and submit the case message
    Open created case message and click on Print button
    Click Print button on popup
    Repeat Step 5 for validating Attachment(s) in Print Popup
    Verify Direct Download Toggle
    Navigate to homepage and click print tasks (if Direct Download was toggled off)
    Validate print functionality all other radio buttons present in modal (Attachment(s), Show All Related Case Message(s), Message(s) & Attachment(s), and Custom)
    Navigate to homepage and click print tasks