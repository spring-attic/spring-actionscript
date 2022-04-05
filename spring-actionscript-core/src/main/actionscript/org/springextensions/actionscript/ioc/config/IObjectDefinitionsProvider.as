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
package org.springextensions.actionscript.ioc.config {

	import org.as3commons.async.operation.IOperation;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;

	/**
	 * Describes an object that can create a collection of <code>ObjectDefinitions</code>, either synchronously or asynchronously.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IObjectDefinitionsProvider {
		function createDefinitions():IOperation;
		function get objectDefinitions():Object;
		function set objectDefinitions(value:Object):void;
		function get propertyURIs():Vector.<TextFileURI>;
		function get propertiesProvider():IPropertiesProvider;
		function get defaultObjectDefinition():IBaseObjectDefinition;
		function set defaultObjectDefinition(value:IBaseObjectDefinition):void;
	}
}
