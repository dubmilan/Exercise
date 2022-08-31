*** Settings ***
Documentation      API Testing of CRUD operations on Trello board

Resource          resource_api.robot


*** Test Cases ***
CRUD operations on Trello board
    Create New Board
    Verify Board Exist
    Update Board Name And Add Description
    Verify Board Updated
    Delete Board
    Verify Board Not Exists