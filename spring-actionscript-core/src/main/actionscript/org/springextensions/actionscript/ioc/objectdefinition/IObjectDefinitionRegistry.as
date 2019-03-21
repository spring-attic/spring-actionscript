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
package org.springextensions.actionscript.ioc.objectdefinition {
	import flash.system.ApplicationDomain;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	/**
	 * Defines the interface for an object definition registry. This interface contains add methods
	 * needed to work with object definitions.
	 *
	 * @author Christophe Herreman
	 */
	public interface IObjectDefinitionRegistry {

		function get id():String;

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The number of object definitions in this registry.
		 *
		 * @return the number of object definitions in this registry
		 */
		function get numObjectDefinitions():uint;

		/**
		 * The names of the registered object definitions.
		 *
		 * @return an array with all registered object definition names, or an empty array if no definitions are
		 * registered
		 */
		function get objectDefinitionNames():Vector.<String>;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Determines if the object factory contains a definition with the given name.
		 *
		 * @param objectName  The name/id  of the object definition
		 *
		 * @return true if a definition with that name exists
		 *
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition
		 */
		function containsObjectDefinition(objectName:String):Boolean;

		/**
		 *
		 * @param objectName
		 * @return
		 */
		function getCustomConfiguration(objectName:String):*;


		/**
		 * Returns the names of the <code>IObjectDefinitions</code> that have the specified property set to the specified value.<br/>
		 * Optionally the selection may be reversed by setting the <code>returnMatching</code> argument to <code>false</code>.
		 * @param propertyName The specified property name.
		 * @param propertyValue The specified property value.
		 * @param returnMatching Determines if the <code>IObjectdefinition</code> needs to match or not the specified property and value to be added to the result.
		 * @return A vector of object names.
		 */
		function getDefinitionNamesWithPropertyValue(propertyName:String, propertyValue:*, returnMatching:Boolean=true):Vector.<String>;

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
		 *
		 * @param objectDefinition
		 * @return
		 *
		 */
		function getObjectDefinitionName(objectDefinition:IObjectDefinition):String;

		/**
		 * @param type
		 * @return
		 */
		function getObjectDefinitionNamesForType(type:Class):Vector.<String>;

		/**
		 * Returns the object definitions in this registry that are of
		 * the specified <code>Class</code>.
		 * @param type The specified <code>Class</code> that is searched for.
		 * @return an array containing definitions that implement the specified <code>Class</code>.
		 */
		function getObjectDefinitionsForType(type:Class):Vector.<IObjectDefinition>;
		
		/**
		 * Returns a <code>Vector.&lt;IObjectDefinition&gt;</code> that contains all the object definitions that have
		 * a dependency on the given definition name.
		 * @param definitionName The specified definition name.
		 * @return a <code>Vector.&lt;IObjectDefinition&gt;</code> that contains all the object definitions that have
		 * a dependency on the given definition name.
		 */
		function getObjectDefinitionsThatReference(definitionName:String):Vector.<IObjectDefinition>;

		/**
		 *
		 * @param metadataNames
		 * @return
		 */
		function getObjectDefinitionsWithMetadata(metadataNames:Vector.<String>):Vector.<IObjectDefinition>;
		/**
		 *
		 * @return
		 */
		function getPrototypes():Vector.<String>;

		/**
		 *
		 * @return
		 */
		function getSingletons(lazyInit:Boolean=false):Vector.<String>;

		/**
		 * Returns the type that is defined on the object definition.
		 *
		 * @param objectName  The name/id  of the object definition
		 *
		 * @return the class that is used to construct the object
		 *
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition
		 */
		function getType(objectName:String):Class;

		/**
		 * Returns a unique list of all <code>Classes</code> that are used by the <code>IObjectDefinitions</code>
		 * in the current <code>IObjectDefinitionRegistry</code>.
		 * @return A unique list of all <code>Classes</code>.
		 */
		function getUsedTypes():Vector.<Class>;

		/**
		 * Determines if the definition with the given name is a prototype.
		 *
		 * @param objectName  The name/id  of the object definition
		 *
		 * @return true if the definitions is defined as a prototype
		 *
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition
		 */
		function isPrototype(objectName:String):Boolean;

		/**
		 * Determines if the definition with the given name is a singleton.
		 *
		 * @param objectName  The name/id  of the object definition
		 *
		 * @return true if the definitions is defined as a singleton
		 *
		 * @see org.springextensions.actionscript.ioc.IObjectDefinition
		 */
		function isSingleton(objectName:String):Boolean;

		/**
		 *
		 * @param objectName
		 * @param configurator
		 */
		function registerCustomConfiguration(objectName:String, configurator:*):void;

		/**
		 * Registers the given objectDefinition under the given name.
		 *
		 * @param objectName the name under which the object definition should be stored
		 * @param objectDefinition the object definition to store
		 */
		function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition, override:Boolean=true):void;

		/**
		 * Removes the definition with the given name from the registry
		 *
		 * @param objectName  The name/id of the definition to remove
		 */
		function removeObjectDefinition(objectName:String):IObjectDefinition;
	}
}
