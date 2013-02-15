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

	import flash.events.Event;

	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IConfigurableApplicationContext;
	import org.springextensions.actionscript.context.support.event.ApplicationContextLifeCycleEvent;
	import org.springextensions.actionscript.core.IOrdered;
	import org.springextensions.actionscript.core.io.IResourceLoader;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.core.operation.OperationEvent;
	import org.springextensions.actionscript.core.operation.OperationQueue;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.factory.config.PropertyPlaceholderConfigurer;
	import org.springextensions.actionscript.ioc.factory.support.DefaultListableObjectFactory;
	import org.springextensions.actionscript.metadata.MetadataProcessorObjectFactoryPostProcessor;
	import org.springextensions.actionscript.utils.DisposeUtils;

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
	 *	 _xmlApplicationContext = new XMLApplicationContext("applicationContext.xml");
	 *	 _xmlApplicationContext.addEventListener(Event.COMPLETE, _applicationContextCompleteHandler);
	 *	 _xmlApplicationContext.load();
	 *   }
	 *
	 *   private function _applicationContextCompleteHandler(e:Event):void {
	 *	 var someObject:SomeObject = _xmlApplicationContext.getObject("someObject");
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
	 *		  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	 *		  xsi:schemaLocation="http://www.springactionscript.org/schema/objects/spring-actionscript-objects-1.0.xsd"
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
	public class AbstractApplicationContext extends DefaultListableObjectFactory implements IConfigurableApplicationContext {

		// force compilation of the following classes
		PropertyPlaceholderConfigurer;

		private static var logger:ILogger = getLogger(AbstractApplicationContext);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new AbstractApplicationContext
		 */
		public function AbstractApplicationContext(parent:IApplicationContext = null) {
			super();
			initAbstractApplicationContext(parent);
		}

		protected function initAbstractApplicationContext(parent:IApplicationContext):void {
			this.parent = parent;
			if (parentContext != null) {
				parentContext.eventBus.addListener(IEventBusListener(eventBus), true);
			}
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// id
		// ----------------------------

		private var _id:String = "";

		/**
		 * @private
		 */
		public function get id():String {
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:String):void {
			_id = value;
		}

		// ----------------------------
		// displayName
		// ----------------------------

		private var _displayName:String = "";

		/**
		 * @private
		 */
		public function get displayName():String {
			return _displayName;
		}

		/**
		 * @private
		 */
		public function set displayName(value:String):void {
			_displayName = value;
		}

		// ----------------------------
		// parentContext
		// ----------------------------

		/**
		 * @inheritDoc
		 */
		public function get parentContext():IApplicationContext {
			// note: cast with 'as' since we are allowed to return null here
			return (parent as IApplicationContext);
		}

		// ----------------------------
		// objectFactoryPostProcessors
		// ----------------------------

		private var _objectFactoryPostProcessors:Array = [];

		public function get objectFactoryPostProcessors():Array {
			return _objectFactoryPostProcessors;
		}

		// ----------------------------
		// useParentObjectFactoryPostProcessors
		// ----------------------------

		private var m_useParentObjectFactoryPostProcessors:Boolean = false;

		public function get useParentObjectFactoryPostProcessors():Boolean {
			return m_useParentObjectFactoryPostProcessors;
		}

		public function set useParentObjectFactoryPostProcessors(value:Boolean):void {
			if (value !== m_useParentObjectFactoryPostProcessors) {
				m_useParentObjectFactoryPostProcessors = value;
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Overridden Methods
		//
		// --------------------------------------------------------------------

		override public function registerSingleton(name:String, object:Object):void {
			super.registerSingleton(name, object);

			// also add this singleton as an object factory post processor if it is one
			if (object is IObjectFactoryPostProcessor) {
				addObjectFactoryPostProcessor(IObjectFactoryPostProcessor(object));
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addObjectFactoryPostProcessor(objectFactoryPostProcessor:IObjectFactoryPostProcessor, index:int = -1):void {
			Assert.notNull(objectFactoryPostProcessor, "The object factory post-processor cannot be null");

			if (objectFactoryPostProcessor is IApplicationDomainAware) {
				IApplicationDomainAware(objectFactoryPostProcessor).applicationDomain = applicationDomain;
			}

			if ((index < 0) || (index > _objectFactoryPostProcessors.length - 1)) {
				_objectFactoryPostProcessors.push(objectFactoryPostProcessor);
			} else {
				_objectFactoryPostProcessors.splice(index, 0, objectFactoryPostProcessor);
			}
		}

		public function load():void {
			prepareApplicationContext();
			doLoad();
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Does the actual loading after the application context has been prepared. Subclasses should override this
		 * method without calling super.doLoad(), since the default behavior will trigger the loadComplete() method
		 * immediately. Subclasses should not forget to call loadComplete() after the (asynchronous) loading is done.
		 */
		protected function doLoad():void {
			loadComplete();
		}

		/**
		 * Hook method defined in XmlObjectFactory to add the <code>ApplicationContextAwareProcessor</code>.
		 *
		 * @see ApplicationContextAwareProcessor
		 * @see #addObjectPostProcessor()
		 */
		protected function prepareApplicationContext():void {
			addObjectFactoryPostProcessor(new MetadataProcessorObjectFactoryPostProcessor());
			addObjectPostProcessor(new ApplicationContextAwareProcessor(this));
		}

		/**
		 *
		 */
		protected function loadComplete():void {
			registerObjectPostProcessors();
			registerObjectFactoryPostProcessors();

			// if we have any object factory post processors that are resource loaders, we need to load them before
			// invoking them
			var resourceLoadQueue:OperationQueue = new OperationQueue();
			resourceLoadQueue.addCompleteListener(resourceLoadQueue_completeHandler);

			// add a load operation for each resource loader
			var resourceLoaders:Array = getResourceLoaders();
			for each (var resourceLoader:IResourceLoader in resourceLoaders) {
				var operation:IOperation = resourceLoader.load();
				resourceLoadQueue.addOperation(operation);
				logger.debug("Found IResourceLoader '{0}'. Adding load operation '{1}' to queue before proceeding with context initialization.", [resourceLoader, operation]);
			}

			// we don't have any resource to load, so proceed immediately
			// call the resource load queue's complete handler, but pass in null instead of an actual event
			if (resourceLoadQueue.total == 0) {
				logger.debug("No IObjectFactoryResourceLoader found.");
				resourceLoadQueue_completeHandler(null);
			}
		}

		/**
		 * Will search all object definitions for implementations of IObjectPostProcessor.
		 * <p />
		 * <p>If they are found they will be added using addObjectPostProcessor.</p>
		 * If the implementation also implements IObjectFactoryAware, it will receive a reference
		 * to the XMLApplicationContext.
		 * @see org.springextensions.actionscript.ioc.factory.support.AbstractObjectFactory#addObjectPostProcessor() AbstractObjectFactory.addObjectPostProcessor()
		 */
		protected function registerObjectPostProcessors():void {
			var postProcessorsNames:Array = getObjectNamesForType(IObjectPostProcessor);

			for (var i:int = 0; i < postProcessorsNames.length; i++) {
				addObjectPostProcessor(getObject(postProcessorsNames[i]));
			}
		}

		/**
		 * Looks for implementations of IObjectFactoryPostProcessor in the object definition of this context and
		 * add an instance of each one as a object factory post processor.
		 */
		protected function registerObjectFactoryPostProcessors():void {
			var postProcessorsNames:Array = getObjectNamesForType(IObjectFactoryPostProcessor);

			for (var i:int = 0; i < postProcessorsNames.length; i++) {
				addObjectFactoryPostProcessor(getObject(postProcessorsNames[i]));
			}
		}

		/**
		 * Invokes all object factory post processors.
		 */
		protected function invokeObjectFactoryPostProcessors():void {
			var allObjectFactoryPostProcessors:Array = getAllObjectFactoryPostProcessors();

			invokeOrderedObjectFactoryPostProcessors(allObjectFactoryPostProcessors);
			invokeNonOrderedObjectFactoryPostProcessors(allObjectFactoryPostProcessors);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Get all ObjectFactoryPostProcessors, including the ones defined in parent application contexts if the
		 * "useParentObjectFactoryPostProcessors" flag is on.
		 */
		private function getAllObjectFactoryPostProcessors():Array {
			var result:Array = _objectFactoryPostProcessors;

			if (useParentObjectFactoryPostProcessors) {
				var parent:IApplicationContext = parentContext;

				while (parent) {
					if (parent is IConfigurableApplicationContext) {
						var parentObjectFactoryPostProcessors:Array = IConfigurableApplicationContext(parent).objectFactoryPostProcessors;
						result = result.concat(parentObjectFactoryPostProcessors);
					}
					parent = parent.parentContext;
				}
			}

			return result;
		}

		private function invokeOrderedObjectFactoryPostProcessors(objectFactoryPostProcessors:Array):void {
			var orderedPostProcessors:Array = getOrderedObjectFactoryPostProcessors(objectFactoryPostProcessors);
			doInvokeObjectFactoryPostProcessors(orderedPostProcessors);
		}

		private function invokeNonOrderedObjectFactoryPostProcessors(objectFactoryPostProcessors:Array):void {
			var nonOrderedPostProcessors:Array = getNonOrderedObjectFactoryPostProcessors(objectFactoryPostProcessors);
			doInvokeObjectFactoryPostProcessors(nonOrderedPostProcessors);
		}

		private function getOrderedObjectFactoryPostProcessors(objectFactoryPostProcessors:Array):Array {
			var result:Array = [];

			for each (var postProcessor:IObjectFactoryPostProcessor in objectFactoryPostProcessors) {
				if (postProcessor is IOrdered) {
					result.push(postProcessor);
				}
			}

			result.sortOn("order", Array.NUMERIC);

			return result;
		}

		private function getNonOrderedObjectFactoryPostProcessors(objectFactoryPostProcessors:Array):Array {
			var result:Array = [];

			for each (var postProcessor:IObjectFactoryPostProcessor in objectFactoryPostProcessors) {
				if (!(postProcessor is IOrdered)) {
					result.push(postProcessor);
				}
			}

			return result;
		}

		private function doInvokeObjectFactoryPostProcessors(postProcessors:Array):void {
			var numPostProcessors:uint = postProcessors.length;

			for (var i:uint = 0; i < numPostProcessors; i++) {
				var postProcessor:IObjectFactoryPostProcessor = postProcessors[i];
				logger.debug("Post processing object factory with post-processor '{0}'", [postProcessor]);
				postProcessor.postProcessObjectFactory(this);
			}
		}

		/**
		 * Returns all resources loaders found in this context configuration.
		 *
		 * @return an array with all resource loaders in this context or an empty array
		 */
		private function getResourceLoaders():Array {
			var result:Array = [];

			// XXX should we check all resource loaders, or just the ones that are also object factory post
			// processors? for now we check the latter

			// check for resource loaders in the object definitions
			var postProcessorNames:Array = getObjectNamesForType(IObjectFactoryPostProcessor);
			for each (var postProcessorName:String in postProcessorNames) {
				var postProcessor:IObjectFactoryPostProcessor = getObject(postProcessorName);
				if (postProcessor is IResourceLoader) {
					result.push(postProcessor);
				}
			}

			// check for resource loaders in the explicit singletons
			for each (var singleton:Object in explicitSingletonCache) {
				if ((singleton is IObjectFactoryPostProcessor) && (singleton is IResourceLoader)) {
					result.push(singleton);
				}
			}

			return result;
		}

		private function resourceLoadQueue_completeHandler(event:OperationEvent = null):void {
			logger.debug("Done loading resources.");
			dispatchEvent(new ApplicationContextLifeCycleEvent(ApplicationContextLifeCycleEvent.RESOURCES_LOADED));
			invokeObjectFactoryPostProcessors();
			dispatchEvent(new ApplicationContextLifeCycleEvent(ApplicationContextLifeCycleEvent.FACTORY_POSTPROCESSORS_EXECUTED));
			preInstantiateSingletons();
			dispatchEvent(new ApplicationContextLifeCycleEvent(ApplicationContextLifeCycleEvent.SINGLETONS_INSTANTIATED));
			setIsReady(true);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose():void {
			if (!isDisposed) {
				DisposeUtils.disposeCollection(_objectFactoryPostProcessors);
				_objectFactoryPostProcessors = null;
				super.dispose();
			}
		}

	}
}
