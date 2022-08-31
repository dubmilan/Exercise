*** Settings ***
Documentation      A resource file with reusable keywords and variables for API Trello
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections


*** Variables ***
${SERVER}        https://api.trello.com
${BOARD NAME}    MyBoard
${NEW BOARD NAME}    Updated Name Board
${ADDED DESCRIPTION}    For Testing Purpose
${KEY}          9b93c3a3908dc404872d91be60760432
${TOKEN}        bea3c52af02c7a351e57cb1ddceadcc3619099ed087e4653a11859ed350d6d54


*** Keywords ***
Create New Board
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary  name=${BOARD NAME}    key=${KEY}    token=${TOKEN}
    ${response}=  POST On Session  trello_session  /1/boards/  data=${body}
    ${id}=  Get Value From Json  ${response.json()}  id  
    ${id}=  Get From List   ${id}  0
    Set Suite Variable    ${BOARD ID}     ${id}   
    Status Should Be  200  ${response} 
    ${name}=  Get Name of Dashboard from Response    ${response}
    Should be Equal    ${BOARD NAME}    ${name}

Get Board
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    &{header}=  Create Dictionary  Content-Type=application/json
    ${response}=  GET On Session  trello_session  /1/boards/${BOARD ID}  data=${body}    expected_status=any
    [Return]    ${response}

Verify Board Exist
    ${response}=    Get Board
    Status Should Be  200  ${response} 
    ${name}=  Get Name of Dashboard from Response    ${response}
    Should be Equal    ${BOARD NAME}    ${name}     
  
Update Board Name And Add Description
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}    name=${NEW BOARD NAME}    desc=${ADDED DESCRIPTION}
    ${response}=  PUT On Session  trello_session  /1/boards/${BOARD ID}  data=${body}
    Status Should Be  200  ${response} 
    ${name}=  Get Name of Dashboard from Response    ${response}
    ${desc}=  Get Description of Dashboard from Response    ${response}    
    Should be Equal    ${NEW BOARD NAME}    ${name} 
    Should be Equal    ${ADDED DESCRIPTION}    ${desc} 

Verify Board Updated
    ${response}=    Get Board
    Status Should Be  200  ${response} 
    ${name}=  Get Name of Dashboard from Response    ${response}
    ${desc}=  Get Description of Dashboard from Response    ${response}      
    Should be Equal    ${NEW BOARD NAME}    ${name}
    Should be Equal    ${ADDED DESCRIPTION}    ${desc}         

Delete Board
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    ${response}=  DELETE On Session  trello_session  /1/boards/${BOARD ID}  data=${body}
    Status Should Be  200  ${response} 

Verify Board Not Exists
    ${response}=    Get Board
    Status Should Be  404  ${response}   

Get Name of Dashboard from Response
    [Arguments]    ${response}
    ${name}=  Get Value From Json  ${response.json()}  name 
    ${name}=  Get From List   ${name}  0   
    [Return]     ${name}  

Get Description of Dashboard from Response
    [Arguments]    ${response}
    ${desc}=  Get Value From Json  ${response.json()}  desc 
    ${desc}=  Get From List   ${desc}  0   
    [Return]     ${desc}  

