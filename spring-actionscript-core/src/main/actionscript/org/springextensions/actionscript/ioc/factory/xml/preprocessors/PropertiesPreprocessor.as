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
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	
	use namespace spring_actionscript_objects;
	
	/**
	 * Replaces all properties placeholders in the xml of the application context
	 * with the values in the Properties objects.
	 *
	 * <p>Recursive property replacement is supported.</p>
	 *
	 * <p>If a property was not found, it will not be replaced with an empty string, but left as is.</p>
	 *
	 * @author Christophe Herreman
	 * @author Kristof Neirynck
	 * @docref container-documentation.html#external_property_files
	 */
	public class PropertiesPreprocessor implements IXMLObjectDefinitionsPreprocessor {
		
		private static const PROPERTY_REGEXP:RegExp = /\$\{[^}]+\}/g;
		
		private var _factory:IObjectFactory;
		
		/**
		 * Creates a new PropertiesPreprocessor object.
		 *
		 * @param properties the collection of Properties objects to apply
		 */
		public function PropertiesPreprocessor(factory:IObjectFactory) {
			Assert.notNull(factory, "The factory argument cannot be null.");
			_factory = factory;
		}
		
		/**
		 * @inheritDoc
		 */
		public function preprocess(xml:XML):XML {
			var nodes:XMLList = xml.children();
			
			// for each node in the context, try to resolve its property placeholders
			for (var i:int = 0; i < nodes.length(); i++) {
				while (hasResolvableProperties(nodes[i])) {
					nodes[i] = resolveProperties(nodes[i]);
				}
			}
			
			return xml;
		}
		
		/**
		 * Checks if there are properties to be resolved. Returns false if no properties placeholders are to be resolved
		 * or no property was found for a placeholder.
		 */
		private function hasResolvableProperties(node:XML):Boolean {
			/*var matches:Array = node.toXMLString().match(PROPERTY_REGEXP);
			
			for (var i:int = 0; i < matches.length; i++) {
				var key:String = getPropertyName(matches[i]);
				var value:String = getValue(_factory.properties, key, _factory.parent as IXMLObjectFactory);
				
				if (value) {
					return true;
				}
			}
			*/
			return false;
		}
		
		/**
		 * Resolves the properties for the given node.
		 */
		private function resolveProperties(node:XML):XML {
			var xmlStr:String = node.toXMLString();
			/*var matches:Array = s.match(PROPERTY_REGEXP);
			
			for (var i:int = 0; i < matches.length; i++) {
				var key:String = getPropertyName(matches[i]);
				var value:String = getValue(_factory.properties, key, _factory.parent);
				s = s.replace(matches[i], value);
			}*/
			
			return new XML(xmlStr);
		}
		
	}
}
