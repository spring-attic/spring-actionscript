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
package org.springextensions.actionscript.mvc.processor {

	import flash.system.ApplicationDomain;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinition;
	import org.springextensions.actionscript.mvc.IController;
	import org.springextensions.actionscript.mvc.impl.Controller;
	import org.springextensions.actionscript.util.TypeUtils;

	/**
	 * <code>IObjectFactoryPostProcessor</code> that checks the specified <code>IConfigurableListableObjectFactory</code>
	 * if it contains an <code>MVCRouteEventsMetaDataPostProcessor</code>. If not, it creates one and adds it to
	 * the <code>IConfigurableListableObjectFactory</code> using its <code>addObjectPostProcessor()</code> method.
	 * <p>After that it loops through all the object definitions and examines each class for the presence of [Command]
	 * metadata annotations.</p>
	 * <p>Any class can be annotated with [Command] metadata, as long as some metadata keys are provided as well.</p>
	 * <p>What follows are some examples of typical usage:</p>
	 * <p>If an object acts as a command that needs to be executed after a specific event type was dispatched add
	 * this metadata to the class:</p>
	 * <pre>
	 * [Command(eventType="someEventType")]
	 * public class SomeCommandClass {
	 * //implementation ommitted...
	 * }
	 * </pre>
	 * <p>If the command needs to be excecuted after a specific event <code>Class</code> was dispatched then add this
	 * metadata:</p>
	 * <pre>
	 * [Command(eventClass="com.events.MyEvent")]
	 * public class SomeCommandClass {
	 * //implementation ommitted...
	 * }
	 * </pre>
	 * <p>By default the method that will be invoked on the command object will be 'execute', but it is also possible
	 * to specify the method like this:</p>
	 * <pre>
	 * [Command(eventType="someEventType",executeMethod="process")]
	 * public class SomeCommandClass {
	 * //implementation ommitted...
	 * }
	 * </pre>
	 * <p>If more than one command is to be executed after a specific event and it is needed to control the order in
	 * which these command will be executed, use the priority key:</p>
	 * <pre>
	 * [Command(eventType="someEventType",priority=10)]
	 * public class SomeCommandClass {
	 * //implementation ommitted...
	 * }
	 * </pre>
	 * <p>Properties on the <code>Event</code> instance can be mapped to the arguments of the specified execution
	 * method or to properties on the command instance.</p>
	 * <p>First there will be a check if the first argument for the specified execute method is of the same type
	 * as the associated event, in this case the event is simply passed into the execute method.</p>
	 * <p>If this is not the case the properties of the event or the properties defined by the <code>properties</code>
	 * metadata key will be mapped by type to the arguments of the execute method.</p>
	 * <p>Finally, if this is not possible, the properties on the event will be mapped by type to the properties on
	 * the command instance.</p>
	 * <p>[Command] annotations can be stacked, so one command class can be triggered by multiple <code>Events</code>.</p>
	 * @author Roland Zwaga
	 */
	public class MVCControllerObjectFactoryPostProcessor implements IObjectFactoryPostProcessor {

		/**
		 * The object name that will be given to the controller instance in the object factory
		 */
		public static const CONTROLLER_OBJECT_NAME:String = "SpringActionScriptMVCController";

		public static const METADATAPROCESSOR_OBJECT_NAME:String = "SpringActionScriptMVCRouteEventsMetaDataProcessor";

		public static const COMMAND_METADATA:String = "Command";

		public static const EXECUTE_METHOD_METADATA_KEY:String = "executeMethod";

		public static const EVENT_TYPE_METADATA_KEY:String = "eventType";

		public static const EVENT_CLASS_METADATA_KEY:String = "eventClass";

		public static const PRIORITY_METADATA_KEY:String = "priority";

		public static const PROPERTIES_METADATA_KEY:String = "properties";

		public static const DEFAULT_EXECUTE_METHOD_NAME:String = "execute";

		/**
		 * Creates a new <code>MVCControllerObjectFactoryPostProcessor</code> instance.
		 */
		public function MVCControllerObjectFactoryPostProcessor() {
			super();
		}

		/**
		 *
		 * @param objectFactory The specified <code>IConfigurableListableObjectFactory</code> instance.
		 */
		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			Assert.notNull(objectFactory, "the objectFactory argument must not be null");
			addRouteEventsMetaDataPostProcessor(objectFactory);
			var controller:IController = addMVControllerInstance(objectFactory);
			registerCommands(objectFactory, controller);
			return null;
		}

		/**
		 *
		 * @param objectFactory The specified <code>IConfigurableListableObjectFactory</code> instance.
		 */
		public function addRouteEventsMetaDataPostProcessor(objectFactory:IObjectFactory):void {
			Assert.notNull(objectFactory, "the objectFactory argument must not be null")
			if (objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(MVCRouteEventsMetaDataProcessor).length < 1) {
				var objectDefinition:IObjectDefinition = new ObjectDefinition(ClassUtils.getFullyQualifiedName(MVCRouteEventsMetaDataProcessor, true));
				objectFactory.objectDefinitionRegistry.registerObjectDefinition(METADATAPROCESSOR_OBJECT_NAME, objectDefinition);
			}
		}

		/**
		 * Checks if the specified <code>IConfigurableListableObjectFactory</code> instance contains an object that
		 * implements the <code>IController</code> interface. When none is found a <code>Controller</code> instance
		 * is created and registered as a singleton in the <code>IConfigurableListableObjectFactory</code> instance.
		 * @param objectFactory The specified <code>IConfigurableListableObjectFactory</code> instance.
		 * @return The created or retrieved <code>IController</code> instance.
		 */
		public function addMVControllerInstance(objectFactory:IObjectFactory):IController {
			Assert.notNull(objectFactory, "the objectFactory argument must not be null");
			var names:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IController);
			if (names == null) {
				var controller:Controller = objectFactory.createInstance(Controller);
				objectFactory.cache.putInstance(CONTROLLER_OBJECT_NAME, controller);
				return controller;
			} else {
				return objectFactory.getObject(String(names[0]));
			}
		}

		/**
		 * Loops through all the <code>IObjectDefinitions</code> in the specified <code>IConfigurableListableObjectFactory</code> instance,
		 * creates a <code>Type</code> instance for the classes and invokes the <code>processCommandMetaData()</code> method.
		 * @param objectFactory The specified <code>IConfigurableListableObjectFactory</code>.
		 * @param controller The specified <code>IController</code> instance used to register commands in.
		 */
		public function registerCommands(objectFactory:IObjectFactory, controller:IController):void {
			Assert.notNull(objectFactory, "the objectFactory argument must not be null");
			Assert.notNull(controller, "the controller argument must not be null");
			for each (var key:String in objectFactory.objectDefinitionRegistry.objectDefinitionNames) {
				var def:IObjectDefinition = objectFactory.getObjectDefinition(key);
				var type:Type = Type.forName(def.className, objectFactory.applicationDomain);
				//simple types can't have metadata, so skip them
				if (TypeUtils.isSimpleProperty(type)) {
					continue;
				}
				processCommandMetaData(type, controller, key, objectFactory.applicationDomain);
			}
		}

		/**
		 *
		 * @param type The specified <code>Type</code> instance.
		 * @param controller The specified <code>IController</code> instance used to register commands in.
		 * @param commandName The name of the command as its registered in the application context.
		 * @param applicationDomain The specified <code>ApplicationDomain</code> used for reflection.
		 */
		public function processCommandMetaData(type:Type, controller:IController, commandName:String, applicationDomain:ApplicationDomain):void {
			Assert.notNull(type, "the type argument must not be null");
			Assert.notNull(controller, "the controller argument must not be null");
			Assert.hasText(commandName, "the objectName argument must not be null or empty");
			if (type.hasMetadata(COMMAND_METADATA)) {
				var metaData:Array = type.getMetadata(COMMAND_METADATA);
				for each (var md:Metadata in metaData) {
					processMetaData(md, controller, commandName, applicationDomain);
				}
			}
		}

		/**
		 * Extracts all the necessary information from the specified <code>MetaData</code> and registers
		 * the command with the specified <code>IController</code>.
		 * @param metaData The specified <code>MetaData</code> that needs to be processed.
		 * @param controller The specified <code>IController</code> instance used to register commands in.
		 * @param commandName The name of the command as its registered in the application context.
		 * @param applicationDomain The specified <code>ApplicationDomain</code> used for reflection.
		 */
		public function processMetaData(metaData:Metadata, controller:IController, commandName:String, applicationDomain:ApplicationDomain):void {
			Assert.notNull(metaData, "the metaData argument must not be null");
			Assert.notNull(controller, "the controller argument must not be null");
			Assert.hasText(commandName, "the objectName argument must not be null or empty");

			var prio:uint = (metaData.hasArgumentWithKey(PRIORITY_METADATA_KEY)) ? parseInt(metaData.getArgument(PRIORITY_METADATA_KEY).value) : 0;

			var executeMethod:String = (metaData.hasArgumentWithKey(EXECUTE_METHOD_METADATA_KEY)) ? metaData.getArgument(EXECUTE_METHOD_METADATA_KEY).value : DEFAULT_EXECUTE_METHOD_NAME;

			var properties:Vector.<String> = getPropertiesFromMetaData(metaData);

			if (metaData.hasArgumentWithKey(EVENT_TYPE_METADATA_KEY)) {
				var eventType:String = metaData.getArgument(EVENT_TYPE_METADATA_KEY).value;
				controller.registerCommandForEventType(eventType, commandName, executeMethod, properties, prio);
			} else if (metaData.hasArgumentWithKey(EVENT_CLASS_METADATA_KEY)) {
				var eventClass:Class = ClassUtils.forName(metaData.getArgument(EVENT_CLASS_METADATA_KEY).value, applicationDomain);
				controller.registerCommandForEventClass(eventClass, commandName, executeMethod, properties, prio);
			}
		}

		/**
		 * Checks if the properties key was set on the specified <code>MetaData</code> instance, if so
		 * it creates an <code>Array</code> of strings from the key.
		 * @param metaData The specified <code>MetaData</code> instance
		 * @return An <code>Array</code> of property names or <code>null</code> when the properties key was not set.
		 */
		public function getPropertiesFromMetaData(metaData:Metadata):Vector.<String> {
			Assert.notNull(metaData, "metaData argument must not be null");
			if (metaData.hasArgumentWithKey(PROPERTIES_METADATA_KEY)) {
				var value:String = metaData.getArgument(PROPERTIES_METADATA_KEY).value;
				var arr:Array = value.split(' ').join('').split(',');
				var result:Vector.<String> = new Vector.<String>();
				for each (var s:String in arr) {
					result[result.length] = s;
				}
				return result;
			} else {
				return null;
			}
		}

	}
}
