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
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;

	/**
	 * <code>IObjectPostProcessor</code> implementation that checks for objects that implement the <code>IApplicationContextAware</code>
	 * interface and injects them with the provided <code>IApplicationContext</code> instance.
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 * @inheritDoc
	 */
	public class ApplicationContextAwareObjectPostProcessor implements IObjectPostProcessor {

		private static var logger:ILogger = getClassLogger(ApplicationContextAwareObjectPostProcessor);

		private var _applicationContext:IApplicationContext;

		/**
		 * Creates a new <code>ApplicationContextAwareProcessor</code> instance.
		 * @param applicationContext The <code>IApplicationContext</code> instance that will be injected.
		 */
		public function ApplicationContextAwareObjectPostProcessor(applicationContext:IApplicationContext) {
			Assert.notNull(applicationContext, "applicationContext argument must not be null");
			_applicationContext = applicationContext;
		}

		/**
		 * <p>If the specified object implements the <code>IApplicationContextAware</code> interface
		 * the <code>IApplicationContext</code> instance is injected.</p>
		 * @inheritDoc
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			var applicationContextAware:IApplicationContextAware = (object as IApplicationContextAware);
			if ((applicationContextAware != null) && (applicationContextAware.applicationContext == null)) {
				logger.debug("Instance {0} implements IApplicationContextAware, injecting it with {1}", [object, _applicationContext]);
				applicationContextAware.applicationContext = _applicationContext;
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
