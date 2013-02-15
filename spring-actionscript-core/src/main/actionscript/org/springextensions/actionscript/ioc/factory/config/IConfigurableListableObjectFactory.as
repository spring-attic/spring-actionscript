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

	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IListableObjectFactory;

	/**
	 * This interface combines IConfigurableObjectFactory and IListableObjectFactory
	 *
	 * @author Christophe Herreman
	 */
	public interface IConfigurableListableObjectFactory extends IConfigurableObjectFactory, IListableObjectFactory {

		/**
		 * Instantiates all definitions that are defined as singleton and are not lazy.
		 */
		function preInstantiateSingletons():void;
		
		/**
		 * Registers a singleton object in the factory. This is an object that needs to be managed by the container
		 * but does not have an object definition.
		 * @param name The name under which the instance will be registered.
		 * @param object The specified instance.
		 */
		function registerSingleton(name:String, object:Object):void;
	}
}
