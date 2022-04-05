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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser {
	import flash.utils.Dictionary;

	import org.as3commons.async.task.impl.ForBlock;
	import org.as3commons.async.task.impl.WhileBlock;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	/**
	 * Converts a &lt;for/&gt; or &lt;while/&gt; element to a corresponding <code>IObjectDefinition</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
	 */
	public class BlockNodeParser extends TaskNodeParser {

		private static const logger:ILogger = getClassLogger(BlockNodeParser);

		public static const endMethod:String = "end";

		private var _nodeClassLookups:Dictionary;

		public function get nodeClassLookups():Dictionary {
			return _nodeClassLookups
		}

		/**
		 * Creates a new <code>BlockNodeParser</code> instance.
		 */
		public function BlockNodeParser() {
			super();
			_nodeClassLookups = new Dictionary();
			_nodeClassLookups[TaskNamespaceHandler.FOR_ELEMENT] = ForBlock;
			_nodeClassLookups[TaskNamespaceHandler.WHILE_ELEMENT] = WhileBlock;
		}

		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(_nodeClassLookups[String(node.localName())]);

			addConstructorArgs(builder, node);

			addMethodInvocations(builder, node);
			logger.debug("Parsed object definition: {0}", [builder.objectDefinition]);
			return builder.objectDefinition;
		}

		override protected function addMethodInvocations(builder:ObjectDefinitionBuilder, startNode:XML):void {
			super.addMethodInvocations(builder, startNode);
			builder.addMethodInvocation(endMethod);
		}

		private function addConstructorArgs(builder:ObjectDefinitionBuilder, node:XML):void {
			var nodeName:String = String(node.localName());
			var ref:String;
			var qName:QName;
			var elms:XMLList;
			switch (nodeName) {
				case TaskNamespaceHandler.FOR_ELEMENT:
					qName = new QName(node.namespace(), TaskNamespaceHandler.COUNT_PROVIDER_ELEMENT);
					elms = node.descendants(qName);
					qName = new QName(node.namespace(), TaskNamespaceHandler.REF_ELEMENT);
					ref = elms[0].descendants(qName)[0].text();
					break;
				case TaskNamespaceHandler.WHILE_ELEMENT:
				case TaskNamespaceHandler.IF_ELEMENT:
					qName = new QName(node.namespace(), TaskNamespaceHandler.CONDITION_ELEMENT);
					elms = node.descendants(qName);
					qName = new QName(node.namespace(), TaskNamespaceHandler.REF_ELEMENT);
					ref = elms[0].descendants(qName)[0].text();
					break;
			}
			if (ref != null) {
				builder.addConstructorArgValue(new RuntimeObjectReference(ref));
			}
		}


	}
}
