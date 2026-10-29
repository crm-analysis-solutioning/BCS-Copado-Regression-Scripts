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
 EC - FSR - Case Message Create
    Login to BCS Homepage
    Validate following tabs should be present on homepage: Multi Operator Messages, Templates, Print Tasks
    Click on Create A Case button
    Select any account from the dropdown and enter other required details and click on Next button
    On Draft page _ Go to Affected Airplanes section and click on Add Airplanes button    
    Validate in My Companys Planes tab only airplanes_assets belongs to the selected account code are visible and other company airplanes_assets are not visible for selection
    Enter all required details and submit the draft case message
    Validate BMN number generated on created case_case message