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
package org.springextensions.actionscript.ioc.factory.process.impl.object {

	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;

	/**
	 * Post processes object by setting the object container as a property
	 * on the object if it implements <code>IObjectContainerAware</code>.
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectFactoryAwarePostProcessor implements IObjectPostProcessor {

		private static var logger:ILogger = getClassLogger(ObjectFactoryAwarePostProcessor);

		private var _objectFactory:IObjectFactory;

		/**
		 * Constructs a new <code>ObjectFactoryAwarePostProcessor</code> instance.
		 * @param objectFactory the IObjectFactory instance that will be injected into every <code>IObjectContainerAware</code> instance.
		 *
		 */
		public function ObjectFactoryAwarePostProcessor(objectFactory:IObjectFactory) {
			Assert.notNull(objectFactory, "The 'objectFactory' argument must not be null.");
			_objectFactory = objectFactory;
		}

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
