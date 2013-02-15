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
package org.springextensions.actionscript.ioc.factory.xml.parser.support {
	
	import mx.utils.StringUtil;
	
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.RuntimeObjectReference;
	
	/**
	 * Provides utilities for parsing xml object definitions to object defintions.
	 * @docref extensible_xml_authoring.html#coding_an_iobjectdefinitionparser_implementation
	 * @author Christophe Herreman
	 */
	public final class ParsingUtils {
		
		/**
		 * Maps the given attributes of the xml node to properties of the object definition.
		 */
		public static function mapProperties(objectDefinition:IObjectDefinition, node:XML, ... attributes):void {
			mapAttributes(objectDefinition, node, attributes, function(attributeName:String):Object {
					return node.attribute(attributeName).toString();
				});
		}
		
		/**
		 * Maps the given attributes of the xml node to an array of properties in the properties of the object
		 * definition.
		 */
		public static function mapPropertiesArrays(objectDefinition:IObjectDefinition, node:XML, ... attributes):void {
			mapAttributes(objectDefinition, node, attributes, function(attributeName:String):Object {
					var names:Array = node.attribute(attributeName).toString().split(",");
					var result:Array = [];
					
					for each (var referenceName:String in names) {
						result.push(StringUtil.trim(referenceName));
					}
					return result;
				});
		}
		
		/**
		 * Maps the given attributes of the xml node to object references in the properties of the object definition.
		 */
		public static function mapReferences(objectDefinition:IObjectDefinition, node:XML, ... attributes):void {
			mapAttributes(objectDefinition, node, attributes, function(attributeName:String):Object {
					return new RuntimeObjectReference(node.attribute(attributeName).toString());
				});
		}
		
		/**
		 * Maps the given attributes of the xml node to an array of object references in the properties of the object
		 * definition.
		 */
		public static function mapReferenceArrays(objectDefinition:IObjectDefinition, node:XML, ... attributes):void {
			mapAttributes(objectDefinition, node, attributes, function(attributeName:String):Object {
					var names:Array = node.attribute(attributeName).toString().split(",");
					var result:Array = [];
					
					for each (var referenceName:String in names) {
						result.push(new RuntimeObjectReference(StringUtil.trim(referenceName)));
					}
					return result;
				});
		}
		
		/**
		 * Maps the given attributes of the xml node using the mapper function.
		 *
		 * @see #mapProperties() ParsingUtils.mapProperties()
		 * @see #mapReferences() ParsingUtils.mapReferences()
		 * @see #mapReferenceArrays() ParsingUtils.mapReferenceArrays()
		 */
		private static function mapAttributes(objectDefinition:IObjectDefinition, node:XML, attributes:Array, mapper:Function):void {
			for each (var attribute:Object in attributes) {
				// skip invalid attributes, we need a string or an AttributeToPropertyMapping
				if (!(attribute is String) && !(attribute is AttributeToPropertyMapping)) {
					continue;
				}
				
				var attributeName:String = (attribute is String) ? String(attribute) : AttributeToPropertyMapping(attribute).attribute;
				
				// add the property to the object definition only if it is defined in the xml definition
				if (node.attribute(attributeName) != undefined) {
					var propertyName:String = (attribute is String) ? attributeNameToPropertyName(attributeName) : AttributeToPropertyMapping(attribute).propertyName;
					objectDefinition.properties[propertyName] = mapper(attributeName);
				}
			}
		}
		
		/**
		 * Creates a property name from an attribute name.
		 *
		 * <p>e.g. "make-objects-bindable" becomes "makeObjectsBindable"</p>
		 * <p>Use an <code>AttributeToPropertyMapping</code> if you want to specify the name of the property</p>
		 * @see org.springextensions.actionscript.ioc.factory.xml.parser.support.AttributeToPropertyMapping AttributeToPropertyMapping
		 */
		public static function attributeNameToPropertyName(attribute:String):String {
			var parts:Array = attribute.split("-");
			var result:String = parts.shift();
			
			for each (var part:String in parts) {
				result += part.charAt(0).toUpperCase() + part.substring(1);
			}
			
			return result;
		}
	
	}
}