/*
 * Copyright 2007-2011 the original author or authors.
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

	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;

	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.IllegalStateError;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IConfigurableApplicationContext;
	import org.springextensions.actionscript.context.support.event.ApplicationContextLifeCycleEvent;
	import org.springextensions.actionscript.ioc.factory.xml.INamespaceHandler;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	import org.springextensions.actionscript.stage.FlashStageProcessorRegistry;
	import org.springextensions.actionscript.stage.IStageProcessorRegistry;
	import org.springextensions.actionscript.stage.IStageProcessorRegistryAware;
	import org.springextensions.actionscript.stage.StageProcessorFactoryPostprocessor;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	use namespace spring_actionscript_objects;

	/**
	 * The <code>XMLApplicationContext</code> is the object factory used in ActionScript projects, in Flex projects
	 * you want to use the <code>FlexXMLApplicationContext</code> class.
	 * <p />
	 * <p>
	 * <strong>Important: </strong> the schemaLocation within the application context xml file (in the example
	 * <code>http://www.springactionscript.org/schema/objects/spring-actionscript-objects-1.0.xsd</code>)
	 * should contain the version of spring actionscript you are using.
	 * </p>
	 * <p />
	 * <em>Using the XMLApplicationContext</em>
	 * <p />
	 * The following example retrieves an object from the application context
	 * <listing version="3.0">
	 * public class MyApplication {
	 *
	 *   private var _xmlApplicationContext:XMLApplicationContext;
	 *
	 *   public function MyApplication() {
	 *     _xmlApplicationContext = new XMLApplicationContext("applicationContext.xml");
	 *     _xmlApplicationContext.addEventListener(Event.COMPLETE, _applicationContextCompleteHandler);
	 *     _xmlApplicationContext.load();
	 *   }
	 *
	 *   private function _applicationContextCompleteHandler(e:Event):void {
	 *     var someObject:SomeObject = _xmlApplicationContext.getObject("someObject");
	 *   }
	 * }
	 * </listing>
	 * <p />
	 * The <code>applicationContext.xml</code> could look something like this:
	 * <p />
	 * <em>A simple application context xml file</em>
	 * <p />
	 * An <code>applicationcontext.xml</code> file with one object defined
	 * <listing version="3.0">
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;objects xmlns="http://www.springactionscript.org/objects"
	 *          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 *          xsi:schemaLocation="http://www.springactionscript.org/schema/objects/spring-actionscript-objects-1.0.xsd"
	 * &gt;
	 *   &lt;object id="someObject" class="package.SomeClass" /&gt;
	 *
	 * &lt;/objects&gt;
	 * </listing>
	 * <p />
	 * <em>Object post processors</em>
	 * <p />
	 * In order to manipulate instantiated objects before (or after) they are created you can use object
	 * post processors. Post processors can be defined like this:
	 * <p />
	 * <listing version="3.0">
	 * &lt;object class="org.springextensions.actionscript.factory.config.SpecialObjectPostProcessor" /&gt;
	 * </listing>
	 * <p />
	 * The <code>XMLApplicationContext</code> will automatically add them if they implement the
	 * <code>IObjectPostProcessor</code> interface.
	 *
	 * <p>
	 * <b>Authors:</b> Christophe Herreman, Erik Westra<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 *
	 * @see org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor
	 * @see #addObjectPostProcessor() XMLApplicationContext.addObjectPostProcessor()
	 * @docref container-documentation.html#instantiating_a_container
	 */
	public class XMLApplicationContext extends AbstractApplicationContext implements IStageProcessorRegistryAware, IConfigurableApplicationContext {

		private static const LOGGER:ILogger = getLogger(XMLApplicationContext);
		private static const XMLOBJECT_WRONG_CONSTRUCTOR_ARGS_ERROR:String = "XMLObjectFactory can only be constructed using an a String or an Array";
		private static const MISSING_CONFIG_ERROR:String = "An XMLObjectFactory can only be loaded when a config location has been set or XML data was added to it.";
		private static const LOADING_OBJECT_DEFINITIONS:String = "Loading object definitions";
		private static const LOADING_XML_OBJECT_DEFINITIONS:String = "Loading XML object definitions from [{0}]";
		private static const IMPORT_NODE_NAME:String = "import";

		/**
		 * Contains the parser of the XML definitions. The instance is created in the constructor
		 * if it does not exist already.
		 * @default an instance of XMLObjectDefinitionsParser
		 */
		public var parser:XMLObjectDefinitionsParser;

		protected var _xml:XML = <objects/>;

		private var _loadingConfig:Boolean;

		private var _loader:URLLoader;

		protected var currentConfigLocation:String = "";

		protected var configurationCompleted:Boolean;

		protected var skipDispose:Boolean = false;

		//private var _currentProperties:Properties;

		//private var _currentPropertyInfo:PropertiesInfo;

		//private var _propertiesQueue:Array /* of PropertiesInfo */ = [];

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new XMLApplicationContext
		 */
		public function XMLApplicationContext(source:* = null, parent:IApplicationContext = null) {
			super(parent);
			initXMLObjectFactory(source);
		}

		/**
		 * Initializes the <code>XMLObjectFactoryInit</code> instance
		 */
		protected function initXMLObjectFactory(source:*):void {

			if (stageProcessorRegistry == null) {
				stageProcessorRegistry = FlashStageProcessorRegistry.getInstance();
				// add a factory postprocessor to add stageprocessors
				addObjectFactoryPostProcessor(new StageProcessorFactoryPostprocessor());
			}

			if (source is String) {
				_configLocations.push(source);
			} else if (source is Array) {
				_configLocations = _configLocations.concat(source);
			} else if (source) {
				throw new IllegalArgumentError(XMLOBJECT_WRONG_CONSTRUCTOR_ARGS_ERROR);
			}

			// create a parser if we don't have on
			if (!parser) {
				parser = new XMLObjectDefinitionsParser(this);
			}

			// listen for the Event.COMPLETE event to register completion of the configuration parsing
			// and initialize the stageProcessorRegistry afterwards
			addEventListener(Event.COMPLETE, completeHandler);
		}

		/**
		 * Adds a namespace handler to the parser of this application context.
		 */
		public function addNamespaceHandler(handler:INamespaceHandler):void {
			parser.addNamespaceHandler(handler);
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
		 *
		 */
		public function get stageProcessorRegistry():IStageProcessorRegistry {
			return _stageProcessorRegistry;
		}

		public function set stageProcessorRegistry(value:IStageProcessorRegistry):void {
			_stageProcessorRegistry = value;
		}

		// ====================================================================
		// IXMLObjectFactory implementation
		// ====================================================================

		private var _configLocations:Array /* of String */ = [];

		/**
		 * @inheritDoc
		 */
		public function addConfigLocation(configLocation:String):void {
			_configLocations.push(configLocation);
		}

		/**
		 * @inheritDoc
		 */
		public function get configLocations():Array {
			return _configLocations;
		}

		/**
		 * @inheritDoc
		 */
		public function addConfig(config:XML):void {
			// If we are not retrieving the xml using a loader, we should reset
			// the _currentConfigLocation. When using the loader the _loadingConfig
			// flag is set to true and the location will not be reset.

			// The _currentConfigLocation is used in the _addImportLocationsIfAny and
			// _addPropertyLocationsIfAny methods.
			if (!_loadingConfig) {
				currentConfigLocation = "";
			}

			_mergeXML(config);

			// check if there are any xml or properties file references in the given xml data
			addImportLocationsIfAny(config);
			//addPropertyLocationsIfAny(config);
		}

		/**
		 * @inheritDoc
		 */
		public function addEmbeddedConfig(config:Class):void {
			//default xml namespace = spring_actionscript_objects;
			var configInstance:ByteArray = new config();
			var configXML:XML = new XML(configInstance.readUTFBytes(configInstance.length));
			addConfig(configXML);
		}

		// ====================================================================

		/**
		 * This method will internally do the following:
		 * <ul>
		 * <li>Load all configuration entries (if any)</li>
		 * <li>Load all imports (if any)</li>
		 * <li>Load all property files (if any)</li>
		 * <li>Give the result to the XMLObjectDefinitionsParser</li>
		 * </ul>
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser XMLObjectDefinitionsParser
		 * @inheritDoc
		 */
		override protected function doLoad():void {
			var noConfigLocations:Boolean = (_configLocations.length == 0);
			var noXML:Boolean = (_xml == null);

			if (noConfigLocations && noXML) {
				throw new IllegalStateError(MISSING_CONFIG_ERROR);
			} else {
				// We only need one loader. Browser restrictions allow us to only have a
				// maximum of 2 threads to the server. It is proper however to only use
				// one at a time.
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, loader_completeHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

				LOGGER.debug(LOADING_OBJECT_DEFINITIONS);

				loadNextConfigLocation();
			}
		}

		/**
		 * Will load a configLocation
		 */
		protected function loadConfigLocation(configLocation:String):void {
			LOGGER.info(LOADING_XML_OBJECT_DEFINITIONS, [configLocation]);

			currentConfigLocation = configLocation;
			_loadingConfig = true;

			// add a pseudo random number to avoid caching
			//configLocation += ("?" + Math.round(Math.random() * 1000000));

			var request:URLRequest = new URLRequest(configLocation);

			_loader.load(request);
		}

		/**
		 * <code>Event.COMPLETE</code> event handler added in context constructor.
		 * Attempts to wire all the components that are already on the stage cache.
		 * Assigns the systemManager property with the current application's systemManager
		 * and adds the stageWireObjectHandler() method as an Event.ADDED listener on the systemManager.
		 * @param event The specified <code>Event.COMPLETE</code> event
		 */
		protected function completeHandler(event:Event):void {
			configurationCompleted = true;
			removeEventListener(Event.COMPLETE, completeHandler);

			if (_stageProcessorRegistry != null) {
				if (_stageProcessorRegistry.initialized) {
					_stageProcessorRegistry.enabled = true;
				} else {
					stageProcessorRegistry.initialize();
				}
			}
		}

		private function _mergeXML(xml:XML):void {
			//default xml namespace = spring_actionscript_objects;
			if (_xml) {
				var childNodes:XMLList = xml.children();
				_xml.appendChild(childNodes);
			} else {
				_xml = xml;
			}
		}

		/**
		 * Returns the base url of the file this loading is loading.
		 */
		protected function getBaseURL(url:String):String {
			var lastSlashIndex:int = url.lastIndexOf("/");
			return (lastSlashIndex == -1) ? "" : url.substr(0, lastSlashIndex + 1);
		}

		/**
		 * Will grab the xml and add it as config
		 */
		private function loader_completeHandler(event:Event):void {
			//default xml namespace = spring_actionscript_objects;
			// if the loading is done, we need to check if the xml contains
			// import or property tags
			// if it does, we first load these

			// TODO catch malformed xml
			var xml:XML = new XML(_loader.data);

			addConfig(xml);

			_loadingConfig = false;

			loadNextConfigLocation();
		}

		/**
		 * Checks if the given xml data contains any &lt;import/&gt; tags. If any are found,
		 * their corresponding xml file is added to the load queue.
		 */
		protected function addImportLocationsIfAny(xml:XML):void {
			//default xml namespace = spring_actionscript_objects;
			// TODO why does this not work?
			//var importNodes:XMLList = xml.descendants("import").(attribute("file") != undefined);

			for each (var node:XML in xml.children()) {
				var nodeName:QName = node.name() as QName;

				if (nodeName && (nodeName.localName == IMPORT_NODE_NAME)) {
					var importLocation:String = getBaseURL(currentConfigLocation) + node.@file.toString();
					addConfigLocation(importLocation);
				}
			}
		}

		/**
		 * Parses the xml.
		 */
		protected function parse():void {
			parser.parse(_xml);
			dispatchEvent(new ApplicationContextLifeCycleEvent(ApplicationContextLifeCycleEvent.XML_PARSED));
			System.disposeXML(_xml);
			_xml = null;
			loadComplete();
		}

		/**
		 * Checks if the given xml data contains any <property> tags. If any are found,
		 * the information is added to a queue for later loading.
		 */
		/*private function addPropertyLocationsIfAny(xml:XML):void {
		   // select all property nodes directly under the <objects/> element that have a file attribute
		   var propertyNodes:XMLList = xml.property.(attribute("file") != undefined);
		   var propertiesInfo:PropertiesInfo;

		   for each (var node:XML in propertyNodes) {
		   propertiesInfo = new PropertiesInfo();
		   propertiesInfo.properties = new Properties();
		   propertiesInfo.location = getBaseURL(currentConfigLocation) + node.@file.toString();
		   propertiesInfo.required = (node.@required == undefined) ? true : String(node.@required.toString()).toLowerCase() == "true";
		   propertiesInfo.preventCache = (node.attribute("prevent-cache").length() == 0) ? true : String(node.attribute("prevent-cache").toString()).toLowerCase() == "true";
		   _propertiesQueue.push(propertiesInfo);
		   logger.debug("Added external properties file '{0}' to load queue.", propertiesInfo);
		   }

		   if (!propertiesInfo) {
		   logger.debug("No external properties file reference found.");
		   }
		 }*/

		/**
		 * If there are any config locations left, the next will be loaded.
		 */
		private function loadNextConfigLocation():void {
			// load the next config location if we have one
			if (_configLocations.length > 0) {
				var nextConfigLocation:String = String(_configLocations.shift());
				loadConfigLocation(nextConfigLocation);
			} else {
				cleanupLoader();
				_loader = null;
				parse();
			}
		}

		/**
		 * If there are any properties left to be loaded, the next will be loaded.
		 */
		/*private function loadNextProperties():void {
		   if (_propertiesQueue.length > 0) {
		   var propertyInfo:PropertiesInfo = PropertiesInfo(_propertiesQueue.shift());

		   var loaderProperties:Properties = propertyInfo.properties;
		   loaderProperties.addEventListener(Event.COMPLETE, properties_completeHandler);
		   loaderProperties.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

		   //save a reference to prevent garbage collection
		   _currentProperties = loaderProperties;
		   _currentPropertyInfo = propertyInfo;

		   logger.info("Loading properties file from [{0}]", propertyInfo.location);

		   loaderProperties.load(propertyInfo.location, _loader, propertyInfo.preventCache);
		   } else {
		   _loader = null;
		   parse();
		   }
		 }*/

		/*private function properties_completeHandler(event:Event):void {
		   properties.merge(_currentProperties);
		   cleanupCurrentProperties();
		   loadNextProperties();
		 }*/

		/**
		 * Removes the reference to the currentProperties, it make it available for garbage collection.
		 */
		/*private function cleanupCurrentProperties():void {
		   if (_currentProperties) {
		   _currentProperties.removeEventListener(Event.COMPLETE, properties_completeHandler);
		   _currentProperties.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		   }

		   _currentProperties = null;
		   _currentPropertyInfo = null;
		 }*/

		/**
		 * Will throw an error (just like the Flash player core classes) if
		 * no listener has been specified.
		 *
		 * @param event The IOErrorEvent
		 */
		private function ioErrorHandler(event:IOErrorEvent):void {
			// Don't throw an error if the IOErrorEvent was triggered
			// while trying to load a non-required properties file.
			var throwUnhandledIOError:Boolean = true;
			var shouldLoadNextProperties:Boolean = false;

			/*if (_currentPropertyInfo) {
			   throwUnhandledIOError = _currentPropertyInfo.required;
			   cleanupCurrentProperties();

			   // raise flag to load next properties, if we don't throw an error
			   if (!throwUnhandledIOError) {
			   shouldLoadNextProperties = true;
			   }
			 }*/

			if (throwUnhandledIOError) {
				_loader = null;
				if (hasEventListener(event.type)) {
					dispatchEvent(event);
				} else {
					throw new IOError("Unhandled ioError: " + event.text);
				}
			} else {
				/*if (shouldLoadNextProperties) {
				   loadNextProperties();
				 }*/
			}
		}

		/**
		 * If the <code>_loader</code> variable is not null the <code>onLoaderComplete</code>
		 * and <code>onIOError</code> event handlers are removed.
		 */
		protected function cleanupLoader():void {
			if (_loader) {
				if (_loader.willTrigger(Event.COMPLETE)) {
					_loader.removeEventListener(Event.COMPLETE, loader_completeHandler);
				}
				if (_loader.willTrigger(IOErrorEvent.IO_ERROR)) {
					_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				}
			}
		}

		override public function dispose():void {
			if (!isDisposed) {
				if (!skipDispose) {
					stageProcessorRegistry.unregisterContext(ApplicationUtils.application, this);
				}
				super.dispose();
			}
		}

	}
}

/*import org.springextensions.actionscript.collections.Properties;


   class PropertiesInfo {
   public var properties:Properties;

   public var location:String;

   public var required:Boolean;

   public var preventCache:Boolean = true;

   public function PropertiesInfo() {
   }
 }*/
