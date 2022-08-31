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
${LABEL NAME}        Testing Label
${LABEL COLOR}        blue
${NEW LABEL COLOR}     green
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
    ${name}=  Get Value from Response    ${response}    name
    Should be Equal    ${BOARD NAME}    ${name}

Get Board
    [Arguments]    ${id}
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    &{header}=  Create Dictionary  Content-Type=application/json
    ${response}=  GET On Session  trello_session  /1/boards/${id}  data=${body}    expected_status=any
    [Return]    ${response}

Verify Board Exist
    ${response}=    Get Board    ${BOARD ID}
    Status Should Be  200  ${response} 
    ${name}=  Get Value from Response    ${response}    name
    Should be Equal    ${BOARD NAME}    ${name}     
  
Update Board Name And Add Description
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}    name=${NEW BOARD NAME}    desc=${ADDED DESCRIPTION}
    ${response}=  PUT On Session  trello_session  /1/boards/${BOARD ID}  data=${body}
    Status Should Be  200  ${response} 
    ${name}=  Get Value from Response    ${response}    name
    ${desc}=  Get Value from Response    ${response}    desc    
    Should be Equal    ${NEW BOARD NAME}    ${name} 
    Should be Equal    ${ADDED DESCRIPTION}    ${desc} 

Verify Board Updated
    ${response}=    Get Board    ${BOARD ID}
    Status Should Be  200  ${response} 
    ${name}=  Get Value from Response    ${response}    name
    ${desc}=  Get Value from Response    ${response}    desc    
    Should be Equal    ${NEW BOARD NAME}    ${name}
    Should be Equal    ${ADDED DESCRIPTION}    ${desc}         

Delete Board
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    ${response}=  DELETE On Session  trello_session  /1/boards/${BOARD ID}  data=${body}
    Status Should Be  200  ${response} 

Verify Board Not Exists
    ${response}=    Get Board    ${BOARD ID}
    Status Should Be  404  ${response}   

Get Value from Response
    [Arguments]    ${response}    ${par}
    ${desc}=  Get Value From Json  ${response.json()}  ${par} 
    ${desc}=  Get From List   ${desc}  0   
    [Return]     ${desc}      

Delete Not Existing Board
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    ${response}=  DELETE On Session  trello_session  /1/boards/1  data=${body}    expected_status=400
    Status Should Be  400  ${response} 

Update Not Existing Board
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}    name=${NEW BOARD NAME}    desc=${ADDED DESCRIPTION}
    ${response}=  PUT On Session  trello_session  /1/boards/  data=${body}    expected_status=404


Create Label
    [Arguments]    ${board id}
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary  name=${LABEL NAME}    color=${LABEL COLOR}    key=${KEY}    token=${TOKEN}
    ${response}=  POST On Session  trello_session  /1/boards/${board id}/labels  data=${body}    expected_status=any 
    [Return]     ${response}   
           
    
Create Label on Existing Board    
    ${response}=  Create Label    ${BOARD ID}    
    Status Should Be  200  ${response}
    ${id}=  Get Value From Json  ${response.json()}  id  
    ${id}=  Get From List   ${id}  0
    Set Suite Variable    ${LABEL ID}     ${id}      
    ${name}=  Get Value from Response    ${response}    name    
    ${color}=  Get Value from Response    ${response}    color    
    Should be Equal    ${LABEL NAME}    ${name}
    Should be Equal    ${LABEL Color}    ${color}   


Create Second Label on Existing Board    
    ${response}=  Create Label    ${BOARD ID}    
    Status Should Be  200  ${response}
    ${id}=  Get Value From Json  ${response.json()}  id  
    ${id}=  Get From List   ${id}  0
    Set Suite Variable    ${NEW LABEL ID}     ${id}      

Delete First Label
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    ${response}=  DELETE On Session  trello_session  /1/labels/${LABEL ID}  data=${body}
    Status Should Be  200  ${response}     

Verify First Label Deleted and Second Exist
    ${response}=  Get Label of Board    ${NEW LABEL ID} 
    Status Should Be  200  ${response} 
    ${response}=  Get Label of Board    ${LABEL ID} 
    Status Should Be  404  ${response}     
        
Update Label Color
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary  name=${LABEL NAME}    color=${NEW LABEL COLOR}    key=${KEY}    token=${TOKEN}
    ${response}=  PUT On Session  trello_session  /1/labels/${LABEL ID}/  data=${body}
    Status Should Be  200  ${response} 
    
Verify Label Color Updated and Nothing Else Changed
    ${response}=  Get Label of Board    ${LABEL ID} 
    Status Should Be  200  ${response}
    ${name}=  Get Value from Response    ${response}    name    
    ${color}=  Get Value from Response    ${response}    color  
    ${id}=  Get Value from Response    ${response}    id    
    ${idBoard}=  Get Value from Response    ${response}    idBoard       
    Should be Equal    ${LABEL NAME}    ${name}
    Should be Equal    ${NEW LABEL Color}    ${color}   
    Should be Equal    ${LABEL ID}    ${id}
    Should be Equal    ${BOARD ID}    ${idBoard}   

Verify Create Label on Not Existing Board Is Not Possible
    ${response}=  Create Label    1    
    Status Should Be  400  ${response}

Get Label of Board
    [Arguments]    ${label id}
    Create Session  trello_session  ${SERVER}    verify=true 
    &{body}=  Create Dictionary    key=${KEY}    token=${TOKEN}
    &{header}=  Create Dictionary  Content-Type=application/json
    ${response}=  GET On Session  trello_session  /1/labels/${label id}/  data=${body}    expected_status=any
    [Return]    ${response}

Verify Label Exists with Correct Data
    ${response}=  Get Label of Board    ${LABEL ID} 
    Status Should Be  200  ${response}
    Check Label Response Contains Correct data    ${response}


Verify Both labels Not Exists
    ${response}=  Get Label of Board    ${LABEL ID} 
    Status Should Be  404  ${response}
    ${response}=  Get Label of Board    ${NEW LABEL ID} 
    Status Should Be  404  ${response}    

Check Label Response Contains Correct data
    [Arguments]    ${response}
    ${name}=  Get Value from Response    ${response}    name    
    ${color}=  Get Value from Response    ${response}    color  
    ${id}=  Get Value from Response    ${response}    id    
    ${idBoard}=  Get Value from Response    ${response}    idBoard       
    Should be Equal    ${LABEL NAME}    ${name}
    Should be Equal    ${LABEL Color}    ${color}   
    Should be Equal    ${LABEL ID}    ${id}
    Should be Equal    ${BOARD ID}    ${idBoard}         