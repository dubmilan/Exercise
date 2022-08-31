*** Settings ***
Documentation      API Testing of CRUD operations on Trello board.

Resource          resource_api.robot


*** Test Cases ***
CRUD Operations on Trello Board
    Create New Board
    Verify Board Exist
    Update Board Name And Add Description
    Verify Board Updated
    Delete Board
    Verify Board Not Exists

CRUD Operations for Labels on Trello Board 
    Create New Board       
    Create Label on Existing Board
    Verify Label Exists with Correct Data
    Update Label Color
    Verify Label Color Updated and Nothing Else Changed
    Create Second Label on Existing Board    
    Delete First Label
    Verify First Label Deleted and Second Exist
    Delete Board
    Verify Both Labels Not Exists
    Verify Create Label on Not Existing Board Is Not Possible

Negative Test - Update Not Existing Board
    Update Not Existing Board
    Verify Board Not Exists         #PUT will not create new board    

Negative Test - Delete Not Existing Board
    Delete Not Existing Board
