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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task {

	import avmplus.getQualifiedClassName;

	import flash.utils.getDefinitionByName;

	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.AbstractNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.BlockNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.CountProviderNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.IfNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadURLNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.LoadURLStreamNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.NullReturningNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.PauseCommandNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.nodeparser.TaskNodeParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_task;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.util.Environment;

	/**
	 * Converts specialized <code>Task</code> related markup to <code>ObjectDefinitions</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class TaskNamespaceHandler extends AbstractNamespaceHandler {

		private var _preprocessed:Boolean = false;

		/* Composite command element */

		public static const COMPOSITE_COMMAND_ELEMENT:String = "composite-command";

		/* composite command attributes */

		public static const FAIL_ON_FAULT_ATTR:String = "fail-on-fault";
		public static const KIND_ATTR:String = "kind";

		/* Operation element names */

		public static const LOAD_URL_ELEMENT:String = "load-url";
		public static const LOAD_URL_STREAM_ELEMENT:String = "load-url-stream";
		public static const LOAD_PROPERTIES_BATCH_ELEMENT:String = "load-properties-batch";
		public static const LOAD_PROPERTIES_ELEMENT:String = "load-properties";
		public static const LOAD_STYLE_MODULE_ELEMENT:String = "load-style-module";
		public static const LOAD_RESOURCE_MODULE_ELEMENT:String = "load-resource-module";
		public static const LOAD_MODULE_ELEMENT:String = "load-module";
		public static const LOAD_RESOURCE_BUNDLE_ELEMENT:String = "load-resource-bundle";
		public static const HTTP_SERVICE_ELEMENT:String = "http-service-operation";
		public static const NET_CONNECTION_ELEMENT:String = "net-connection-operation";
		public static const REMOTE_OBJECT_ELEMENT:String = "remote-object-operation";
		public static const WEB_SERVICE_ELEMENT:String = "web-service-operation";

		/* load-url attributes */

		public static const URL_ATTR:String = "url";
		public static const DATA_FORMAT_ATTR:String = "data-format";

		/* load-style-module attributes */

		public static const UPDATE_ATTR:String = "update";
		public static const APPLICATION_DOMAIN_ATTR:String = "application-domain";
		public static const SECURITY_DOMAIN_ATTR:String = "security-domain";
		public static const FLEX_MODULE_FACTORY_ATTR:String = "flex-module-factory";

		/* load-properties-batch */

		public static const LOCATIONS_ATTR:String = "locations";
		public static const IGNORE_RESOURCE_NOT_FOUND_ATTR:String = "ignore-resource-not-found";
		public static const PREVENT_CACHE_ATTR:String = "prevent-cache";

		/* load-properties */

		public static const LOCATION_ATTR:String = "location";

		/* Command element names */

		public static const COMMAND_ELEMENT:String = "command";

		/* Task namespace element names */

		public static const TASK_ELEMENT:String = "task";

		public static const NEXT_ELEMENT:String = "next";

		public static const AND_ELEMENT:String = "and";

		public static const IF_ELEMENT:String = "if";

		public static const ELSE_ELEMENT:String = "else";

		public static const FOR_ELEMENT:String = "for";

		public static const WHILE_ELEMENT:String = "while";

		public static const EXIT_ELEMENT:String = "exit";

		public static const RESET_ELEMENT:String = "reset";

		public static const PAUSE_ELEMENT:String = "pause";

		public static const PAUSECOMMAND_ELEMENT:String = "pause-command";

		public static const CONDITION_ELEMENT:String = "condition";

		public static const COUNT_PROVIDER_ELEMENT:String = "count-provider";

		public static const REF_ELEMENT:String = "ref";

		/* Task namespace attribute names */

		public static const ID_ATTR:String = "id";

		public static const REF_ATTR:String = "ref";

		public static const CONDITION_ATTR:String = "condition";

		public static const COMMAND_ATTR:String = "command";

		public static const COUNT_ATTR:String = "count";

		public static const COUNT_PROVIDER_ATTR:String = "count-provider";

		public static const DURATION_ATTR:String = "duration";

		private static const logger:ILogger = getClassLogger(TaskNamespaceHandler);

		/**
		 * Creates a new <code>TaskNamespaceHandler</code> instance.
		 */
		public function TaskNamespaceHandler() {
			super(spring_actionscript_task);
			registerObjectDefinitionParser(TASK_ELEMENT, new TaskNodeParser());
			registerObjectDefinitionParser(NEXT_ELEMENT, new NullReturningNodeParser());
			registerObjectDefinitionParser(AND_ELEMENT, new NullReturningNodeParser());
			registerObjectDefinitionParser(PAUSE_ELEMENT, new NullReturningNodeParser());
			registerObjectDefinitionParser(PAUSECOMMAND_ELEMENT, new PauseCommandNodeParser());
			registerObjectDefinitionParser(IF_ELEMENT, new IfNodeParser());
			registerObjectDefinitionParser(FOR_ELEMENT, new BlockNodeParser());
			registerObjectDefinitionParser(WHILE_ELEMENT, new BlockNodeParser());
			registerObjectDefinitionParser(COUNT_PROVIDER_ELEMENT, new CountProviderNodeParser());
			registerObjectDefinitionParser(LOAD_URL_ELEMENT, new LoadURLNodeParser());
			registerObjectDefinitionParser(LOAD_URL_STREAM_ELEMENT, new LoadURLStreamNodeParser());
			registerObjectDefinitionParser(REF_ELEMENT, new NullReturningNodeParser());
			registerObjectDefinitionParser(CONDITION_ELEMENT, new NullReturningNodeParser());
		}

		/**
		 * <p>When invoked for the first time this method will create a <code>TaskElementsPreprocessor</code> and preprocess
		 * the incoming <code>XML</code>.</p>
		 * @see org.springextensions.actionscript.core.task.xml.TaskElementsPreprocessor TaskElementsPreprocessor
		 * @inheritDoc
		 */
		override public function parse(node:XML, parser:IXMLObjectDefinitionsParser):IObjectDefinition {
			if (!_preprocessed) {
				new TaskElementsPreprocessor().preprocess(getRoot(node));
				_preprocessed = true;
				logger.debug("Pre-processed XML");
			}
			for each (var subNode:XML in node.descendants()) {
				parser.parseNode(subNode);
			}
			return super.parse(node, parser);
		}

		/**
		 * Returns the root node for the specified <code>XML</code> node by recursively retrieving the parent node.
		 * @param xml The specified <code>XML</code> node
		 * @return The root node
		 */
		public function getRoot(xml:XML):XML {
			while (xml.parent() != null) {
				xml = xml.parent();
			}
			return xml;
		}

		public static function refOrNull(node:XML, attributeName:String):RuntimeObjectReference {
			var attr:String = node.attribute(attributeName);
			if (StringUtils.hasText(attr)) {
				return new RuntimeObjectReference(attr);
			} else {
				return null;
			}
		}

	}
}
