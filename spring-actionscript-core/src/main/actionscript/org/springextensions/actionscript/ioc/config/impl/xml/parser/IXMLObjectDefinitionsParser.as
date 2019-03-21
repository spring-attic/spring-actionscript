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
package org.springextensions.actionscript.ioc.config.impl.xml.parser {
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.INamespaceHandler;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IXMLObjectDefinitionsParser extends IApplicationContextAware {

		function get nodeParsers():Vector.<INodeParser>;

		function addNamespaceHandler(handler:INamespaceHandler):void;

		function addNamespaceHandlers(handlers:Vector.<INamespaceHandler>):void;

		function addNodeParser(parser:INodeParser):void;

		function generateObjectName(definition:IObjectDefinition):String;

		function parse(xml:XML, defaultObjectDefinition:IBaseObjectDefinition=null):Object;

		function parseAndRegisterObjectDefinition(node:XML):String;

		function parseNode(node:XML):void;

		function parseObjectDefinition(xml:XML, objectDefinition:IObjectDefinition=null):IObjectDefinition;

		function parseProperties(objectDefinition:IObjectDefinition, xml:XML):void;

		function parseProperty(node:XML):*;

		function parsePropertyValue(node:XML):*;

		function parseMethodInvocations(objectDefinition:IObjectDefinition, xml:XML):void;

		function parseConstructorArguments(objectDefinition:IObjectDefinition, xml:XML):void;

		function registerObjectDefinition(objectName:String, objectDefinition:IObjectDefinition):void;

		function parseAttributes(objectDefinition:IObjectDefinition, xml:XML):void;
	}
}
