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

	/**
	 * <p>Allows for custom modification of an application context's objects definitions,
	 * adapting the objects property values of the context's underlying object factory.
	 * </p>
	 * <p>Application contexts can auto-detect IObjectFactoryPostProcessor objects in
	 * their object definitions and apply them before any other objects get created.
	 * </p>
	 * @author Christophe Herreman
	 * @docref container-documentation.html#customizing_with_iobjectfactorypostprocessor
	 */
	public interface IObjectFactoryPostProcessor {

		/**
		 * Modify the application context's internal object factory after its standard
		 * initialization. All object definitions will have been loaded, but no objects
		 * will have been instantiated yet. This allows for overriding or adding
		 * properties even to eager-initializing objects.
		 * @param objectFactory the object factory used by the application context
		 */
		function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void;
	}
}
