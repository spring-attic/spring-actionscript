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
package org.springextensions.actionscript.core.task.xml {
	import flash.utils.Dictionary;

	import mx.utils.UIDUtil;

	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;

	/**
	 * Normalizes <code>Task</code> specific markup so it will be ready to be converted by the <code>TaskNamespaceHandler</code>.
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler TaskNamespaceHandler
	 * @docref the_operation_api.html#the_task_namespace_handler
	 */
	public class TaskElementsPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private var _nodeFunctions:Dictionary;

		/**
		 * Creates a new <code>TaskElementsPreprocessor</code> instance.
		 */
		public function TaskElementsPreprocessor() {
			super();
			init();
		}

		/**
		 * Initializes the current <code>TaskElementsPreprocessor</code>.
		 */
		protected function init():void {
			_nodeFunctions = new Dictionary();
			_nodeFunctions[TaskNamespaceHandler.AND_ELEMENT] = preprocessAndOrNextElement;
			_nodeFunctions[TaskNamespaceHandler.NEXT_ELEMENT] = preprocessAndOrNextElement;
			_nodeFunctions[TaskNamespaceHandler.COMPOSITE_COMMAND_ELEMENT] = preprocessCompositeCommandElement;
			_nodeFunctions[TaskNamespaceHandler.TASK_ELEMENT] = preprocessTaskElement;
			_nodeFunctions[TaskNamespaceHandler.IF_ELEMENT] = preprocessIfElement;
			_nodeFunctions[TaskNamespaceHandler.FOR_ELEMENT] = preprocessForElement;
			_nodeFunctions[TaskNamespaceHandler.WHILE_ELEMENT] = preprocessWhileElement;
			_nodeFunctions[TaskNamespaceHandler.PAUSE_ELEMENT] = preprocessPauseElement;
		}

		public function preprocess(xml:XML):XML {
			var objectNodes:XMLList = xml.descendants();

			for each (var node:XML in objectNodes) {
				var name:String = String(node.localName());
				if (_nodeFunctions[name] != null) {
					node = preprocessNode(node);
				}
			}
			return xml;
		}

		public function preprocessNode(node:XML):XML {
			var func:Function = _nodeFunctions[String(node.localName())] as Function;
			if (func != null) {
				return func(node);
			} else {
				throw new Error("No preprocess function found for " + String(node.localName()));
			}
		}

		public function preprocessCompositeCommandElement(node:XML):XML {
			for each (var subnode:XML in node.descendants()) {
				setMissingID(subnode);
			}
			return node;
		}

		public function preprocessAndOrNextElement(node:XML):XML {
			if (node.@command == undefined) {
				var idValue:String = node.descendants()[0].attribute(TaskNamespaceHandler.ID_ATTR);
				if (idValue == "") {
					var id:String = UIDUtil.createUID();
					node.descendants()[0].@id = id;
					node.@command = id;
				} else {
					node.@command = idValue;
				}
			}
			return node;
		}

		public function preprocessPauseElement(node:XML):XML {
			var attrValue:String = node.attribute(TaskNamespaceHandler.DURATION_ATTR);
			var newId:String = UIDUtil.createUID();
			var pauseObj:XML = <{TaskNamespaceHandler.PAUSECOMMAND_ELEMENT} duration={attrValue} id={newId}/>;
			pauseObj.setNamespace(node.namespace());
			node.appendChild(pauseObj);
			return node;
		}

		public function preprocessTaskElement(node:XML):XML {
			return setMissingID(node);
		}

		protected function setMissingID(node:XML):XML {
			if (node.@id == undefined) {
				node.@id = UIDUtil.createUID();
			}
			return node;
		}

		public function preprocessIfElement(node:XML):XML {
			node = attributeToNodeAndRefNode(node, TaskNamespaceHandler.CONDITION_ATTR);
			return resolveID(node);
		}

		public function preprocessForElement(node:XML):XML {
			if (node.attribute(TaskNamespaceHandler.COUNT_PROVIDER_ATTR).length() > 0) {
				node = attributeToNodeAndRefNode(node, TaskNamespaceHandler.COUNT_PROVIDER_ATTR);
			} else if (node.attribute(TaskNamespaceHandler.COUNT_ATTR).length() > 0) {
				var newid:String = UIDUtil.createUID();
				var subnode:XML = <count-provider count={node.@[TaskNamespaceHandler.COUNT_ATTR]} id={newid}/>;
				var refNode:XML = <ref>{newid}</ref>;
				refNode.setNamespace(node.namespace());
				subnode.setNamespace(node.namespace());
				subnode..appendChild(refNode);
				node.appendChild(subnode);
				delete node.@[TaskNamespaceHandler.COUNT_ATTR];
			}
			return resolveID(node);
		}

		public function preprocessWhileElement(node:XML):XML {
			node = attributeToNodeAndRefNode(node, TaskNamespaceHandler.CONDITION_ATTR);
			return resolveID(node);
		}

		public function attributeToNodeAndRefNode(node:XML, attr:String):XML {
			var attrValue:String = node.attribute(attr);
			if ((attrValue != null) && (attrValue.length > 0)) {
				var namesp:Namespace = node.namespace();
				var subnode:XML = <{attr}/>;
				subnode.setNamespace(namesp);
				var refNode:XML = <{TaskNamespaceHandler.REF_ATTR}>{attrValue}</{TaskNamespaceHandler.REF_ATTR}>;
				refNode.setNamespace(namesp);
				subnode.appendChild(refNode);
				node.prependChild(subnode);
				deleteAttribute(node, attr);
			}
			return node;
		}

		public function deleteAttribute(node:XML, attr:String):void {
			delete node.@[attr];
		}

		public function resolveID(node:XML):XML {
			if (node.attribute(TaskNamespaceHandler.ID_ATTR).length() < 1) {
				node.@[TaskNamespaceHandler.ID_ATTR] = UIDUtil.createUID();
			}
			return node;
		}

	}
}