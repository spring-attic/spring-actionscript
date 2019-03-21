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

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistryAware;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ObjectDefinitionRegistryAwareObjectPostProcessor implements IObjectPostProcessor {

		private static var logger:ILogger = getClassLogger(ObjectDefinitionRegistryAwareObjectPostProcessor);

		private var _objectDefinitionRegistry:IObjectDefinitionRegistry;

		/**
		 * Creates a new <code>ObjectDefinitionRegistryAwareObjectPostProcessor</code> instance.
		 */
		public function ObjectDefinitionRegistryAwareObjectPostProcessor(objectDefinitionRegistry:IObjectDefinitionRegistry) {
			super();
		}

		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			if (object is IObjectDefinitionRegistryAware) {
				logger.debug("Instance {0} implements IObjectDefinitionRegistryAware, injecting it with {1}", [object, _objectDefinitionRegistry]);
				IObjectDefinitionRegistryAware(object).objectDefinitionRegistry = _objectDefinitionRegistry;
			}
			return object;
		}

		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}

	}
}
