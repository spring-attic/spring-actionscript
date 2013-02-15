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
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	import mx.core.IFlexModuleFactory;
	import mx.modules.Module;
	import mx.modules.ModuleManager;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.context.metadata.ClassScannerObjectFactoryPostProcessor;
	import org.springextensions.actionscript.core.operation.OperationQueue;
	import org.springextensions.actionscript.ioc.autowire.DefaultFlexAutowireProcessor;
	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.LoggingTargetObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.flex.FlexPropertyPlaceholderConfigurer;
	import org.springextensions.actionscript.ioc.factory.support.referenceresolvers.ArrayCollectionReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.FlexXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.localization.LoadResourceBundleOperation;
	import org.springextensions.actionscript.localization.ResourceBundleInfo;
	import org.springextensions.actionscript.localization.ResourceBundleLoader;
	import org.springextensions.actionscript.module.IOwnerModuleAware;
	import org.springextensions.actionscript.module.OwnerModuleObjectPostProcessor;
	import org.springextensions.actionscript.stage.DefaultAutowiringStageProcessor;
	import org.springextensions.actionscript.stage.FlexStageProcessorFactoryPostProcessor;
	import org.springextensions.actionscript.stage.FlexStageProcessorRegistry;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * Extension of <code>XMLApplicationContext</code> that supports flex framework specific
	 * classes like <code>ArrayCollection</code>.
	 * <p>The context also supports special wiring for view components that happens when
	 * display objects are added to the stage. In order to improve performance The context
	 * use an <code>IObjectSelector</code> in order to decide which objects added to the stage should also
	 * be wired and a <code>IObjectDefinitionResolver</code> to map stage added objects to an <code>IObjectDefinition</code>.
	 * </p>
	 * <p>
	 * Default stage object selector implementation filters all mx.flash.* package classes and
	 * objects not inheriting from UIComponent.
	 * </p>
	 * <p>
	 * The <code>IObjectDefinition</code> is resolved using the context itself by type or name.
	 * It is possible to configure <code>FlexXMLApplicationContext</code> properties to filter additional classes,
	 * or filter by name.
	 * </p>
	 * <p>
	 * It is possible to use custom <code>IObjectSelector</code> whether using directly the classe setter or
	 * by creating an object having as id <code>flexStageObjectSelector</code> or a customer one
	 * set with <code>stageWireObjectSelectorName</code> property.
	 * </p>
	 * <p>
	 * It is possible to use custom stage wiring <code>IObjectDefinitionResolver</code> whether using directly
	 * the classe setter or by creating an object having as id <code>flexStageObjectDefinitionResolver</code>
	 * or a custom one set with <code>stageWireObjectDefinitionResolverName</code> property.
	 * </p>
	 * @author Christophe Herreman
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.context.support.FlexXMLApplicationContext#stageWireObjectHandler() FlexXMLApplicationContext.stageWireObjectHandler()
	 * @see org.springextensions.actionscript.stage.FlexStageDefaultObjectSelector FlexStageDefaultObjectSelector
	 * @see org.springextensions.actionscript.stage.DefaultObjectDefinitionResolver DefaultObjectDefinitionResolver
	 * @docref container-documentation.html#instantiating_a_container
	 */
	public class FlexXMLApplicationContext extends XMLApplicationContext implements IOwnerModuleAware {

		// force class compilation
		FlexPropertyPlaceholderConfigurer;
		ResourceBundleLoader;
		DefaultAutowiringStageProcessor;

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = LoggerFactory.getClassLogger(FlexXMLApplicationContext);

		// --------------------------------------------------------------------
		//
		// Private Fields
		//
		// --------------------------------------------------------------------

		private var _resourceBundleLocations:Array = [];

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * <p>Creates a new <code>FlexXMLApplicationContext</code>.</p>
		 * @inheritDoc
		 */
		public function FlexXMLApplicationContext(source:* = null, ownerModule:Module = null) {
			// create the new parser before calling super()
			// this prevents the default parser from being created
			preinitFlexXMLApplicationContext();
			super(source);
			initFlexXMLApplicationContext(ownerModule);
		}

		protected function preinitFlexXMLApplicationContext():void {
			configurationCompleted = false;
			parser = new FlexXMLObjectDefinitionsParser(this);
			autowireProcessor = new DefaultFlexAutowireProcessor(this);
			stageProcessorRegistry = FlexStageProcessorRegistry.getInstance();
		}


		override public function get applicationDomain():ApplicationDomain {
			return (_ownerModule != null && _ownerModule.moduleFactory != null) ? _ownerModule.moduleFactory.info().currentDomain as ApplicationDomain : super.applicationDomain;
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
					stageProcessorRegistry.unregisterContext(_ownerModule, this);
				}
				_ownerModule = value;
				if (_ownerModule) {
					stageProcessorRegistry.registerContext(_ownerModule, this);
				}
				if ((stageProcessorRegistry.enabled) && (_ownerModule) && (!configurationCompleted)) {
					stageProcessorRegistry.enabled = false;
				}
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds the info of an external resource bundle to the context, that will be loaded before the container
		 * dispatches its "complete" event.
		 *
		 * <p>Once loaded, the values of the external resource bundle are parsed into a ResourceBundle instance
		 * and passed into the ResourceManager.</p>
		 *
		 * @param url the location of the external resource bundle
		 * @param name the name of the resource bundle
		 * @param locale the locale
		 */
		public function addResourceBundleLocation(url:String, name:String, locale:String):void {
			Assert.hasText(url, "The url should not be null or an empty string.");
			Assert.hasText(name, "The name should not be null or an empty string.");
			Assert.hasText(locale, "The locale should not be null or an empty string.");

			Assert.state(!configurationCompleted, "Adding a resource bundle location is not possible since the context is already loaded.");

			var info:ResourceBundleInfo = new ResourceBundleInfo(url, name, locale);
			_resourceBundleLocations[_resourceBundleLocations.length] = info;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		override protected function parse():void {
			// before parsing, check if we have any resource bundles to load
			if (_resourceBundleLocations.length > 0) {
				var queue:OperationQueue = new OperationQueue();
				queue.addCompleteListener(resourceBundles_loadHandler);

				for each (var info:ResourceBundleInfo in _resourceBundleLocations) {
					queue.addOperation(new LoadResourceBundleOperation(info));
				}
			} else {
				super.parse();
			}
		}

		/**
		 * Resource bundle loadqueue complete handler.
		 */
		private function resourceBundles_loadHandler(event:Event):void {
			super.parse();
		}

		/**
		 * Initializes the <code>FlexXMLApplicationContext</code> instance.
		 */
		protected function initFlexXMLApplicationContext(ownerModule:Module):void {
			this.ownerModule = ownerModule;

			// add a factory postprocessor to add stageprocessors
			addObjectFactoryPostProcessor(new FlexStageProcessorFactoryPostProcessor());

			// add flex specific reference resolvers
			addReferenceResolver(new ArrayCollectionReferenceResolver(this));

			// add flex specific object post processors
			addObjectPostProcessor(new LoggingTargetObjectPostProcessor());
			addObjectPostProcessor(new OwnerModuleObjectPostProcessor());
		}

		/**
		 * <code>Event.COMPLETE</code> event handler added in context constructor.
		 * Attempts to wire all the components that are already on the stage cache.
		 * Assigns the systemManager property with the current application's systemManager
		 * and adds the stageWireObjectHandler() method as an Event.ADDED listener on the systemManager.
		 * @param event The specified <code>Event.COMPLETE</code> event
		 */
		override protected function completeHandler(event:Event):void {
			configurationCompleted = true;
			removeEventListener(Event.COMPLETE, completeHandler);

			if (!ownerModule) {
				stageProcessorRegistry.registerContext(ApplicationUtils.application, this);
			}

			if (stageProcessorRegistry.initialized) {
				stageProcessorRegistry.enabled = true;
				if (ownerModule) {
					stageProcessorRegistry.processStage(ownerModule);
				}
			} else {
				stageProcessorRegistry.initialize();
			}
		}

		/**
		 * Sets the <code>stageProcessorRegistry.enabled</code> property to false.
		 * Useful during testing and object dispose.
		 * @see stageWireObjectHandler()
		 */
		public function disableStageProcessing():void {
			stageProcessorRegistry.enabled = false;
		}

		/**
		 * Sets the <code>stageProcessorRegistry.enabled</code> property to true.
		 * Useful during testing and object dispose.
		 * @see stageWireObjectHandler()
		 */
		public function enableStageProcessing():void {
			stageProcessorRegistry.enabled = true;
		}

		/**
		 * <p>Checks if the given xml data contains any &lt;import/&gt; tags. If any are found,
		 * their corresponding xml file is added to the load queue.</p>
		 * <p>If an import has an attribute of type="class" the file is not being loaded but instead
		 * an property with the same name as the <em>file</em> attribute is retrieved from the current
		 * <code>Application</code>, this property needs to be of type <code>Class</code> and must
		 * represent an embedded resource.</p>
		 * @throws Error When the embeddedName is not found as a property on the <code>Application</code> object or when this property is not of type <code>Class</code>.
		 */
		override protected function addImportLocationsIfAny(xml:XML):void {
			// TODO why does this not work?
			//var importNodes:XMLList = xml.descendants("import").(attribute("file") != undefined);

			for each (var node:XML in xml.children()) {
				var nodeName:QName = node.name() as QName;

				if (nodeName && (nodeName.localName == "import")) {
					var importLocation:String = getBaseURL(currentConfigLocation) + node.@file.toString();
					if ((node.@type != undefined) && (node.@type.toString().toLowerCase() == "class")) {
						var embeddedName:String = node.@file.toString();
						var app:Object = ApplicationUtils.application;
						if (app.hasOwnProperty(embeddedName)) {
							var cls:Class = app[embeddedName] as Class;
							if (!cls) {
								throw new Error("Property " + embeddedName + " is not of type Class");
							}
							addEmbeddedConfig(cls);
						} else {
							throw new Error("Property " + embeddedName + " was not found on the current application object");
						}
					} else {
						addConfigLocation(importLocation);
					}
				}
			}
		}

		override public function getClassForName(className:String):Class {
			return ClassUtils.forName(className, applicationDomain) as Class;
		}

		override public function getClassForInstance(object:Object):Class {
			var className:String = getQualifiedClassName(object);

			var factory:IFlexModuleFactory = ModuleManager.getAssociatedFactory(object);
			if (factory != null) {
				var appDomain:ApplicationDomain = factory.info().currentDomain as ApplicationDomain;
				return ClassUtils.forName(className, appDomain);
			} else {
				return getClassForName(className);
			}
		}

		override public function dispose():void {
			if (!isDisposed) {
				if (_ownerModule != null) {
					stageProcessorRegistry.unregisterContext(_ownerModule, this);
				}
				ownerModule = null;
				super.dispose();
			}
		}

	}
}
