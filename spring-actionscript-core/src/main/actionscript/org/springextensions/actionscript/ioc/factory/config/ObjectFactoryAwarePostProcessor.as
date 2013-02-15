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
package org.springextensions.actionscript.ioc.factory.config {

	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;

	/**
	 * Post processes object by setting the object container as a property
	 * on the object if it implements <code>IObjectContainerAware</code>.
	 *
	 * @author Christophe Herreman
	 * @docref container-documentation.html#injecting_the_object_factory
	 */
	public class ObjectFactoryAwarePostProcessor implements IObjectPostProcessor {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = getLogger(ObjectFactoryAwarePostProcessor);

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _objectFactory:IObjectFactory;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Constructs a new <code>ObjectFactoryAwarePostProcessor</code> instance.
		 * @param objectFactory the IObjectFactory instance that will be injected into every <code>IObjectContainerAware</code> instance.
		 *
		 */
		public function ObjectFactoryAwarePostProcessor(objectFactory:IObjectFactory) {
			Assert.notNull(objectFactory, "The 'objectFactory' argument must not be null.");
			_objectFactory = objectFactory;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * If the specified object implements the <code>IObjectFactoryAware</code> interface the objectFactory instance
		 * will be injected.
		 * @inheritDoc
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			var objectFactoryAware:IObjectFactoryAware = (object as IObjectFactoryAware);
			if (objectFactoryAware != null) {
				logger.debug("Setting object factory on object '{0}' with name '{1}'", [object, objectName]);
				objectFactoryAware.objectFactory = _objectFactory;
			}
			return object;
		}

		/**
		 * @inheritDoc
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}

	}
}
