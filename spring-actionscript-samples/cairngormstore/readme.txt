Spring ActionScript enabled Cairngorm Store
===========================================

This is a modified Cairngorm Store based on Cairngorm version 2.2.1beta.

This example includes support for mockups - (no flex data services/java) and support for connecting to a PHP backend
using AMFPHP with Remote Objects. Different Business Delegates are used to specify whether mockups or Remote Objects are
used. The configuration of these Business Delegates is done in the application context (see application-context.xml). In
the case of Remote Objects, the ServiceLocator is also configured in the application context.

The following files have been added/changed in order to add Spring ActionScript configuration support for business delegates,
the service locator and the front controller:

* Main.mxml: added application context loader and forced compilation of configured classes

package com.adobe.cairngorm.samples.store.business
* BaseBusinessDelegateMock.as: implements IResponderAware, removed responder constructor argument
* CreditCardDelegate.as: extends AbstractRemoteObjectDelegaten, implements ICreditCardDelegate
* CreditCardDelegateMock.as: implements ICreditCardDelegate
* ICreditCardDelegate.as: interface for credit card delegates
* IProductDelegate.as: interface for product delegates
* ProductDelegate.as: extends AbstractRemoteObjectDelegate, implements IProductDelegate
* ProductDelegateMock.as: implements IProductDelegate

package com.adobe.cairngorm.samples.store.commands
* GetProductsCommand.as: added delegate constructor injection
* ValidateCreditCardCommand.as: added delegate constructor injection

package com.adobe.cairngorm.samples.store.control
* ShopController.as: added logic to inject constructor arguments (business delegates) into the generated commands


Credits / Modifications
=======================

This example is built on the existing Cairngorm Store by Adobe Consulting.

The php code was added by Renaun Erickson.

Modifications have been made by Chen Bekor and Douglas McCarroll

December 2006, by Chen Bekor:

**** in package com.adobe.cairngorm.samples.store.business **********************
1. Added class BaseBusinessDelegateMock - this class is a base class for all business delegate mockups.
2. Added classes ProductDelegateMock (for product fetching) and CreditCardDelegateMock (for credit card validation)

**** in package com.adobe.cairngorm.samples.store.command  **********************
3. changed class GetProductsCommand to call ProductDelegateMock
4. changed class ValidateCreditCardCommand to call CreditCardDelegateMock

**** in PaymentInformation.mxml  **************************************************
5. added a visa credit card number to pass basic mx validation :)

February 2008, by Douglas McCarroll

Updated for Cairngorm 2.2.1 and Flex 3. Details at http://www.brightworks.com/flex_ability/?p=61
