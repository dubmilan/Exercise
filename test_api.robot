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

# Splitted full scenario to 3 TCs
Create new Board
    Create New Board
    Verify Board Exist

Update Existing Board
    Update Board Name And Add Description
    Verify Board Updated

Delete Board
    Delete Board
    Verify Board Not Exists