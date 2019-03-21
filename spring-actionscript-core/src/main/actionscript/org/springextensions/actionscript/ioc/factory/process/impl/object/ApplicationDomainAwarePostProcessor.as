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
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;

	/**
	 * Post processes object by setting the applicationDomain as a property
	 * on the object if it implements <code>IApplicationDomainAware</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ApplicationDomainAwarePostProcessor implements IObjectPostProcessor {

		private static var logger:ILogger = getClassLogger(ApplicationDomainAwarePostProcessor);

		/**
		 * Creates a new <code>ApplicationDomainAwarePostProcessor</code> instance.
		 * @param objectFactory The <code>IObjectFactory</code> whose <code>applicationDomain</code> property will be used for injection.
		 *
		 */
		public function ApplicationDomainAwarePostProcessor(objectFactory:IObjectFactory) {
			Assert.notNull(objectFactory, "The 'objectFactory' argument must not be null.");
			super();
			_objectFactory = objectFactory;
		}

		private var _objectFactory:IObjectFactory;

		/**
		 * Not used in this implementation.
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}

		/**
		 * Checks if the specified object implements <code>IApplicationDomainAware</code>, if so, injects
		 * the <code>objectFactory.applicationDomain</code> value.
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			var appDomainAware:IApplicationDomainAware = (object as IApplicationDomainAware);
			if (appDomainAware != null) {
				logger.debug("Instance {0} implements IApplicationDomainAware, injecting it with {1}", [object, _objectFactory.applicationDomain]);
				appDomainAware.applicationDomain = _objectFactory.applicationDomain;
			}
			return object;
		}

	}
}
