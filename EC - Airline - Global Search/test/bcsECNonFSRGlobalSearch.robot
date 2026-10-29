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
EC - Airline - Global Search
    Login to BCS Homepage
    Search CASEMSG1_CASE1 by entering Message number and BMN respectively in global search
    Search COOR1_RESP1 in global search
    Search SUP_CASEMSG1
