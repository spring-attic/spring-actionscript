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
package org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.nodeparser {

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.IXMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.config.impl.xml.parser.impl.XMLObjectDefinitionsParser;

	/**
	 * Parses an array-collection node.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class ArrayCollectionNodeParser extends AbstractNodeParser {
		private static const MXCOLLECTIONS_ARRAY_COLLECTION_CLASS_NAME:String = "mx.collections.ArrayCollection";
		private static const ARRAY_COLLECTION_CLASS_CANNOT_BE_CREATED_ERROR:String = "ArrayCollection class cannot be created";
		private static var _arrrayCollectionClass:Class;
		private static const logger:ILogger = getClassLogger(ArrayCollectionNodeParser);

		/**
		 * Constructs the ArrayCollectionNodeParser.
		 *
		 * @param xmlObjectDefinitionsParser  The definitions parser using this NodeParser
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#ARRAY_COLLECTION_ELEMENT
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#LIST_ELEMENT
		 */
		public function ArrayCollectionNodeParser(xmlObjectDefinitionsParser:IXMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.ARRAY_COLLECTION_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.LIST_ELEMENT);
		}

		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):* {
			if (_arrrayCollectionClass == null) {
				if (!canCreate()) {
					throw IllegalOperationError(ARRAY_COLLECTION_CLASS_CANNOT_BE_CREATED_ERROR);
				}
			}
			/*
			   Putting the items in an array first, the ArrayCollection performs actions
			   on every addItem() call. This way we can set the source as a onetime operation.
			 */
			var parsedNodes:Array = [];
			logger.debug("Creating new ArrayCollection");
			for each (var n:XML in node.children()) {
				var value:* = xmlObjectDefinitionsParser.parsePropertyValue(n);
				parsedNodes[parsedNodes.length] = value;
				logger.debug("Adding value {0} to new ArrayCollection", [value]);
			}

			return new _arrrayCollectionClass(parsedNodes);
		}

		/**
		 * Returns <code>true</code> if the <code>mx.collections.ArrayCollection</code> class is available.
		 * @param applicationDomain
		 * @return <code>True</code> if the <code>mx.collections.ArrayCollection</code> class is available.
		 */
		public static function canCreate(applicationDomain:ApplicationDomain=null):Boolean {
			applicationDomain ||= Type.currentApplicationDomain;
			try {
				var cls:Class = ClassUtils.forName(MXCOLLECTIONS_ARRAY_COLLECTION_CLASS_NAME, applicationDomain);
				_arrrayCollectionClass = cls;
				logger.debug("{0} can be created, class name was resolved...", [MXCOLLECTIONS_ARRAY_COLLECTION_CLASS_NAME]);
				return true;
			} catch (e:Error) {
				logger.debug("{0} cannot be created, class name was not resolved...", [MXCOLLECTIONS_ARRAY_COLLECTION_CLASS_NAME]);
			}
			return false;
		}
	}
}
