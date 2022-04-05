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
package org.springextensions.actionscript.ioc.factory.process {

	/**
	 * Classes that implement the <code>IObjectPostProcessor</code> interface are <em>special</em>, and so they are treated differently by the container.
	 * All <code>IObjectPostProcessors</code> and their directly referenced objects will be instantiated on startup, as part of the special startup
	 * phase of the ApplicationContext, then all those <code>IObjectPostProcessors</code> will be registered in a sorted fashion - and applied to
	 * all further objects.
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IObjectPostProcessor {

		/**
		 * This method is invoked right <em>before</em> the <code>IInitializingObject</code> and <code>initMethod</code> logic
		 * is invoked in the wiring pipeline.
		 * @param object The instance that is being configured by the object factory
		 * @param objectName The name of the object as found in the <code>IObjectFactory's</code> configuration
		 * @see org.springextensions.actionscript.ioc.factory.IInitializingObject IInitializingObject
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition#initMethod() IObjectDefinition.initMethod
		 */
		function postProcessBeforeInitialization(object:*, objectName:String):*;

		/**
		 * This method is invoked right <em>after</em> the <code>IInitializingObject</code> and <code>initMethod</code> logic
		 * is invoked in the wiring pipeline.
		 * @param object The instance that is being configured by the object factory
		 * @param objectName The name of the object definition as found in the <code>IObjectFactory's</code> configuration
		 * @see org.springextensions.actionscript.ioc.factory.IInitializingObject IInitializingObject
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition#initMethod() IObjectDefinition.initMethod
		 */
		function postProcessAfterInitialization(object:*, objectName:String):*;
	}
}
