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
package org.springextensions.actionscript.context.support {

	import flash.events.Event;
	
	import mx.core.IMXMLObject;
	import mx.modules.Module;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.context.support.mxml.*;
	import org.springextensions.actionscript.ioc.AutowireMode;
	import org.springextensions.actionscript.ioc.DependencyCheckMode;
	import org.springextensions.actionscript.ioc.ObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.ioc.ObjectDefinitions;
	import org.springextensions.actionscript.ioc.autowire.DefaultFlexAutowireProcessor;
	import org.springextensions.actionscript.ioc.factory.config.LoggingTargetObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.support.referenceresolvers.ArrayCollectionReferenceResolver;
	import org.springextensions.actionscript.module.IOwnerModuleAware;
	import org.springextensions.actionscript.module.OwnerModuleObjectPostProcessor;
	import org.springextensions.actionscript.stage.FlexStageProcessorFactoryPostProcessor;
	import org.springextensions.actionscript.stage.FlexStageProcessorRegistry;
	import org.springextensions.actionscript.stage.IStageProcessorRegistry;
	import org.springextensions.actionscript.stage.IStageProcessorRegistryAware;
	import org.springextensions.actionscript.stage.StageProcessorFactoryPostprocessor;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * Application context that enables configuration to be defined in MXML.
	 *
	 * <p>Configurations are defined in one or more MXML files. Each MXML config that needs to be loaded, should be
	 * added to an MXMLApplicationContext instance via the addConfig() method. Once all configurations are added,
	 * invoking the load() method will (asynchronously) load and initialize the application context.</p>
	 *
	 * <p>Objects can either be defined explicitly (e.g. &lt;mx:RemoteObject/&gt;) or implicitly via a
	 * object definition.</p>
	 *
	 * <p>The MXMLApplicationContext also allows property placeholders (that resolve externally loaded properties)
	 * inside both explicit and implicit object definitions.</p>
	 *
	 * @example
	 * <pre>
	 * &lt;Objects
	 *  xmlns="http://www.springactionscript.org/mxml/config"
	 *		xmlns:mx="http://www.adobe.com/2006/mxml"
	 *		xmlns:context="org.springextensions.actionscript.ioc.factory.config.*"&gt;
	 *
	 * &lt;mx:Script&gt;
	 *   import mx.rpc.remoting.mxml.RemoteObject;
	 * &lt;/mx:Script&gt;
	 *
	 * &lt;context:PropertyPlaceholderConfigurer locations="{['properties.properties.txt', 'server.properties.txt']}"/>
	 *
	 * &lt;Object id="string1" clazz="{String}"&gt;
	 * &lt;ConstructorArg&gt;$(property1)&lt;/ConstructorArg&gt;
	 * &lt;/Object&gt;
	 *
	 * &lt;mx:Array id="propertiesArray"&gt;
	 * &lt;mx:String&gt;$(property1)&lt;/mx:String&gt;
	 * &lt;mx:String&gt;$(property2)&lt;/mx:String&gt;
	 * &lt;mx:String&gt;$(property3)&lt;/mx:String&gt;
	 * &lt;/mx:Array&gt;
	 *
	 * &lt;mx:RemoteObject endpoint="http://$(host):$(port)/$(context-root)/messagebroker/amf"/&gt;
	 *
	 * &lt;mx:RemoteObject id="remoteObject1" endpoint="http://$(host):$(port)/$(context-root)/messagebroker/amf"/&gt;
	 *
	 * &lt;mx:RemoteObject id="remoteObject2"&gt;
	 * &lt;mx:endpoint&gt;http://$(host):$(port)/$(context-root)/messagebroker/amf&lt;/mx:endpoint&gt;
	 * &lt;/mx:RemoteObject&gt;
	 *
	 * &lt;Object id="remoteObjectDefinitionWithPlaceHolders" clazz="{RemoteObject}"&gt;
	 * &lt;Property name="endpoint" value="http://$(host):$(port)/$(context-root)/messagebroker/amf"/&gt;
	 * &lt;/Object&gt;
	 * &lt;/Objects&gt;
	 * </pre>
	 * @author Roland Zwaga
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class MXMLApplicationContext extends AbstractApplicationContext implements IMXMLObject, IStageProcessorRegistryAware, IOwnerModuleAware {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = LoggerFactory.getClassLogger(MXMLApplicationContext);

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _document:Object;

		/** The Class objects of the MXML configurations. */
		private var _configClasses:Array = [];

		private var _configurationCompleted:Boolean;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>MXMLApplicationContext</code> instance.
		 *
		 * <p>This constructor will accept a Class object representing the MXML configuration or an Array
		 * representing multiple MXML configuration Class objects.</p>
		 *
		 * @param config a Class object or an Array of Class objects representing MXML configurations
		 */
		public function MXMLApplicationContext(config:* = null, ownerModule:Module = null) {
			_configurationCompleted = false;
			autowireProcessor = new DefaultFlexAutowireProcessor(this);
			initMXMLApplicationContext(config, ownerModule);
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// stageProcessorRegistry
		// ----------------------------

		private var _stageProcessorRegistry:IStageProcessorRegistry;

		/**
		 * @return The <code>IStateProcessorRegistry</code> instance for this application context.
		 */
		public function get stageProcessorRegistry():IStageProcessorRegistry {
			return _stageProcessorRegistry;
		}

		/**
		 * @param value The <code>IStateProcessorRegistry</code> instance for this application context.
		 */
		public function set stageProcessorRegistry(value:IStageProcessorRegistry):void {
			_stageProcessorRegistry = value;
		}

		// ----------------------------
		// ownerModule
		// ----------------------------

		private var _ownerModule:Module;

		/**
		 * @inheritDoc
		 */
		public function get ownerModule():Module {
			return _ownerModule;
		}

		/**
		 * @inheritDoc
		 */
		public function set ownerModule(value:Module):void {
			if (value !== _ownerModule) {
				if (_ownerModule != null) {
					_stageProcessorRegistry.unregisterContext(_ownerModule, this);
				}
				_ownerModule = value;
				if (_ownerModule) {
					_stageProcessorRegistry.registerContext(_ownerModule, this);
				}
				if ((_stageProcessorRegistry.enabled) && (_ownerModule) && (!_configurationCompleted)) {
					_stageProcessorRegistry.enabled = false;
				}
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds a single MXML configuration Class object to the application context. If the configuration class
		 * was already added, it will be ignored.
		 *
		 * @param configClass the Class object representing an MXML configuration
		 */
		public function addConfig(configClass:Class):void {
			if (_configClasses.indexOf(configClass) == -1) {
				_configClasses.push(configClass);
			} else {
				logger.warn("MXML configuration class '" + configClass + "' was already added and will be ignored.");
			}
		}

		/**
		 * <p>Checks if the <code>document</code> parameter is of type <code>Module</code> and if so sets it as the <code>ownerModule</code> property.</p>
		 * @see org.springextensions.actionscript.context.support.FlexXMLApplicationContext#ownerModule() FlexXMLApplicationContext.ownerModule
		 * @inheritDoc
		 */
		public function initialized(document:Object, id:String):void {
			this.id = id;
			_document = document;
			//ownerModule = getParentDocument(document);
			//initializeContext();
		}

		/**
		 * Sets the <code>stageProcessorRegistry.enabled</code> property to false.
		 * Useful during testing and object dispose.
		 * @see stageWireObjectHandler()
		 */
		public function disableStageProcessing():void {
			_stageProcessorRegistry.enabled = false;
		}

		/**
		 * Sets the <code>stageProcessorRegistry.enabled</code> property to true.
		 * Useful during testing and object dispose.
		 * @see stageWireObjectHandler()
		 */
		public function enableStageProcessing():void {
			_stageProcessorRegistry.enabled = true;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		override protected function doLoad():void {
			logger.debug("Loading object definitions from MXML");

			var objectDefinitions:ObjectDefinitions = new ObjectDefinitions(applicationDomain);

			// parse all configurations
			for each (var configClass:Class in _configClasses) {
				var definitions:ObjectDefinitions = parseConfig(configClass);
				// merge the object definitions
				objectDefinitions.merge(definitions);
			}

			// register all object definitions in the context
			var names:Array = objectDefinitions.objectDefinitionNames;
			for each (var name:String in names) {
				registerObjectDefinition(name, objectDefinitions.getObjectDefinition(name));
			}

			loadComplete();
		}

		protected function getParentDocument(object:Object):Module {
			if (object) {
				var parent:Object = object.parentDocument;
				while ((parent != null) && (parent != ApplicationUtils.application)) {
					if (parent is Module) {
						return parent as Module;
					}
					parent = parent.parentDocument;
				}
			}
			return null;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function initMXMLApplicationContext(config:*, ownerModule:Module = null):void {
			if (config != null){
				if (config is Class) {
					addConfig(config);
				} else if (config is Array) {
					for each (var configElement:* in config) {
						if (configElement is Class) {
							addConfig(configElement);
						} else {
							throw new IllegalArgumentError("The array element '" + configElement + "' should be of type Class");
						}
					}
				} else {
					throw new IllegalArgumentError("Invalid type '" + ClassUtils.forInstance(config, applicationDomain) + "' for constructor argument of MXMLApplicationContext. Only Class or an Array of Class objects are accepted.");
				}
			}

			_stageProcessorRegistry = FlexStageProcessorRegistry.getInstance();

			this.ownerModule = ownerModule;

			// add a factory postprocessor to add stageprocessors
			addObjectFactoryPostProcessor(new FlexStageProcessorFactoryPostProcessor());

			// add flex specific reference resolvers
			addReferenceResolver(new ArrayCollectionReferenceResolver(this));

			// add flex specific object post processors
			addObjectPostProcessor(new LoggingTargetObjectPostProcessor());
			addObjectPostProcessor(new OwnerModuleObjectPostProcessor());

			// listen for the Event.COMPLETE event to register completion of the configuration parsing
			// and initialize the stageProcessorRegistry afterwards
			addEventListener(Event.COMPLETE, completeHandler);
		}

		/**
		 * <code>Event.COMPLETE</code> event handler added in context constructor.
		 * Attempts to wire all the components that are already on the stage cache.
		 * Assigns the systemManager property with the current application's systemManager
		 * and adds the stageWireObjectHandler() method as an Event.ADDED listener on the systemManager.
		 * @param event The specified <code>Event.COMPLETE</code> event
		 */
		protected function completeHandler(event:Event):void {
			_configurationCompleted = true;
			removeEventListener(Event.COMPLETE, completeHandler);

			if (!ownerModule) {
				_stageProcessorRegistry.registerContext(ApplicationUtils.application, this);
			}

			if (_stageProcessorRegistry.initialized) {
				_stageProcessorRegistry.enabled = true;
				if (ownerModule) {
					_stageProcessorRegistry.processStage(ownerModule);
				}
			} else {
				_stageProcessorRegistry.initialize();
			}
		}

		/**
		 * Parses a single MXML configuration class to an ObjectDefinitions object.
		 *
		 * @param configClass
		 */
		private function parseConfig(configClass:Class):ObjectDefinitions {
			var result:ObjectDefinitions = new ObjectDefinitions(applicationDomain);
			var type:Type = Type.forClass(configClass, applicationDomain);

			// create an instance of the configClass so we can read its values
			var config:* = ClassUtils.newInstance(configClass);

			// read top-level attributes
			if (config is MXMLObjects) {
				var mxmlObjects:MXMLObjects = MXMLObjects(config);
				result.defaultInitMethod = mxmlObjects.defaultInitMethod;
				result.defaultLazyInit = mxmlObjects.defaultLazyInit;
				result.defaultAutowire = AutowireMode.fromName(mxmlObjects.defaultAutowire);
			}

			// parse accessors = definitions that have an id
			for each (var accessor:Accessor in type.accessors) {
				// an accessor is only valid if:
				// - it is readable
				// - it is writable
				// - its declaring class is not MXMLObjects: we don't want to parse the "defaultLazyInit" property, etc
				if (accessor.readable && accessor.writeable && (accessor.declaringType.clazz != MXMLObjects)) {
					parseObjectDefinition(result, config, accessor);
				}
			}

			// parse variables = definitions that don't have an id (name)
			for each (var variable:Variable in type.variables) {
				// a variable is only valid if:
				// - its (generated) id/name matches the pattern '_{CONTEXT_CLASS}_{VARIABLE_CLASS}{N}'
				if (variable.name.indexOf("_" + type.name) > -1) {
					parseObjectDefinition(result, config, variable);
				}
			}

			return result;
		}

		/**
		 * Parse a single object definition. This will either be a MXMLObjectDefinition or a (singleton) object
		 * configured directly in the MXML configuration.
		 *
		 * <p>MXMLObjectDefinition objects are parsed to ObjectDefinition objects. Objects declared explicitly
		 * are registered as singletons without object definition.</p>
		 *
		 * @param config
		 * @param field
		 */
		private function parseObjectDefinition(registry:ObjectDefinitions, config:Object, field:Field):void {
			var result:ObjectDefinition;
			var instance:Object = config[field.name];

			if (instance is MXMLObjectDefinition) {
				var mxmlDefinition:MXMLObjectDefinition = MXMLObjectDefinition(instance);
				mxmlDefinition.parse();
				/*result = new ObjectDefinition(mxmlDefinition.className);
				   result.scope = ObjectDefinitionScope.fromName(mxmlDefinition.scope);
				   result.constructorArguments = mxmlDefinition.constructorArguments;
				 result.properties = mxmlDefinition.properties;*/
				registry.registerObjectDefinition(field.name, mxmlDefinition.definition);
			} else {
				// register a singleton for an explicit config object defined in mxml
				// for instance: <mx:RemoteObject/>
				registerSingleton(field.name, instance);
				/*result = new ObjectDefinition(field.type.fullName);
				   for each (var property:Accessor in field.type.accessors) {
				   if (property.writeable) {
				   var value:* = property.getValue(instance);
				   result.properties[property.name] = value;
				   }
				 }*/
			}
		}

		override public function dispose():void {
			super.dispose();
			if (_ownerModule == null) {
				_stageProcessorRegistry.unregisterContext(ApplicationUtils.application, this);
			} else {
				ownerModule = null;
			}
		}

	}
}