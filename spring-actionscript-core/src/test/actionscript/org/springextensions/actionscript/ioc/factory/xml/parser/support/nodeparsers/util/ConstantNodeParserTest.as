package org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util {
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;
	import mx.logging.LogEventLevel;
	
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject;
	import org.springextensions.actionscript.ioc.factory.config.MethodInvokingFactoryObject;
	import org.springextensions.actionscript.ioc.factory.xml.UtilNamespaceHandler;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.config.MethodInvokingFactoryObject;

	//use namespace spring_actionscript_util;

	public class ConstantNodeParserTest extends TestCase {
		// please note that all test methods should start with 'test' and should be public

		{
			MethodInvokingFactoryObject;
			FieldRetrievingFactoryObject;
			LogEventLevel;
		}

		// Reference declaration for class to test
		private var classToTestRef:org.springextensions.actionscript.ioc.factory.xml.parser.support.nodeparsers.util.ConstantNodeParser;

		private var xml:XML =
			<objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:messaging="http://www.springactionscript.org/schema/messaging" xmlns:util="http://www.springactionscript.org/schema/util" xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd	http://www.springactionscript.org/schema/messaging http://www.pranaframework.org/schema/messaging/spring-actionscript-messaging-1.0.xsd	http://www.springactionscript.org/schema/util http://www.pranaframework.org/schema/messaging/spring-actionscript-util-1.0.xsd">
				<util:constant id="debugLevel" static-field="mx.logging.LogEventLevel.DEBUG"/>
			</objects>
			;

		private var xml2:XML =
			<objects xmlns="http://www.springactionscript.org/schema/objects" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:messaging="http://www.springactionscript.org/schema/messaging" xmlns:util="http://www.springactionscript.org/schema/util" xsi:schemaLocation="http://www.springactionscript.org/schema/objects http://www.pranaframework.org/schema/objects/spring-actionscript-objects-1.0.xsd	http://www.springactionscript.org/schema/messaging http://www.pranaframework.org/schema/messaging/spring-actionscript-messaging-1.0.xsd	http://www.springactionscript.org/schema/util http://www.pranaframework.org/schema/messaging/spring-actionscript-util-1.0.xsd">
				<object id="collection" class="mx.collections.ArrayCollection">
					<constructor-arg>
						<array>
							<util:constant id="debugLevel" static-field="mx.logging.LogEventLevel.DEBUG"/>
						</array>
					</constructor-arg>
				</object>
			</objects>
			;

		public function ConstantNodeParserTest(methodName:String = null) {
			//TODO: implement function
			super(methodName);
		}

		//This method will be called before every test function
		override public function setUp():void {
			//TODO: implement function
			super.setUp();
		}

		//This method will be called after every test function
		override public function tearDown():void {
			//TODO: implement function
			super.tearDown();
		}

		public function testParse_withRootNode():void {
			var context:IApplicationContext = new AbstractApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			parser.addNamespaceHandler(new UtilNamespaceHandler());
			//var nodeParser:ConstantNodeParser = new ConstantNodeParser();
			parser.parse(xml);

			//var definition:IObjectDefinition = factory.getObjectDefinition("debugLevel");
			var debugLevel:int = context.getObject("debugLevel");

			assertEquals(LogEventLevel.DEBUG, debugLevel);
		}

		public function testParse_withNestedNode():void {
			var context:IApplicationContext = new AbstractApplicationContext();
			var parser:XMLObjectDefinitionsParser = new XMLObjectDefinitionsParser(context);
			parser.addNamespaceHandler(new UtilNamespaceHandler());
			parser.parse(xml2);

			//var definition:IObjectDefinition = factory.getObjectDefinition("debugLevel");
			var collection:ArrayCollection = context.getObject("collection");

			assertNotNull(collection);
			assertEquals(1, collection.length);
			assertEquals(LogEventLevel.DEBUG, collection[0]);
		}

	}
}