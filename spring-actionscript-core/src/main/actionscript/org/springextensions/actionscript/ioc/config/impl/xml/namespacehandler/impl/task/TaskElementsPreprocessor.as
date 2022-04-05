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
	import flash.utils.Dictionary;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;

	/**
	 * Normalizes <code>Task</code> specific markup so it will be ready to be converted by the <code>TaskNamespaceHandler</code>.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 * @see org.springextensions.actionscript.core.task.xml.TaskNamespaceHandler TaskNamespaceHandler
	 */
	public class TaskElementsPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const logger:ILogger = getClassLogger(TaskElementsPreprocessor);
		public static const GENERIC_ID_PREFIX:String = "TASK_ELEMENT_GENERIC_ID_";

		private var _nodeFunctions:Dictionary;
		private var _genericIdCounter:int = 0;

		/**
		 * Creates a new <code>TaskElementsPreprocessor</code> instance.
		 */
		public function TaskElementsPreprocessor() {
			super();
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
					logger.debug("Pre-processing element <{0}>", [name]);
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
				if (idValue.length == 0) {
					var id:String = createGenericId();
					node.descendants()[0].@id = id;
					node.@command = id;
				} else {
					node.@command = idValue;
				}
				logger.debug("Element <{0}> received command attribute with value '{0}'", [node.@command]);
			}
			return node;
		}

		public function preprocessPauseElement(node:XML):XML {
			var attrValue:String = node.attribute(TaskNamespaceHandler.DURATION_ATTR);
			var newId:String = createGenericId();
			var pauseObj:XML = <{TaskNamespaceHandler.PAUSECOMMAND_ELEMENT} duration={attrValue} id={newId}/>;
			pauseObj.setNamespace(node.namespace());
			node.appendChild(pauseObj);
			logger.debug("Created pause command element:\n{0}", [pauseObj]);
			delete node.@[TaskNamespaceHandler.DURATION_ATTR];
			return node;
		}

		public function preprocessTaskElement(node:XML):XML {
			return setMissingID(node);
		}

		protected function setMissingID(node:XML):XML {
			if (node.@id == undefined) {
				node.@id = createGenericId();
				logger.debug("Element <{0}> received generic id '{1}'", [node.localName(), node.@id]);
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
				var newid:String = createGenericId();
				var subnode:XML = <count-provider count={node.@[TaskNamespaceHandler.COUNT_ATTR]} id={newid}/>;
				var refNode:XML = <ref>{newid}</ref>;
				refNode.setNamespace(node.namespace());
				subnode.setNamespace(node.namespace());
				subnode.appendChild(refNode);
				node.appendChild(subnode);
				logger.debug("Created count provider element:\n{0}", [subnode]);
				deleteAttribute(node, TaskNamespaceHandler.COUNT_ATTR);
			}
			return resolveID(node);
		}

		public function createGenericId():String {
			return GENERIC_ID_PREFIX + _genericIdCounter++;
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
				var refNode:XML = <{TaskNamespaceHandler.REF_ATTR}>{attrValue}</{TaskNamespaceHandler.REF_ATTR}>;
				subnode.appendChild(refNode);
				subnode.setNamespace(namesp);
				refNode.setNamespace(namesp);
				node.prependChild(subnode);
				logger.debug("Created {0} element:\n{1}", [attr, subnode]);
				deleteAttribute(node, attr);
			}
			return node;
		}

		public function deleteAttribute(node:XML, attr:String):void {
			delete node.@[attr];
		}

		public function resolveID(node:XML):XML {
			if (node.attribute(TaskNamespaceHandler.ID_ATTR).length() < 1) {
				node.@[TaskNamespaceHandler.ID_ATTR] = createGenericId();
			}
			return node;
		}

	}
}
