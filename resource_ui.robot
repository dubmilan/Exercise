*** Settings ***
Documentation     A resource file with reusable keywords and variables
... 
...               Notino eshop only.

Library           SeleniumLibrary
Library           String
Library           Collections 
Resource          locators_ui.robot 


*** Variables ***
${SERVER}         notino.co.uk
${BROWSER}        Chrome
${DELAY}          0.1
${HOME URL}       http://${SERVER}/
${NUMBER OF TESTING PRODUCTS}    2                                        #defines how many products add to the basket
${MAXIMUM PRICE}                 1000000000                               
${NUMBER OF TESTING PRODUCTS INDEX}    ${${NUMBER OF TESTING PRODUCTS}+1} 


*** Keywords ***
Custom Click to Element
    [Documentation]    Custom method for click element
    [Arguments]    ${Locator}
    Wait Until Element Is Visible    ${Locator}
    Click Element    ${Locator}   

Custom Mouse Over to Element
    [Documentation]    Custom method for mouse over element
    [Arguments]    ${Locator}
    Wait Until Element Is Visible    ${Locator}
    Mouse Over    ${Locator} 

Open Testing Website
    Open Browser    ${HOME URL}     ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Accept cookies

Accept Cookies
    Custom Click to Element    ${COOKIES_ACCEPT_BTN}

Navigate to Testing Products Category
    Custom Mouse Over to Element    ${CATEGORY_MEN}
    Custom Click to Element    ${SUBCATEGORY_RAZORS}    

Sort Products by Price from High to Low
    Custom Click to Element    ${SORTING_COMBO}
    Custom Click to Element    ${PRICE_HIGH_TO_LOW}

Verify Products Are Sorted by Price from High to Low
    Set Test Variable    @{Products Price In Category}    ${MAXIMUM PRICE}
    FOR    ${i}    IN RANGE    1     ${NUMBER OF TESTING PRODUCTS INDEX}
        ${index}    Convert To String    ${i}
        Get Price of nth Product in Category    ${index}
        Should be True    ${Products Price In Category}[${i}] <= ${Products Price In Category}[${${i}-1}]
    END

Add Requested products to Basket
    [Documentation]    Add ${NUMBER OF TESTING PRODUCTS} Products to the basket
    Set Test Variable    @{Products Names In Category}    0
    FOR    ${i}    IN RANGE    1     ${NUMBER OF TESTING PRODUCTS INDEX}
        ${index}    Convert To String    ${i}
        Add Product to Basket    ${index}
    END  

Verify Products With Correct Price Are In The Basket
    Custom Click to Element    ${SHOPPING_BASKET_ICON}
    Set Test Variable    @{Products Price In Basket}      0    
    FOR    ${i}    IN RANGE    1     ${NUMBER OF TESTING PRODUCTS INDEX}
        ${index}    Convert To String    ${i}
        Get Price of nth Product in Basket    ${index}
        Should Be Equal    ${Products Price In Category}[${i}]   ${Products Price In Basket}[${i}]  
    END  

Click to nth Product
    [Documentation]    Click to nth product on category screen
    [Arguments]    ${index}

    ${loc}=    _Return Selenium Locator For nth Product    ${PRODUCT}    ${index}
    Custom Click to Element    ${loc}  


Add Product to Basket
    [Documentation]    Add product from category screen to the basket    
    [Arguments]    ${index}    
    Click to nth Product    ${index}
    Custom Click to Element    ${ADD_TO_BASKET_BTN}
    Custom Click to Element    ${CONTINUE_TO_SHOPPING}
    Go Back   

Get Price of nth Product in Category
    [Documentation]    Get price of nth product in category and save it for later use
    [Arguments]    ${index}
    ${loc}=    _Return Selenium Locator For nth Product    ${PRODUCT_PRICE_CATEGORY}    ${index} 
    ${Product Price}    Get Text    ${loc}
    ${Product Price n}    Convert To Number    ${Product Price}
    Append To List     ${Products Price In Category}    ${Product Price n} 
 
Get Price of nth Product in Basket
    [Documentation]    Get price of nth product in basket and save it for later use
    [Arguments]    ${index}
    ${loc}=    _Return Selenium Locator For nth Product    ${PRODUCT_PRICE_BASKET}    ${index} 
    ${Product Price}    Get Text    ${loc}
    ${Product Price n}    Convert To Number    ${Product Price}
    Append To List     ${Products Price In Basket}    ${Product Price n} 

_Return Selenium Locator For nth Product
    # I know this is not nice solution, but I am new in Robot and dont know how to easy replace index in xpath
    [Documentation]    Prepare exact locator for product by index
    [Arguments]    ${LOCATOR}    ${index}

    # change the placeholder with the actual product index
    ${loc}=    Replace String    ${LOCATOR}    INDEX_CHANGE_ME    ${index}
    Wait Until Element Is Visible    ${loc}
    Element Should Be Visible    ${loc}    message=Product does not exists ${index}

    [Return]    ${loc}
