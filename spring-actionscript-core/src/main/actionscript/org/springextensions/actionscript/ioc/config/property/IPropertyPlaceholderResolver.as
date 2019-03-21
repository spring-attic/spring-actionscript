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
package org.springextensions.actionscript.ioc.config.property {
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.MethodInvocation;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.PropertyDefinition;


	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IPropertyPlaceholderResolver {

		function get ignoreUnresolvablePlaceholders():Boolean;

		/**
		 * @private
		 */
		function set ignoreUnresolvablePlaceholders(value:Boolean):void;

		function get propertiesProvider():IPropertiesProvider;

		/**
		 * @private
		 */
		function set propertiesProvider(value:IPropertiesProvider):void;

		function get regExp():RegExp;

		/**
		 * @private
		 */
		function set regExp(value:RegExp):void;

		function resolvePropertyPlaceholders(value:String, regExp:RegExp=null, properties:IPropertiesProvider=null):String;
		
		function resolvePropertyDefinitionPlaceHolders(property:PropertyDefinition, objectFactory:IObjectFactory):PropertyDefinition;
		
		function resolveArgumentPropertyPlaceHolders(argumentDefinition:ArgumentDefinition, objectFactory:IObjectFactory, cloneArgument:Boolean=true):ArgumentDefinition;
		
		function resolveMethodInvocationPlaceHolders(methodInvocation:MethodInvocation, objectFactory:IObjectFactory):MethodInvocation;
	}
}
