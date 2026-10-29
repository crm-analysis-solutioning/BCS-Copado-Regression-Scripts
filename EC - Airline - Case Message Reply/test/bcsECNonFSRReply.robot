*** Settings ***
Documentation           EC - Non FSR - Case Message Reply
Library                 QForce
Library                 OperatingSystem
Library                 QWeb
Library                 String
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers
Library                 BuiltIn
Resource                ../resources/reuseableFunctions.robot

*** Test Cases ***
EC - Airline - Case Message Reply
    Login to SC BCS Homepage
    Check If Tab Exist
    Case Message Creation
    Login to BCS Homepage
    Search a xB case message and open it
    Click on Reply
    Enter all mandatory fields and click on Submit
    Validate the status of xC message created