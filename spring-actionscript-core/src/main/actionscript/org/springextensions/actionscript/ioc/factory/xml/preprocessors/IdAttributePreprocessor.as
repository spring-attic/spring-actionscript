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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.util.Constants;
	
	use namespace spring_actionscript_objects;
	
	/**
	 * Adds an "id" attribute to objects that have none defined.
	 *
	 * @author Christophe Herreman
	 */
	public class IdAttributePreprocessor implements IXMLObjectDefinitionsPreprocessor {
		
		private static const GENERATED_ID_PREFIX:String = "__";
		
		private static var _counter:int = 0;
		
		public function IdAttributePreprocessor() {
		}
		
		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			Assert.notNull(xml, "The xml argument must not be null");
			var objectNodesWithoutId:XMLList = xml..object.(attribute(Constants.ID_ATTRIBUTE) == undefined);
			
			for each (var node:XML in objectNodesWithoutId) {
				if (node.parent().name() != XMLObjectDefinitionsParser.TEMPLATE_ELEMENT) {
					node.@[Constants.ID_ATTRIBUTE] = GENERATED_ID_PREFIX + _counter;
					_counter++;
				}
			}
			return xml;
		}
	}
}
