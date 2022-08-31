*** Settings ***
Documentation      API Testing of CRUD operations on Trello board.

Resource          resource_api.robot


*** Test Cases ***
CRUD operations on Trello board
# Full scenario
    Create New Board
    Verify Board Exist
    Update Board Name And Add Description
    Verify Board Updated
    Delete Board
    Verify Board Not Exists

Negative Test - Update Not Existing Board
    Update Not Existing Board
    Verify Board Not Exists         #PUT will not create new board    

Negative Test - Delete Not Existing Board
    Delete Not Existing Board
