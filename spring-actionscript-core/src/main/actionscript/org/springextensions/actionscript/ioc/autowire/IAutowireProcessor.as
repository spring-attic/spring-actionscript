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
package org.springextensions.actionscript.ioc.autowire {
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 * Interface that needs to be implemented by objects that can perform autowiring
	 * on arbitrary objects.
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IAutowireProcessor {

		/**
		 * Performs autowiring on the specified object instance, the specified <code>IObjectDefinition</code> can optionally
		 * be used to retrieve autowiring information from.
		 * @param object The instance that needs to be autowired.
		 * @param objectDefinition The <code>IObjectDefinition</code> associated with the object that needs to be created.
		 * @param objectName The name of the object as it is registered in a container.
		 */
		function autoWire(object:Object, objectDefinition:IObjectDefinition = null, objectName:String = null):void;

		/**
		 * <p>Method that can be invoked by an <code>IObjectFactory</code> implementation for any type of pre-processing
		 * of the <code>IObjectDefinition</code> associated with the object that needs to be created.</p>
		 * <p>Typically this method can be used to do some kind of constructor configuration.</p>
		 * @param objectDefinition The <code>IObjectDefinition</code> that describes the object that will be created.
		 */
		function preprocessObjectDefinition(objectDefinition:IObjectDefinition):void;

		/**
		 *
		 * @param clazz
		 * @return
		 */
		function findAutowireCandidateName(clazz:Class):String;
	}
}
