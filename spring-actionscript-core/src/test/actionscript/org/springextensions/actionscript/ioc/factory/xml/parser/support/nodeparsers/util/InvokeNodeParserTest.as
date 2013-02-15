////////////////////////////////////////////////////////////////////////////////
//
//  Uitgeverij Deviant - Studiemeter
//  Copyright 2010 Uitgeverij Deviant
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////
package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util {

	import flexunit.framework.TestCase;
	import mx.resources.IResourceManager;
	
	import mx.managers.IPopUpManager;
	import mx.managers.PopUpManager;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.xml.UtilNamespaceHandler;

	public class InvokeNodeParserTest extends TestCase {

		private var xml:XML =
			<objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:messaging="http://www.springactionscript.org/schema/messaging" xmlns:util="http://www.springactionscript.org/schema/util" xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd	http://www.springactionscript.org/schema/messaging http://www.pranaframework.org/schema/messaging/spring-actionscript-messaging-1.0.xsd	http://www.springactionscript.org/schema/util http://www.pranaframework.org/schema/messaging/spring-actionscript-util-1.0.xsd">
				<util:invoke id="resourceManager" target-class="mx.resources.ResourceManager" target-method="getInstance"/>
			</objects>
			;

		private var xml2:XML =
			<objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:messaging="http://www.springactionscript.org/schema/messaging" xmlns:util="http://www.springactionscript.org/schema/util" xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd	http://www.springactionscript.org/schema/messaging http://www.pranaframework.org/schema/messaging/spring-actionscript-messaging-1.0.xsd	http://www.springactionscript.org/schema/util http://www.pranaframework.org/schema/messaging/spring-actionscript-util-1.0.xsd">
				<util:invoke id="popupManager" target-class="mx.core.Singleton" target-method="getInstance">
					<arg value="mx.managers::IPopUpManager"/>
				</util:invoke>
			</objects>
			;

		public function InvokeNodeParserTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testParse():void {
			var context:AbstractApplicationContext = new AbstractApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			parser.addNamespaceHandler(new UtilNamespaceHandler());
			parser.parse(xml);
			context.load();
			
			var resourceManager:IResourceManager = context.getObject("resourceManager");
			assertNotNull(resourceManager);
		}

		public function testParse_withTargetMethodArguments():void {
			var context:AbstractApplicationContext = new AbstractApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			parser.addNamespaceHandler(new UtilNamespaceHandler());
			parser.parse(xml2);
			context.load();
			
			//Damned manager needs to be declared once, otherwise the sngleton isn't initialized for some reason...
			PopUpManager;
			
			var popupManager:IPopUpManager = context.getObject("popupManager");
			assertNotNull(popupManager);
		}

	}
}