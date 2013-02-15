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
package org.springextensions.actionscript.core.task.xml.parser {

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.core.task.support.Task;
	import org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler;
	import org.springextensions.actionscript.core.task.xml.spring_actionscript_task;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.support.ObjectDefinitionBuilder;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	use namespace spring_actionscript_task;

	/**
	 * Converts a &lt;task/&gt; node into a corresponding <code>IObjectDefinition</code>.
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.ioc.IObjectDefinition IObjectDefinition
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class TaskNodeParser extends AbstractTaskDefinitionParser implements IApplicationDomainAware {

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
			init();
		}

		/**
		 * Initializes the current <code>TaskNodeParser</code>.
		 */
		protected function init():void {
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

		override protected function parseInternal(node:XML, context:XMLObjectDefinitionsParser):IObjectDefinition {
			_applicationDomain = context.applicationContext.applicationDomain;
			var cls:Class = Task;
			if (node.attribute(XMLObjectDefinitionsParser.CLASS_ATTRIBUTE).length() > 0) {
				cls = ClassUtils.forName(node.attribute(XMLObjectDefinitionsParser.CLASS_ATTRIBUTE).text(), _applicationDomain);
			}
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(cls);

			context.parseObjectDefinition(node, builder.objectDefinition);
			addMethodInvocations(builder, node);

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

		protected function addNextMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.attribute(TaskNamespaceHandler.COMMAND_ATTR);
			if (!StringUtils.hasText(ref)) {
				if (node.children().length() > 0) {
					ref = node.children()[0].@id;
				}
			}
			builder.addMethodInvocation(nextMethod, [new RuntimeObjectReference(ref)]);
		}

		protected function addAndMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.attribute(TaskNamespaceHandler.COMMAND_ATTR);
			if (!StringUtils.hasText(ref)) {
				if (node.children().length() > 0) {
					ref = node.children()[0].@id;
				}
			}
			builder.addMethodInvocation(andMethod, [new RuntimeObjectReference(ref)]);
		}

		protected function addExitMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			builder.addMethodInvocation(exitMethod);
		}

		protected function addResetMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			builder.addMethodInvocation(resetMethod);
		}

		protected function addPauseMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var lst:XML = node.children()[0];
			var ref:String = lst[0].attribute(TaskNamespaceHandler.ID_ATTR);
			builder.addMethodInvocation(pauseMethod, [0, new RuntimeObjectReference(ref)]);
		}

		protected function addIfMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.@[TaskNamespaceHandler.ID_ATTR];
			builder.addMethodInvocation(ifMethod, [null, new RuntimeObjectReference(ref)]);
		}

		protected function addWhileMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.@[TaskNamespaceHandler.ID_ATTR];
			builder.addMethodInvocation(whileMethod, [null, new RuntimeObjectReference(ref)]);
		}

		protected function addForMethod(builder:ObjectDefinitionBuilder, node:XML):void {
			var ref:String = node.@[TaskNamespaceHandler.ID_ATTR];
			builder.addMethodInvocation(forMethod, [null, null, new RuntimeObjectReference(ref)]);
		}

	}
}
