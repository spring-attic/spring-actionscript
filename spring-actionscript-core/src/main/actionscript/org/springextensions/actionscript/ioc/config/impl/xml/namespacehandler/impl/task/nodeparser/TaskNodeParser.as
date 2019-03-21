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

	import org.as3commons.async.task.impl.Task;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.task.TaskNamespaceHandler;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_task;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ArgumentDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	use namespace spring_actionscript_task;

	/**
	 * Converts a &lt;task/&gt; node into a corresponding <code>IObjectDefinition</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class TaskNodeParser extends AbstractTaskDefinitionParser implements IApplicationDomainAware {

		private static const logger:ILogger = getClassLogger(TaskNodeParser);

		import flash.system.ApplicationDomain;
		import flash.utils.Dictionary;

		private var _methodInvocations:Dictionary;

		public function get methodInvocations():Dictionary {
			return _methodInvocations;
		}

		public static const nextMethod:String = "next";
		public static const andMethod:String = "and";
		public static const ifMethod:String = "if_";
		public static const forMethod:String = "for_";
		public static const whileMethod:String = "while_";
		public static const exitMethod:String = "exit";
		public static const resetMethod:String = "reset";
		public static const pauseMethod:String = "pause";

		/**
		 * Creates a new <code>TaskNodeParser</code> instance.
		 */
		public function TaskNodeParser() {
			super();
			_methodInvocations = new Dictionary();
			_methodInvocations[TaskNamespaceHandler.NEXT_ELEMENT] = addNextMethod;
			_methodInvocations[TaskNamespaceHandler.AND_ELEMENT] = addAndMethod;
			_methodInvocations[TaskNamespaceHandler.EXIT_ELEMENT] = addExitMethod;
			_methodInvocations[TaskNamespaceHandler.RESET_ELEMENT] = addResetMethod;
			_methodInvocations[TaskNamespaceHandler.PAUSE_ELEMENT] = addPauseMethod;
			_methodInvocations[TaskNamespaceHandler.IF_ELEMENT] = addIfMethod;
			_methodInvocations[TaskNamespaceHandler.FOR_ELEMENT] = addForMethod;
			_methodInvocations[TaskNamespaceHandler.WHILE_ELEMENT] = addWhileMethod;
		}

		private var _applicationDomain:ApplicationDomain;

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		override protected function parseInternal(node:XML, context:IXMLObjectDefinitionsParser):IObjectDefinition {
			_applicationDomain = context.applicationContext.applicationDomain;
			var cls:Class = Task;
			if (node.attribute(XMLObjectDefinitionsParser.CLASS_ATTRIBUTE).length() > 0) {
				cls = ClassUtils.forName(node.attribute(XMLObjectDefinitionsParser.CLASS_ATTRIBUTE).text(), _applicationDomain);
			}
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(cls);

			context.parseObjectDefinition(node, builder.objectDefinition);
			addMethodInvocations(builder, node);
			logger.debug("Parsed object definition: {0}", [builder.objectDefinition]);
			return builder.objectDefinition;
		}

		protected function addMethodInvocations(builder:ObjectDefinitionBuilder, startNode:XML):void {
			for each (var subNode:XML in startNode.children()) {
				var func:Function = _methodInvocations[String(subNode.localName())];
				if (func != null) {
					func(builder, subNode);
				}
			}
		}

		private function addNextMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.attribute(TaskNamespaceHandler.COMMAND_ATTR);
			if (!StringUtils.hasText(ref)) {
				if (node.children().length() > 0) {
					ref = node.children()[0].@id;
				}
			}
			builder.addMethodInvocation(nextMethod, [null, new RuntimeObjectReference(ref)]);
		}

		private function addAndMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.attribute(TaskNamespaceHandler.COMMAND_ATTR);
			if (!StringUtils.hasText(ref)) {
				if (node.children().length() > 0) {
					ref = node.children()[0].@id;
				}
			}
			builder.addMethodInvocation(andMethod, [new RuntimeObjectReference(ref)]);
		}

		private function addExitMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			builder.addMethodInvocation(exitMethod);
		}

		private function addResetMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			builder.addMethodInvocation(resetMethod);
		}

		private function addPauseMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var lst:XML = node.children()[0];
			var ref:String = lst[0].attribute(TaskNamespaceHandler.ID_ATTR);
			builder.addMethodInvocation(pauseMethod, [0, new RuntimeObjectReference(ref)]);
		}

		private function addIfMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.@[TaskNamespaceHandler.ID_ATTR];
			builder.addMethodInvocation(ifMethod, [null, new RuntimeObjectReference(ref)]);
		}

		private function addWhileMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.@[TaskNamespaceHandler.ID_ATTR];
			builder.addMethodInvocation(whileMethod, [null, new RuntimeObjectReference(ref)]);
		}

		private function addForMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.@[TaskNamespaceHandler.ID_ATTR];
			builder.addMethodInvocation(forMethod, [null, null, new RuntimeObjectReference(ref)]);
		}

	}
}
