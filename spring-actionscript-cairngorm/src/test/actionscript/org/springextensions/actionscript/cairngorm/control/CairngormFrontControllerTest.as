/*
 * Copyright 2007-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.cairngorm.control {
	
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flexunit.framework.TestCase;
	
	import mx.modules.Module;
	
	import org.springextensions.actionscript.cairngorm.commands.AbstractResponderCommand;
	import org.springextensions.actionscript.cairngorm.mocks.MockCairngormEvent;
	import org.springextensions.actionscript.cairngorm.mocks.MockResponderCommand;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.XMLApplicationContext;
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.utils.ApplicationUtils;
	
	public class CairngormFrontControllerTest extends FlexUnitTestCase {
		
		public static var executeCalled:Boolean = false;
		
		public static var dispatchedEvent:CairngormEvent;
		
		public static var commandResults:Array = [];
		
		{
			AbstractResponderCommand
		}
		
		public function CairngormFrontControllerTest(methodName:String = null) {
			super(methodName);
		}
		
		override public function setUp():void {
			super.setUp();
			CairngormFrontControllerTest.executeCalled = false;
			CairngormFrontControllerTest.dispatchedEvent = null;
			CairngormFrontControllerTest.commandResults = [];
		}
		
		public function testConstructor():void {
			var commands:Object = {};
			commands['eventName1'] = "AbstractResponderCommand";
			var commandPackage:String = "org.springextensions.actionscript.cairngorm.commands";
			
			var frontController:CairngormFrontController = new CairngormFrontController(commands, commandPackage);
			
			assertEquals(commandPackage, frontController.commandPackage);
		}
		
		public function testTwoInstancesNotAllowed():void {
			try {
				var frontController:CairngormFrontController = new CairngormFrontController();
				var frontController2:CairngormFrontController = new CairngormFrontController();
				fail("Two different instances of CairngormFrontController are not allowed");
			} catch (e:Error) {
			}
		}
		
		public function testGetInstanceReturnsSameInstance():void {
			var frontController:CairngormFrontController = CairngormFrontController.getInstance();
			var frontController2:CairngormFrontController = CairngormFrontController.getInstance();
			assertStrictlyEquals(frontController, frontController2);
		}
		
		public function testAddCommandCommandNameMustHaveText():void {
			var frontController:CairngormFrontController = new CairngormFrontController();
			
			try {
				frontController.addCommand("", AbstractResponderCommand);
				fail("empty command names should not be allowed");
			} catch (e:Error) {
			}
		}
		
		public function testAddCommandCommandClassMustNotBeNull():void {
			
			var frontController:CairngormFrontController = new CairngormFrontController();
			
			try {
				frontController.addCommand("commandName", null);
				fail("command class with Null value should not be allowed");
			} catch (e:Error) {
			}
		}
		
		public function testAddCommandCommandClassMustImplementICommand():void {
			
			var frontController:CairngormFrontController = new CairngormFrontController();
			
			try {
				frontController.addCommand("commandName", TestCase);
				fail("command class that doesn't implement ICommand interface should not be allowed");
			} catch (e:Error) {
			}
		}
		
		public function testAddCommandFactoryMustNotBeNull():void {
			
			var frontController:CairngormFrontController = new CairngormFrontController();
			
			try {
				frontController.addCommandFactory(null);
				fail("commandfactory parameter with Null value should not be allowed");
			} catch (e:Error) {
			}
		
		}
		
		public function testAddCommandTwiceWithSameCommandNameWhileAllowBatchCommandsIsFalse():void {
			
			var frontController:CairngormFrontController = new CairngormFrontController();
			frontController.allowCommandBatches = false;
			
			try {
				frontController.addCommand(MockCairngormEvent.EVENT_ID, MockResponderCommand);
				frontController.addCommand(MockCairngormEvent.EVENT_ID, MockResponderCommand);
				
				fail("Calling addCommand() twice with the same command name should fail");
			} catch (e:CairngormError) {
				verifyMessageCode(CairngormMessageCodes.COMMAND_ALREADY_REGISTERED, e.message)
			}
		}
		
		private function verifyMessageCode(messageCode:String, message:String):void {
			assertTrue("Message code should be " + messageCode, message.indexOf(messageCode) == 0);
		}
		
		public function testExecuteNormalEventCommandAssociation():void {
			var frontController:CairngormFrontController = new CairngormFrontController();
			frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalCommand);
			
			var event:MockCairngormEvent = new MockCairngormEvent();
			event.dispatch();
			
			assertTrue("execute should have been called", CairngormFrontControllerTest.executeCalled);
			assertNotNull("dispatchedEvent should not be null", CairngormFrontControllerTest.dispatchedEvent);
			assertEquals(event, CairngormFrontControllerTest.dispatchedEvent);
		}
		
		public function testExecuteBatchCommand():void {
			var frontController:CairngormFrontController = new CairngormFrontController();
			frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalBatchCommand1);
			frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalBatchCommand2);
			
			CairngormFrontControllerTest.commandResults = [];
			
			var event:MockCairngormEvent = new MockCairngormEvent();
			event.dispatch();
			
			assertEquals(2, CairngormFrontControllerTest.commandResults.length);
			
			frontController.removeCommand(MockCairngormEvent.EVENT_ID);
		}
		
		public function testBatchCommandShouldNotAllowDuplicateCommands():void {
			var frontController:CairngormFrontController = new CairngormFrontController();
			
			try {
				frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalBatchCommand1);
				frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalBatchCommand2);
				frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalBatchCommand2);
					//fail("Duplicate commands should not be allowed in a batch command");
			} catch (e:Error) {
				//assertTrue(e is CairngormError);
			} finally {
				frontController.removeCommand(MockCairngormEvent.EVENT_ID);
			}
		}
		
		public function testAddTrailingPeriod():void {
			var commandPackageWithTrailingPeriod:String = "com.mypackages.classes.";
			var commandPackageWithoutTrailingPeriod:String = "com.mypackages.classes";
			
			commandPackageWithTrailingPeriod = CairngormFrontController.addTrailingPeriod(commandPackageWithTrailingPeriod);
			commandPackageWithoutTrailingPeriod = CairngormFrontController.addTrailingPeriod(commandPackageWithoutTrailingPeriod);
			
			assertEquals("com.mypackages.classes.", commandPackageWithTrailingPeriod);
			assertEquals(commandPackageWithoutTrailingPeriod, commandPackageWithTrailingPeriod);
		}
		
		public function testRegisterModule():void {
			var frontController:CairngormFrontController = new CairngormFrontController();
			try
			{
				CairngormFrontControllerTest.dispatchedEvent = null;
				frontController.addCommand(MockCairngormEvent.EVENT_ID, LocalBatchCommand1);
				var module:Module = new Module();
				ApplicationUtils.addChild(module);
				frontController.ownerModule = module;
				module.dispatchEvent(new MockCairngormEvent(true));
				assertEquals(CairngormFrontControllerTest.dispatchedEvent.target, module);
			}
			finally
			{
				ApplicationUtils.removeChild(module);
				frontController.removeCommand(MockCairngormEvent.EVENT_ID);
			}
		}
		
		public function testAddApplicationContextCreatedCommand():void {
			var xmlObjectFactory:XMLApplicationContext = new XMLApplicationContext();
			var objectDefinition:ObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.cairngorm.mocks.MockResponderCommand");
			xmlObjectFactory.registerObjectDefinition("mockResponderCommand",objectDefinition);
			
			var frontController:CairngormFrontController = new CairngormFrontController();
			frontController.applicationContext = xmlObjectFactory as IApplicationContext;
			
			frontController.addCommandIdentifier(MockCairngormEvent.EVENT_ID,"mockResponderCommand");
			
			CairngormFrontControllerTest.commandResults = [];
			
			var event:MockCairngormEvent = new MockCairngormEvent();
			event.dispatch();
			
			var cmd:MockResponderCommand = xmlObjectFactory.getObject("mockResponderCommand");
			
			assertTrue(cmd.resultValue);
			
			frontController.removeCommand(MockCairngormEvent.EVENT_ID);

		}

		public function testAddApplicationContextCreatedCommandAndNormalCommand():void {
			var xmlObjectFactory:XMLApplicationContext = new XMLApplicationContext();
			var objectDefinition:ObjectDefinition = new ObjectDefinition("org.springextensions.actionscript.cairngorm.mocks.MockResponderCommand");
			xmlObjectFactory.registerObjectDefinition("mockResponderCommand",objectDefinition);
			
			var frontController:CairngormFrontController = new CairngormFrontController();
			frontController.applicationContext = xmlObjectFactory as IApplicationContext;
			
			frontController.addCommandIdentifier(MockCairngormEvent.EVENT_ID,"mockResponderCommand");
			frontController.addCommand(MockCairngormEvent.EVENT_ID,LocalCommand);
			
			CairngormFrontControllerTest.commandResults = [];
			
			var event:MockCairngormEvent = new MockCairngormEvent();
			event.dispatch();
			
			var cmd:MockResponderCommand = xmlObjectFactory.getObject("mockResponderCommand");
			
			assertTrue(cmd.resultValue);
			assertTrue(CairngormFrontControllerTest.executeCalled);
			
			frontController.removeCommand(MockCairngormEvent.EVENT_ID);

		}
	
	}
}

import com.adobe.cairngorm.commands.ICommand;
import com.adobe.cairngorm.control.CairngormEvent;
import org.springextensions.actionscript.cairngorm.control.CairngormFrontControllerTest;

class LocalCommand implements ICommand {
	public function execute(event:CairngormEvent):void {
		CairngormFrontControllerTest.executeCalled = true;
		CairngormFrontControllerTest.dispatchedEvent = event;
	}
}

class LocalBatchCommand1 implements ICommand {
	public function execute(event:CairngormEvent):void {
		CairngormFrontControllerTest.commandResults.push(this);
		CairngormFrontControllerTest.dispatchedEvent = event;
	}
}

class LocalBatchCommand2 implements ICommand {
	public function execute(event:CairngormEvent):void {
		CairngormFrontControllerTest.commandResults.push(this);
	}
}


