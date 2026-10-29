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
# Prerequisite 
# loadview user 1 should have email set as : 'donotdelete.copadotestuser@boeing.com'
# Also it should be in 2nd row when selecting contact in step 4
EC - Airline - Case Message Forward
    Login to BCS Homepage
    Search a x01C case message
    Click on forward button present on case message detail page
    Search any contact by using email address and then select the required contact and click on Next
    Click on Finish
    #Check mail of the user to which case message has been forwarded