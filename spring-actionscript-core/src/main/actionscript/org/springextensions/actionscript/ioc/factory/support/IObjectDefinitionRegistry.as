/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.support {
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	
	/**
	 * Defines the interface for an object definition registry. This interface contains add methods
	 * needed to work with object definitions.
	 *
	 * @author Christophe Herreman
	 */
	public interface IObjectDefinitionRegistry {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The names of the registered object definitions.
		 *
		 * @return an array with all registered object definition names, or an empty array if no definitions are
		 * registered
		 */
		function get objectDefinitionNames():Array;

		/**
		 * The number of object definitions in this registry.
		 *
		 * @return the number of object definitions in this registry
		 */
		function get numObjectDefinitions():uint;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Registers the given objectDefinition under the given name.
		 *
		 * @param objectName the name under which the object definition should be stored
		 * @param objectDefinition the object definition to store
		 */
		function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void;
		
		/**
		 * Removes the definition with the given name from the registry
		 *
		 * @param objectName  The name/id of the definition to remove
		 */
		function removeObjectDefinition(objectName:String):void;
		
		/**
		 * Returns the object definition registered with the given name. If the object
		 * definition does not exist <code>undefined</code> will be returned.
		 *
		 * @throws org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError if the object definition was not found in the registry
		 *
		 * @param objectName the name/id of the definition to retrieve
		 *
		 * @return the registered object definition
		 */
		function getObjectDefinition(objectName:String):IObjectDefinition;
		
		/**
		 * Determines if an object definition with the given name exists
		 *
		 * @param objectName  The name/id of the object definition
		 */
		function containsObjectDefinition(objectName:String):Boolean;
		
		/**
		 * Returns the object definitions in this registry that are of
		 * the specified <code>Class</code>.
		 * @param type The specified <code>Class</code> that is searched for.
		 * @return an array containing definitions that implement the specified <code>Class</code>.
		 */
		function getObjectDefinitionsOfType(type:Class):Array;
		
		
		/**
		 * Returns a unique list of all <code>Classes</code> that are used by the <code>IObjectDefinitions</code>
		 * in the current <code>IObjectDefinitionRegistry</code>.
		 * @return A unique list of all <code>Classes</code>.
		 */
		function getUsedTypes():Array;
	
	}
}
