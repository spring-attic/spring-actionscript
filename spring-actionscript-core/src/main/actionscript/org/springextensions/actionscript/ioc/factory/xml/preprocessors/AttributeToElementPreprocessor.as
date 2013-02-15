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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {
	
	import org.as3commons.lang.XMLUtils;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	
	use namespace spring_actionscript_objects;
	
	/**
	 * Converts an attribute to an element.
	 * @example
	 * <p>Input: &lt;object class="com.myclasses.MyClass"/&gt;</p>
	 * <p>Result:<br/>
	 * <pre>
	 * &lt;object&gt;<br/>
	 *   &lt;class&gt;com.myclasses.MyClass&lt;/class&gt;<br/>
	 * &lt;/object&gt;
	 * </pre>
	 * </p>
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class AttributeToElementPreprocessor implements IXMLObjectDefinitionsPreprocessor {
		
		public function AttributeToElementPreprocessor() {
		}
		
		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			var objectNodes:XMLList = xml.descendants();
			
			for each (var node:XML in objectNodes) {
				node = preprocessNode(node);
			}
			return xml;
		}
		
		private function preprocessNode(node:XML):XML {
			var attributes:Array = [XMLObjectDefinitionsParser.VALUE_ATTRIBUTE, XMLObjectDefinitionsParser.REF_ATTRIBUTE];
			
			for each (var attribute:XML in node.attributes()) {
				var name:String = attribute.localName() as String;
				
				if (attributes.indexOf(name) != -1) {
					node = XMLUtils.convertAttributeToNode(node, name);
					
					// if we converted a "value" attribute, we move the "type" attribute
					// to the new element
					if (name == XMLObjectDefinitionsParser.VALUE_ATTRIBUTE) {
						if (node.@type != undefined) {
							node.value.@type = node.@type.toString();
							delete node.@type;
						}
					}
				}
				
			}
			return node;
		}
	}
}
