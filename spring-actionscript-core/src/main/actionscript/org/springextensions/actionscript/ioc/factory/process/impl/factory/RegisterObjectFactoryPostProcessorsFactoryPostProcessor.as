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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class RegisterObjectFactoryPostProcessorsFactoryPostProcessor extends AbstractOrderedFactoryPostProcessor {

		private static var logger:ILogger = getClassLogger(RegisterObjectFactoryPostProcessorsFactoryPostProcessor);

		public function RegisterObjectFactoryPostProcessorsFactoryPostProcessor(orderPosition:int) {
			super(orderPosition);
		}

		override public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			var applicationContext:IApplicationContext = objectFactory as IApplicationContext;
			if ((applicationContext != null) && (objectFactory.objectDefinitionRegistry != null)) {
				var objectNames:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IObjectFactoryPostProcessor);
				for each (var name:String in objectNames) {
					logger.debug("Registering object factory postprocessor '{0}'", [name]);
					applicationContext.addObjectFactoryPostProcessor(IObjectFactoryPostProcessor(objectFactory.getObject(name)));
				}
			}
			return null;
		}
	}
}
