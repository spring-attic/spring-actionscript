/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springextensions.actionscript.mvc.impl {

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.mvc.IController;
	import org.springextensions.actionscript.mvc.event.ControllerEvent;
	import org.springextensions.actionscript.mvc.event.ControllerRegistrationEvent;
	import org.springextensions.actionscript.mvc.event.MVCEvent;

	/**
	 * Dispatched when a command object is registered with the current <code>Controller</code>.
	 * @eventType org.springextensions.actionscript.core.mvc.event.ControllerRegistrationEvent.COMMAND_REGISTERED
	 */
	[Event(name="controllerCommandRegistered", type="org.springextensions.actionscript.mvc.event.ControllerRegistrationEvent")]
	/**
	 * Dispatched before a command object is invoked by the current <code>Controller</code>.
	 * @eventType org.springextensions.actionscript.core.mvc.event.ControllerEvent.BEFORE_COMMAND_EXECUTED
	 */
	[Event(name="controllerBeforeCommandExecuted", type="org.springextensions.actionscript.mvc.event.ControllerEvent")]
	/**
	 * Dispatched after a command object was invoked by the current <code>Controller</code>.
	 * @eventType org.springextensions.actionscript.core.mvc.event.ControllerEvent.AFTER_COMMAND_EXECUTED
	 */
	[Event(name="controllerAfterCommandExecuted", type="org.springextensions.actionscript.mvc.event.ControllerEvent")]
	/**
	 * <p><code>IController</code> implementation that uses an <code>IApplicationContext</code> instance
	 * as its command factory.</p>
	 * @inheritDoc
	 */
	public class Controller extends EventDispatcher implements IController, IApplicationContextAware {

		private static const LOGGER:ILogger = getClassLogger(Controller);

		private var _document:Object;
		private var _eventTypeRegistry:Dictionary;
		private var _eventClassRegistry:Dictionary;

		/**
		 * If <code>true</code> events dispatched by the current <code>Controller</code> will also be
		 * dispatched through the assigned <code>IEventBus</code> instance.
		 * @default true
		 */
		public var eventBusDispatching:Boolean = true;

		/**
		 * Creates a new <code>CommandRegistry</code> instance.
		 */
		public function Controller() {
			super();
			init();
		}

		/**
		 * Initializes the current <code>Controller</code>
		 */
		protected function init():void {
			clear();
		}

		private var _eventBus:IEventBus;

		/**
		 * The <code>IEventBus</code> instance that is used to register and listen for events.
		 */
		public function get eventBus():IEventBus {
			return _eventBus;
		}

		/**
		 * @private
		 */
		public function set eventBus(value:IEventBus):void {
			if (_eventBus != null) {
				removeListeners(_eventBus);
			}
			_eventBus = value;
			if (_eventBus != null) {
				addListeners(_eventBus);
			}
		}

		private var _applicationContext:IApplicationContext;

		/**
		 * The <code>IApplicationContext</code> instance that is used as a command factory.
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		/**
		 * @private
		 */
		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		/**
		 * @inheritDoc
		 */
		public function clear():void {
			_eventTypeRegistry = new Dictionary();
			_eventClassRegistry = new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		public function registerCommandForEventType(eventType:String, commandName:String, executeMethodName:String, properties:Vector.<String>=null, priority:uint=0):void {
			Assert.hasText(eventType, "eventType argument must not be null or empty");
			Assert.hasText(commandName, "commandName argument must not be null or empty");
			Assert.hasText(executeMethodName, "executeMethodName argument must not be null or empty");
			LOGGER.debug("command {0} registered for event type {1} with execute method {2} and priority {3}", [commandName, eventType, executeMethodName, priority]);
			var reg:CommandRegistration = new CommandRegistration(commandName, executeMethodName, properties, priority);

			var arr:Vector.<CommandRegistration> = _eventTypeRegistry[eventType] ||= new Vector.<CommandRegistration>();

			arr[arr.length] = reg;

			dispatchEvent(new ControllerRegistrationEvent(reg, eventType));
		}

		/**
		 * @inheritDoc
		 */
		public function registerCommandForEventClass(eventClass:Class, commandName:String, executeMethodName:String, properties:Vector.<String>=null, priority:uint=0):void {
			Assert.notNull(eventClass, "eventClass argument must not be null");
			Assert.notNull(eventClass, "commandName argument must not be null or empty");
			Assert.hasText(executeMethodName, "executeMethodName argument must not be null or empty");
			LOGGER.debug("command {0} registered for event class {1} with execute method {2} and priority {3}", [commandName, eventClass, executeMethodName, priority]);
			var reg:CommandRegistration = new CommandRegistration(commandName, executeMethodName, properties, priority);

			var arr:Vector.<CommandRegistration> = _eventClassRegistry[eventClass] ||= new Vector.<CommandRegistration>();

			arr[arr.length] = reg;

			dispatchEvent(new ControllerRegistrationEvent(reg, "", eventClass));
		}

		private var _failOnCommandNotFound:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function get failOnCommandNotFound():Boolean {
			return _failOnCommandNotFound;
		}

		/**
		 * @private
		 */
		public function set failOnCommandNotFound(value:Boolean):void {
			_failOnCommandNotFound = value;
		}

		/**
		 * Removes the <code>onMVCEventHandler</code> event handler from the specified <code>IEventBus</code>
		 * @param eventBus The specified <code>IEventBus</code>
		 */
		protected function removeListeners(eventBus:IEventBus):void {
			Assert.notNull(eventBus, "eventBus argument must not be null");
			eventBus.removeEventClassListener(MVCEvent, onMVCEventHandler);
		}

		/**
		 * Adds the <code>onMVCEventHandler</code> event handler to the specified <code>IEventBus</code>
		 * @param eventBus The specified <code>IEventBus</code>
		 */
		protected function addListeners(eventBus:IEventBus):void {
			Assert.notNull(eventBus, "eventBus argument must not be null");
			eventBus.addEventClassListener(MVCEvent, onMVCEventHandler);
		}

		/**
		 * Finds the <code>CommandRegistrations</code> that are associated with the specified <code>MVCEvent</code>,
		 * creates instances for the commands and executes them.
		 * @param event The specified <code>MVCEvent</code>.
		 * @see org.springextensions.actionscript.core.mvc.support.CommandRegistration CommandRegistration
		 */
		public function onMVCEventHandler(event:MVCEvent):void {
			Assert.notNull(event, "event argument must not be null");
			if (event.document === _document) {
				LOGGER.debug("Handling MVCEvent {0}", [event]);
				var registrations:Vector.<CommandRegistration> = findCommandRegistrations(event.event);
				if (registrations != null) {
					//Sort the commands with the highest priority on top:
					//registrations.sortOn(MVCControllerObjectFactoryPostProcessor.PRIORITY_METADATA_KEY, Array.DESCENDING | Array.NUMERIC);
					for each (var registration:CommandRegistration in registrations) {
						executeCommand(registration, event.event);
					}
				}
			}
		}

		/**
		 * First checks if there are <code>CommandRegistrations</code> associated with the <code>Event.type</code>,
		 * when none were found it checks if there are associations for the <code>Event's</code> <code>Class</code>.
		 * @param event The specified <code>Event</code>
		 * @return An <code>Array</code> of <code>CommandRegistration</code> instances or null if none were found.
		 * @throw flash.errors.IllegalOperationError When no registrations were found and the <code>failOnCommandNotFound</code> is set to <code>true</code>.
		 */
		public function findCommandRegistrations(event:Event):Vector.<CommandRegistration> {
			Assert.notNull(event, "event argument must not be null");
			var commandRegistrations:Vector.<CommandRegistration> = _eventTypeRegistry[event.type] as Vector.<CommandRegistration>;
			if (commandRegistrations != null) {
				LOGGER.debug("Found event type registration for event {0}", [event]);
				return commandRegistrations;
			} else {
				var cls:Class = ClassUtils.forInstance(event, _applicationContext.applicationDomain);
				commandRegistrations = _eventClassRegistry[cls] as Vector.<CommandRegistration>;
				if (commandRegistrations != null) {
					LOGGER.debug("Found event class registration for event {0}", [event]);
					return commandRegistrations;
				} else {
					if (_failOnCommandNotFound) {
						throw new IllegalOperationError("No event handler found for event " + event.toString());
					} else {
						LOGGER.debug("Found no registration for event {0}", [event]);
						return null;
					}
				}
			}
		}

		/**
		 * Retrieves the command specified by the <code>CommandRegistration</code> from the <code>IApplicationContext</code>,
		 * creates a <code>CommandProxy</code> for it and invokes the specified method.
		 * @param commandRegistration The specified <code>CommandRegistration</code> that holds all the necessary information about the command associated with the specified <code>Event</code>.
		 * @param event The specified <code>Event</code>.
		 */
		public function executeCommand(commandRegistration:CommandRegistration, event:Event):void {
			Assert.notNull(commandRegistration, "commandRegistration argument must not be null");
			Assert.notNull(event, "event argument must not be null");
			Assert.state((_applicationContext != null), "applicationContext property must be set");
			var commandInstance:Object = _applicationContext.getObject(commandRegistration.commandName);

			dispatchEvent(new ControllerEvent(ControllerEvent.BEFORE_COMMAND_EXECUTED, commandInstance));

			var proxy:CommandProxy = createProxy(commandInstance, event, commandRegistration);
			proxy.invoke();

			dispatchEvent(new ControllerEvent(ControllerEvent.AFTER_COMMAND_EXECUTED, commandInstance));
			LOGGER.debug("executed command {0} for event {1}", [commandInstance, event]);
		}

		/**
		 * <p>When the <code>eventBusDispatching</code> property is set to <code>true</code> the specified
		 * <code>Event</code> will also be dispatched through the assigned <code>IEventBus</code> instance.</p>
		 * @inheritDoc
		 */
		override public function dispatchEvent(event:Event):Boolean {
			Assert.notNull(event, "event argument must not be null");
			if ((eventBusDispatching) && (eventBus != null)) {
				eventBus.dispatchEvent(event);
			}
			return super.dispatchEvent(event);
		}

		/**
		 * Creates a <code>CommandProxy</code> for the specified command instance based on the specified <code>Event</code>
		 * and <code>CommandRegistration</code> instances.
		 * @param commandInstance The specified command instance.
		 * @param event The specified <code>Event</code> instance.
		 * @param commandRegistration The specified <code>CommandRegistration</code> instance.
		 * @return A <code>CommandProxy</code> for the specified command instance
		 */
		public function createProxy(commandInstance:Object, event:Event, commandRegistration:CommandRegistration):CommandProxy {
			Assert.notNull(commandInstance, "commandInstance argument must not be null");
			Assert.notNull(event, "event argument must not be null");
			Assert.notNull(commandRegistration, "commandRegistration argument must not be null");
			var commandType:Type = Type.forInstance(commandInstance, _applicationContext.applicationDomain);
			var method:Method = commandType.getMethod(commandRegistration.executeMethodName);
			return new CommandProxy(commandInstance, method, commandRegistration.properties, event, _applicationContext.applicationDomain);
		}

	}
}
