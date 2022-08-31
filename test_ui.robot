*** Settings ***
Documentation     A test for adding product to the basket on notino eshop
Resource          resource_ui.robot


*** Test Cases ***
Add Product To Basket
    Open Testing Website
    Navigate to Testing Products Category
    Sort Products by Price from High to Low 
    Verify Products Are Sorted by Price from High to Low
    Add Requested products to Basket
    Verify Products With Correct Price Are In The Basket
    Compare Prices from Basket and SRP
    [Teardown]    Close Browser