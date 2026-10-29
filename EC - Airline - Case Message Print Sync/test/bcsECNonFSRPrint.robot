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
EC - Airline - Case Message Print Sync
# Prerequisite - have atleast one case message under 'my communication'
    Login to BCS Homepage
    On Case message detail page, Click on Print button
    Select any option from print popup and click on Print button
