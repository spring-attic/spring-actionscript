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
	 
	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.springextensions.actionscript.ioc.factory.xml.spring_actionscript_objects;
	import org.springextensions.actionscript.ioc.util.Constants;

	use namespace spring_actionscript_objects;
	
	/**
	 * A <code>IXMLObjectDefinitionsPreprocessor</code> instance that retrieves all &lt;interface/&gt;
	 * elements, looks up the &lt;object/&gt; definitions that have classes that implement these interfaces and
	 * copies the configuration nodes from the interfaces to the appropriate &lt;object/&gt; elements.
	 * @author Roland Zwaga
	 * @docref container-documentation.html#handling_object_inheritance_using_interfaces
	 */
	public class InterfacePreprocessor implements IXMLObjectDefinitionsPreprocessor, IApplicationDomainAware {

		public static const CLASS_ATTR:String = "class";
		
		/**
		 * Creates a new <code>InterfacePreprocessor</code> instance.
		 *
		 */
		public function InterfacePreprocessor(applicationDomain:ApplicationDomain) {
			super();
			_applicationDomain = applicationDomain;
		}
		
		private var _applicationDomain:ApplicationDomain;
		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * Retrieves all the &lt;interface/&gt; nodes, looks up the appropriate &lt;object/&gt; nodes
		 * and copies the interface configuration into them.
		 * @param xml The specified XML that contains both the &lt;interface/&gt; and &lt;object/&gt; nodes
		 * @return The processed XML
		 */
		public function preprocess(xml:XML):XML {
			default xml namespace = spring_actionscript_objects;
			var nodes:XMLList = xml.descendants(Constants.INTERFACE);
			var node:XML;
			
			// loop through each interface node and apply them to the appropriate object nodes
			for each(node in nodes) {
				var className:String = node["@class"];
				var objects:Array = lookupImplementingObjects(xml, className);
				for each(var objectNode:XML in objects) {
					//copy the interface's child nodes into the object node
					for each (var child:XML in node.children()) {
						var childName:String = child.localName().toString();
						var nameAttributeValue:String = child["@name"];
						var objectHasElement:Boolean = hasChildElementWithName(objectNode,childName,nameAttributeValue);
							
						if (!objectHasElement) {
							objectNode.appendChild(child);
						}

					}
					//copy the interface's attributes to the object node
					for each (var attr:XML in node.attributes()){
						var attributeName:String = attr.localName().toString();
						
						// add child attributes
						var objectHasAttribute:Boolean = (objectNode["@"+attributeName] != undefined);
						
						if (!objectHasAttribute) {
							objectNode["@"+attributeName] = node["@"+attributeName].copy();
						}
					}
				}
			}
			
			//interface nodes are no longer needed so they can be disposed off
			for each (var del:XML in nodes){
				default xml namespace = spring_actionscript_objects;
				delete xml.descendants(Constants.INTERFACE)[xml.descendants(Constants.INTERFACE).length()-1];
			}

			return xml;
		}
		
		protected function hasChildElementWithName(node:XML, childElementName:String, namePropertyValue:String):Boolean {
			//This method may seem completely retarded, but so far this has been the only way I can get reliable results
			//when working with merged XML files that contain the same namespace declarations. Any help or information on
			//how to get this working properly are MOST welcome...
			var children:XMLList = node.children();
			for each(var child:XML in children) {
				if ((child.localName().toString() == childElementName) && (child["@name"] == namePropertyValue)){
					return true; 
				}
			}
			return false;
		}
		
		/**
		 * Returns all the &lt;object/&gt; nodes that define a class that implements the specified interface. 
		 * @param xml The XML that contains the &lt;object/&gt; nodes
		 * @param interfaceName The name of the interface that objects need to implement 
		 * @return A list of &lt;object/&gt; nodes with a class that implements the specified interface
		 */
		protected function lookupImplementingObjects(xml:XML, interfaceName:String):Array {
			var result:Array = [];
			var objects:XMLList = xml..object;
			for each(var node:XML in objects) {
				var elms:XMLList = node.elements();
				var className:String = node["@class"];
				var interfaces:Array = ClassUtils.getFullyQualifiedImplementedInterfaceNames(ClassUtils.forName(className,_applicationDomain),true,_applicationDomain);
				if (interfaces.indexOf(interfaceName) > -1) {
					result.push(node);
				}
			}
			return result;
		}

	}
}