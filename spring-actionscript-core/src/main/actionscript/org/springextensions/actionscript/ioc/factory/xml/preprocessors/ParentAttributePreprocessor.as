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
	
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	
	use namespace spring_actionscript_objects;
	
	/**
	 * Preprocesses parent-child objects so that all parent attributes and elements are copied to the child
	 * if they are not defined by the child object.
	 *
	 * @author Christophe Herreman
	 */
	public class ParentAttributePreprocessor implements IXMLObjectDefinitionsPreprocessor {
		
		/**
		 * Creates a new ParentAttributePreprocessor.
		 */
		public function ParentAttributePreprocessor() {
		}
		
		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			var nodes:XMLList = xml..object.(attribute("parent") != undefined);
			
			for each (var childNode:XML in nodes) {
				var parentName:String = childNode.@parent.toString();
				var parentNode:XML = xml.object.(attribute("id") == parentName)[0];
				
				// merge attributes
				// only merge attributes that are not already in the child node
				for each (var parentAttribute:XML in parentNode.attributes()) {
					var attributeName:String = parentAttribute.localName().toString();
					
					// skip abstract attribute
					if ("abstract" == attributeName) {
						continue;
					}
					
					// add child attributes
					var childHasAttribute:Boolean = (childNode.@[attributeName] != undefined);
					
					if (!childHasAttribute) {
						childNode.@[attributeName] = parentNode.@[attributeName];
					}
				}
				
				// merge subnodes
				// only merge subnodes that are not already in the child node
				// if the child has constructor-arg nodes, we don't insert those of the parent since there is
				// no way to match constructor arguments because they only contain a value and no identifier
				var constructorArgNodes:XMLList = childNode.children().(name().localName == "constructor-arg");
				var childHasConstructorArgs:Boolean = (constructorArgNodes.length() > 0);
				
				for each (var parentSubNode:XML in parentNode.children()) {
					var parentSubNodeName:String = parentSubNode.localName().toString();
					
					// skip constructor-arg nodes if any are found in the child
					var isConstructorArgNode:Boolean = (parentSubNodeName == "constructor-arg");
					
					if (childHasConstructorArgs && isConstructorArgNode) {
						continue;
					}
					
					// skip property node if child already contains it
					var isPropertyNode:Boolean = (parentSubNodeName == "property");
					
					if (isPropertyNode) {
						var propertyName:String = parentSubNode.@["name"];
						var propertyNodes:XMLList = childNode.property.(@name == propertyName);
						var childHasProperty:Boolean = (propertyNodes.length() > 0);
						
						if (childHasProperty) {
							continue;
						}
					}
					
					childNode.appendChild(parentSubNode);
				}
			}
			
			return xml;
		}
	}
}
