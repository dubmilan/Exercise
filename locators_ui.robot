*** Settings ***
Documentation     Locators for UI elements
... 
...               Notino eshop only.

Library           SeleniumLibrary


*** Variables ***
${COOKIES_ACCEPT_BTN}         xpath://div[@id="exponea-cookie-compliance"]//*[@class="ack exp-btn close"]
${CATEGORY_MEN}               xpath://div[@data-cypress="mainMenu-Men"] 
${SUBCATEGORY_RAZORS}         xpath://a[@href="/mens-razor/"]
${SORTING_COMBO}              xpath://div[@aria-label="Recommended"]
${PRICE_HIGH_TO_LOW}          xpath://div[@id="productListWrapper"]//div[text()="Price: High to Low"]
${PRODUCT}                    xpath://*[@data-product][INDEX_CHANGE_ME]
${PRODUCT_PRICE_CATEGORY}             xpath://*[@data-product][INDEX_CHANGE_ME]//span[1]                                         
${ADD_TO_BASKET_BTN}          pd-buy-button
${CONTINUE_TO_SHOPPING}       upsellingContinueWithShopping
${SHOPPING_BASKET_ICON}       xpath://a[@title="Shopping Basket"] 
${PRODUCT_PRICE_BASKET}     xpath:(//*[contains(@class, ' infoProduct')]/following-sibling::div[1]//span[1])[INDEX_CHANGE_ME]