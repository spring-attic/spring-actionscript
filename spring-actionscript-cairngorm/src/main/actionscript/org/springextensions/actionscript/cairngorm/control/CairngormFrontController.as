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
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.adobe.cairngorm.control.FrontController;

	import mx.managers.ISystemManager;
	import mx.modules.Module;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IllegalStateError;
	import org.as3commons.reflect.errors.ClassNotFoundError;
	import org.springextensions.actionscript.cairngorm.PendingCommandRegistry;
	import org.springextensions.actionscript.cairngorm.commands.CommandFactory;
	import org.springextensions.actionscript.cairngorm.commands.CommandProxy;
	import org.springextensions.actionscript.cairngorm.commands.DefaultCommandFactoryRegistry;
	import org.springextensions.actionscript.cairngorm.commands.ICommandFactory;
	import org.springextensions.actionscript.cairngorm.commands.ICommandFactoryRegistry;
	import org.springextensions.actionscript.cairngorm.commands.ICommandFactoryRegistryAware;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.module.IOwnerModuleAware;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * The <code>CairngormFrontController</code> extends Cairngorm's
	 * <code>FrontController</code> and adds the ability to pass in a command map to
	 * the constructor.
	 *
	 * <p>The object with the command definitions must have the following form:</p>
	 *
	 * <listing version="3.0">var commands:Object = {
	 *   "myFirstEvent": "com.domain.command.MyFirstCommand",
	 *   "mySecondEvent": "com.domain.command.MySecondCommand"
	 * };
	 *
	 * // instantiate a front controller and pass in the commands objects
	 * var controller:FrontController = new CairngormFrontController(commands);</listing>
	 *
	 * <p>...where the key in the <code>commands</code> object is the name of the
	 * event that the frontcontroller will listen to and the value is the
	 * fully qualified class name of the command that will be executed.</p>
	 *
	 * <p>Notice that the constructor takes a second optional argument specifying
	 * the package where the commands reside. By passing in this argument it is
	 * not needed to specify fully qualified classnames for the command classes.
	 * Only the classnames themselves need to be specified then.</p>
	 *
	 * <listing version="3.0">
	 * var commands:Object = {
	 *   "myFirstEvent": "MyFirstCommand",
	 *   "mySecondEvent": "MySecondCommand"
	 * };
	 *
	 * var controller:FrontController = new CairngormFrontController(commands, "com.domain.command");</listing>
	 *
	 * <p>The following is the xml definition of the <code>controller</code> instance:</p>
	 *
	 * <listing version="3.0"> &lt;object id="controller" class="org.springextensions.actionscript.ioc.util.CairngormFrontController">
	 *   &lt;constructor-arg>
	 *     &lt;object>
	 *       &lt;property name="myFirstEvent" value="MyFirstCommand"/>
	 *       &lt;property name="mySecondEvent" value="MySecondCommand"/>
	 *     &lt;/object>
	 *   &lt;/constructor-arg>
	 *   &lt;constructor-arg value="com.domain.command"/>
	 * &lt;/object>
	 * </listing>
	 *
	 * <p>Batch commands are also supported, to let multiple commands execute after a single event has been dispatched
	 * simply add more than one command with the same event:</p>
	 *
	 * <listing version="3.0"> &lt;object id="controller" class="org.springextensions.actionscript.ioc.util.CairngormFrontController">
	 *   &lt;constructor-arg>
	 *     &lt;object>
	 *       &lt;property name="myFirstEvent" value="MyFirstCommand"/>
	 *       &lt;property name="myFirstEvent" value="MySecondCommand"/>
	 *     &lt;/object>
	 *   &lt;/constructor-arg>
	 *   &lt;constructor-arg value="com.domain.command"/>
	 * &lt;/object>
	 * </listing>
	 *
	 * <p>To turn off this behavior set the <code>allowCommandBatches</code> property to false.</p>
	 *
	 * <p>It is possible to use the <code>CairngormFrontController</code> in a multi-module environment without events and commands
	 * getting mixed up between the different controllers.</p>
	 * <p>use the <code>register()</code> method to associate a <code>CairngormFrontController</code> instance with a module and
	 * make sure the <code>CairngormEvents</code> have their <code>bubbling</code> property set to <em>true</em> and that they
	 * are dispatched by an <code>IEventDispatcher</code> instance that is part of the UI event bubbling hierarchy.</p>
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @docref extensions-documentation.html#the_frontcontroller
	 */
	public class CairngormFrontController extends FrontController implements ICommandFactoryRegistryAware, IOwnerModuleAware, IApplicationContextAware {

		private static var _instance:CairngormFrontController;

		/**
		 * <p>Adds a trailing period character to the specified input string if it doesn't already have one.</p>
		 * <p>Input: "com.mypackages.classes.", output: "com.mypackages.classes."</p>
		 * <p>Input: "com.mypackages.classes", output: "com.mypackages.classes."</p>
		 * @param input the specified input string
		 * @return the converted output
		 *
		 */
		public static function addTrailingPeriod(input:String):String {
			if (input.length > 0) {
				if (input.charAt(input.length - 1) != '.') {
					input += '.';
				}
			}
			return input;
		}

		/**
		 * @return The current <code>CairngormFrontController</code> instance.
		 */
		public static function getInstance():CairngormFrontController {
			if (!_instance)
				_instance = new CairngormFrontController();
			return _instance;
		}

		/**
		 * Creates a new <code>CairngormFrontController</code> instance.
		 *
		 * @param commandMap an object containing key/value pairs with the event names and the command classes
		 * @param commandPackage the package where the commands reside
		 * @param commandFactoryRegistry an <code>ICommandFactoryRegistry</code> that can take care of the creation of <code>ICommands</code>
		 */
		public function CairngormFrontController(commandMap:Object = "", commandPackage:String = "", commandFactoryRegistry:ICommandFactoryRegistry = null) {
			_commandMap = commandMap;
			_commandPackage = commandPackage;
			_commandFactoryRegistry = commandFactoryRegistry;
			eventDispatcher = CairngormEventDispatcher.getInstance();
			init();
		}

		/**
		 * The eventDispatcher instance that is used to listen for <code>CairngormEvents</code> on. This can either be a <code>CairngormEventDispatcher</code>
		 * or a <code>ISystemManager</code> instance, depending on whether the current <code>CairngormFrontController</code> is associated with a module
		 * or not.
		 */
		protected var eventDispatcher:Object;

		private var _allowCommandBatches:Boolean = true;

		private var _commandFactoryRegistry:ICommandFactoryRegistry;

		private var _commandMap:Object;

		private var _commandPackage:String;

		private var _ownerModule:Module;
		/**
		 * @inheritDoc
		 */
		public function get ownerModule():Module {
			return _ownerModule;
		}

		/**
		 * @private
		 */
		public function set ownerModule(value:Module):void {
			if (value !== _ownerModule) {
				_ownerModule = value;
				registerModule(_ownerModule);
			}
		}

		private var _applicationContext:IApplicationContext;
		/**
		 * @private
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		/**
		 * @inheritDoc
		 */
		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		private var _throwCairngormErrors:Boolean = true;

		/**
		 * <p>Adds an extra check to see if the command class implements the <code>ICommand</code> interface.</p>
		 * @inheritDoc
		 */
		override public function addCommand(commandName:String, commandRef:Class, useWeakReference:Boolean = true):void {
			Assert.hasText(commandName, "commandName parameter must have text");
			Assert.notNull(commandRef, "The commandRef parameter cannot be null");

			validateCommandClass(commandRef);

			if (allowCommandBatches) {
				addBatchCommand(commandName, commandRef, useWeakReference);
			} else {
				addSingleCommand(commandName, commandRef, useWeakReference);
			}
		}

		public function addCommandIdentifier(commandName:String, commandRef:String, useWeakReference:Boolean = true):void {
			Assert.hasText(commandName, "commandName parameter must have text");
			Assert.notNull(commandRef, "The commandRef parameter cannot be null");
			if (allowCommandBatches) {
				addBatchCommand(commandName, commandRef, useWeakReference);
			} else {
				addSingleCommand(commandName, commandRef, useWeakReference);
			}
		}

		/**
		 * Adds a batch command.
		 */
		protected function addBatchCommand(commandName:String, commandRef:Object, useWeakReference:Boolean = true):void {
			switch (true) {
				// we don't have a batch command array yet
				// create an empty one and recall this method
				case(!commands[commandName]):
					commands[commandName] = [];
				// don't break here, but fall through to the array case

				// add new command to existing array of batch commands
				case(commands[commandName] is Array):
					// first batch command, listen for incoming command requests
					if (commands[commandName].length == 0) {
						eventDispatcher.addEventListener(commandName, executeCommands, false, 0, useWeakReference);
					}
					addToCommandArray(commands[commandName], commandRef);
					break;

				// remove the registered command
				// register it as a batch with the new command
				case(commands[commandName] is String):
				case(commands[commandName] is Class):
					commands[commandName] = [commands[commandName], commandRef];
					eventDispatcher.removeEventListener(commandName, executeCommand);
					eventDispatcher.addEventListener(commandName, executeCommands, false, 0, useWeakReference);
					break;

				// illegal state!
				default:
					throw new IllegalStateError("Illegal type '" + ClassUtils.forInstance(commands[commandName]) + "' found in commands dictionary. Only Class and Array are expected.");
			}
		}

		/**
		 * Adds a single command.
		 */
		protected function addSingleCommand(commandName:String, commandRef:Object, useWeakReference:Boolean = true):void {
			if (commands[commandName]) {
				if (throwCairngormErrors) {
					throw new CairngormError(CairngormMessageCodes.COMMAND_ALREADY_REGISTERED, commandName);
				}
			} else {
				commands[commandName] = commandRef;
				eventDispatcher.addEventListener(commandName, executeCommand, false, 0, useWeakReference);
			}
		}


		/**
		 * <p>Adds a new <code>ICommandFactory</code> instance to the current <code>CairngormFrontController</code> instance.</p>
		 * <p>The <code>ICommandFactory</code> gets added to the start of the list.</p>
		 * @param factory the new <code>ICommandFactory</code> instance.
		 */
		public function addCommandFactory(factory:ICommandFactory):void {
			_commandFactoryRegistry.addCommandFactory(factory);
		}

		/**
		 * When set to true the CairngormFrontController will allow multiple commands to be associated with
		 * a single event. When set to false this will generate an error.
		 * @default true
		 */
		public function get allowCommandBatches():Boolean {
			return _allowCommandBatches;
		}

		/**
		 * @private
		 */
		public function set allowCommandBatches(value:Boolean):void {
			_allowCommandBatches = value;
		}

		/**
		 * @inheritDoc
		 */
		public function set commandFactoryRegistry(value:ICommandFactoryRegistry):void {
			_commandFactoryRegistry = value;
		}

		/**
		 * An object containing key/value pairs with the event names and the command classes
		 */
		public function set commandMap(value:Object):void {
			_commandMap = value;
			initCommandMap();
		}

		/**
		 * Specifies the package where the commands reside. By setting this property it is
		 * not needed to specify fully qualified classnames for the command classes.
		 */
		public function get commandPackage():String {
			return _commandPackage;
		}

		/**
		 * @private
		 */
		public function set commandPackage(value:String):void {
			_commandPackage = value;
		}

		/**
		 * When the module parameter is not null the eventDispatcher that the current <code>CairngormFrontController</code> listens to
		 * is switched to the current <code>ISystemManager</code> instance. Otherwise <code>CairngormEventDispatcher.getInstance()</code>
		 * is used. After the appropriate IEventDispatcher has been chosen the <code>initCommandMap()</code> is invoked.
		 * @param module A Module instance or null
		 */
		protected function registerModule(module:Module):void {
			if (module != null) {
				//If the CairngormFrontController was created with constructor params then there's a chance
				//there are already eventlisteners placed on the CairngormEventDispatcher. That's why
				//we check and remove them
				if (eventDispatcher is CairngormEventDispatcher) {
					removeEventListeners();
					eventDispatcher = ApplicationUtils.application.systemManager;
				}
			} else {
				if (eventDispatcher is ISystemManager) {
					removeEventListeners();
				}
				eventDispatcher = CairngormEventDispatcher.getInstance();
			}
			addEventListeners();
		}

		/**
		 * If true the current <code>CairngormFrontController</code> will re-throw Cairngorm errors.
		 * @default true
		 */
		public function get throwCairngormErrors():Boolean {
			return _throwCairngormErrors;
		}

		/**
		 * @private
		 */
		public function set throwCairngormErrors(value:Boolean):void {
			_throwCairngormErrors = value;
		}

		/**
		 * @private
		 *
		 * Adds the passed Command to the Array of commands.
		 *
		 * @param commandArray The Array of Commands.
		 * @param commandRef The Command reference to add.
		 */
		protected function addToCommandArray(commandArray:Array, commandRef:Object):void {
			if (commandArray.indexOf(commandRef) > -1) {
				if (throwCairngormErrors) {
					throw new CairngormError("This command class: '{0}' has already been associated with the specified name", commandRef);
				}
			}
			else {
				commandArray[commandArray.length] = commandRef;
			}
		}

		/**
		 * <p>Creates the <code>ICommand</code> associated with the specified <code>CairngormEvent</code> instance and registers
		 * the command with the current <code>PendingCommandRegistry</code> instance.</p>
		 */
		protected function createAndExecuteCommand(commandIdent:Object, event:CairngormEvent):void {
			var cmd:ICommand = (commandIdent is Class) ? _commandFactoryRegistry.createCommand(Class(commandIdent)) : _applicationContext.getObject(String(commandIdent));

			var cmdProxy:CommandProxy = new CommandProxy(cmd);
			//cmdProxy.addEventListener("commandExecuted");
			PendingCommandRegistry.getInstance().register(cmd, event); // register the pending command
			cmdProxy.execute(event);
		}

		/**
		 * <p>True if module is not null and equal to the specified <code>target</code>, or always true when no module is associated with the current <code>CairngormFrontController</code>.</p>
		 * <p>Used by the <code>executeCommand()</code> method to determine whether a <code>Command</code> needs to be excecuted or not.
		 */
		protected function evaluateTarget(target:Object):Boolean {
			return (_ownerModule == null) ? true : (target === _ownerModule);
		}

		/**
		 * Retrieves the command name from the specified <code>CairngormEvent</code> instance and
		 * looks up the associated command class for it. With this class the <code>createAndExecuteCommand()</code> method
		 * is the invoked.
		 */
		override protected function executeCommand(event:CairngormEvent):void {
			if (evaluateTarget(event.target)) {
				var cmdClass:Object = getCommandIndentifier(event.type);
				//var cmd:ICommand = new cmdClass();
				// var cmd:ICommand = commandFactory.createCommand();
				createAndExecuteCommand(cmdClass, event);
			}
		}

		protected function getCommandIndentifier(commandName:String):Object
		{
			var commandIdent:Object = commands[ commandName ];

			if (commandIdent == null) {
				throw new CairngormError(CairngormMessageCodes.COMMAND_NOT_FOUND, commandName);
			}

			return commandIdent;
		}

		/**
		 * Retrieves the command name from the specified <code>CairngormEvent</code> instance and
		 * looks up the associated command list for it. With this list the <code>createAndExecuteCommand()</code> method
		 * is the invoked for each command class in the list.
		 */
		protected function executeCommands(event:CairngormEvent):void {
			if (evaluateTarget(event.target)) {
				var associatedCommands:Array = getCommands(event.type);
				for each (var commandRef:Object in associatedCommands) {
					createAndExecuteCommand(commandRef, event);
				}
			}
		}

		/**
		 * Retrieves the associated command list for the specified command name.
		 */
		protected function getCommands(commandName:String):Array {
			var commands:Array = commands[commandName] as Array;
			if (commands == null) {
				throw new CairngormError("Command batch not registered for {0}", commandName);
			}
			return commands;
		}

		/**
		 * Initializes the current <code>CairngormFrontController</code> instance.
		 * If the commandFactoryRegistry is null an instance of <code>DefaultCommandFactoryRegistry</code> is created.
		 */
		protected function init():void {
			if (_commandFactoryRegistry == null) {
				_commandFactoryRegistry = new DefaultCommandFactoryRegistry();
				_commandFactoryRegistry.addCommandFactory(new CommandFactory());
			}
			initCommandMap();
		}

		/**
		 * Loops through the commandMap, validates the command class and adds the commands by invoking <code>addCommand</code> for each item in the map.
		 */
		protected function initCommandMap():void {
			var commandPackage:String = _commandPackage;
			var commandClass:Class;

			commandPackage = addTrailingPeriod(commandPackage);

			// add all commands to the frontcontroller
			for (var commandName:String in _commandMap) {
				if ((_applicationContext == null) || (!_applicationContext.canCreate(commandName))) {
					try {
						commandClass = ClassUtils.forName(commandPackage + _commandMap[commandName]);
						addCommand(commandName, commandClass);
					} catch (e:ClassNotFoundError) {
						throw e;
					}
				} else {
					addCommandIdentifier(commandName, String(_commandMap[commandName]));
				}
			}
		}

		/**
		 * <p>Makes sure the right event listener is removed, depending on whether its a batch command or not.</p>
		 * @inheritDOc
		 */
		override public function removeCommand(commandName:String):void {
			Assert.notNull(commandName, "commandName argument must not be null");

			if ((commands[commandName] == null) && (_throwCairngormErrors)) {
				throw new CairngormError(CairngormMessageCodes.COMMAND_NOT_REGISTERED, commandName);
			}

			if (commands[commandName] is Array) {
				eventDispatcher.removeEventListener(commandName, executeCommands);
			} else {
				eventDispatcher.removeEventListener(commandName, executeCommand);
			}

			commands[commandName] = undefined;
			delete commands[commandName];
		}

		/**
		 * Removes all the event listeners from the current <code>eventDispatcher</code>.
		 */
		protected function removeEventListeners():void {
			if (eventDispatcher != null) {
				for (var commandName:String in commands) {
					if (eventDispatcher.hasEventListener(commandName)) {
						if (commands[commandName] is Array) {
							eventDispatcher.removeEventListener(commandName, executeCommands);
						} else {
							eventDispatcher.removeEventListener(commandName, executeCommand);
						}
					}
				}
			}
		}

		/**
		 * Adds all the event listeners to the current <code>eventDispatcher</code>.
		 */
		protected function addEventListeners():void {
			if (eventDispatcher != null) {
				for (var commandName:String in commands) {
					if (commands[commandName] is Array) {
						eventDispatcher.addEventListener(commandName, executeCommands, false, 0, true);
					} else {
						eventDispatcher.addEventListener(commandName, executeCommand, false, 0, true);
					}
				}
			}
		}

		/**
		 * Checks if the specified Class implements the <code>ICommand</code> interface, if not, an error is thrown.
		 * @throws com.adobe.cairngorm.CairngormError when specified Class does not implement the <code>ICommand</code> interface.
		 *
		 */
		protected function validateCommandClass(commandRef:Class):void {
			var implementsICommand:Boolean = ClassUtils.isImplementationOf(commandRef, ICommand);

			if (!implementsICommand)
				throw new CairngormError("The commandRef argument '{0}' should implement the ICommand interface", commandRef);

		}
	}
}
