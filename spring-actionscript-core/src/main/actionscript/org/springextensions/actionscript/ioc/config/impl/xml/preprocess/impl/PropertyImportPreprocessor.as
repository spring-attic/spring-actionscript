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
package org.springextensions.actionscript.ioc.config.impl.xml.preprocess.impl {
	import org.as3commons.lang.Assert;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.config.impl.xml.preprocess.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.config.property.TextFileURI;

	use namespace spring_actionscript_objects;

	/**
	 * XML Preprocessor for the "import" element that imports external properties files. These nodes are
	 * preprocessed to PropertyPlaceholderConfigurer objects.
	 *
	 * @author Christophe Herreman
	 */
	public class PropertyImportPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const FILE_ATTRIBUTE_NAME:String = 'file';
		private static const REQUIRED_ATTRIBUTE_NAME:String = 'required';
		private static const PREVENTCACHE_ATTRIBUTE_NAME:String = "prevent-cache";

		private static const logger:ILogger = getClassLogger(PropertyImportPreprocessor);

		private var _propertyURIs:Vector.<TextFileURI>;

		/**
		 *
		 * @param propURIs
		 */
		public function PropertyImportPreprocessor(propURIs:Vector.<TextFileURI>) {
			Assert.notNull(propURIs, "propURIs argument must not be null");
			_propertyURIs = propURIs;
		}

		/**
		 *
		 * @param xml
		 * @return
		 *
		 */
		public function preprocess(xml:XML):XML {
			addTextFileURIsForPropertyNodesWithFileAttribute(xml);
			return xml;
		}

		private function addTextFileURIsForPropertyNodesWithFileAttribute(xml:XML):void {
			var propertyNodes:XMLList = xml.property;

			for (var i:uint = 0; i < propertyNodes.length();) {
				var node:XML = propertyNodes[i];
				if (hasFileAttribute(node)) {
					addTextFileURI(node);
					delete propertyNodes[i];
				} else {
					i++;
				}
			}
		}

		private static function hasFileAttribute(node:XML):Boolean {
			return (node.attribute(FILE_ATTRIBUTE_NAME).length() > 0);
		}

		private function addTextFileURI(node:XML):void {
			var fileName:String = String(node.attribute(FILE_ATTRIBUTE_NAME)[0]);
			var isRequired:Boolean = getBooleanAttribute(node, REQUIRED_ATTRIBUTE_NAME, true);
			var preventCache:Boolean = getBooleanAttribute(node, PREVENTCACHE_ATTRIBUTE_NAME, true);
			var uri:TextFileURI = new TextFileURI(fileName, isRequired, preventCache);
			_propertyURIs.push(uri);
			logger.debug("Added property location from XML: {0}", [uri]);
		}

		private static function getBooleanAttribute(node:XML, attributeName:String, defaultValue:Boolean):Boolean {
			return (node.attribute(attributeName).length() > 0) ? (node.attribute(attributeName)[0] == true) : true;
		}
	}
}
