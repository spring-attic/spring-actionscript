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
package org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes {
	
	import org.as3commons.reflect.Type;
	/**
	 * Collection of static convenience methods for the exporting processes
	 * @author Roland Zwaga
	 */
	public final class ExportUtils {

		private static const _primitives:Array=['string', 'int', 'uint', 'boolean', 'number', 'class'];

		/**
		 * Converts an actionscript name into an XML attribute name. e.g. propertyName becomes property-name
		 * @param propertyName the specified actionscript property name
		 * @return the converted result 
		 * 
		 */
		public static function actionscriptNameToAttribute(propertyName:String):String {
			var chars:Array=propertyName.split("");
			var attributeName:Array=[];
			chars.forEach(function(item:String, index:int, arr:Array):void {
					if ((index > 0) && (item != item.toLowerCase())) {
						attributeName.push('-');
					}
					attributeName.push(item.toLowerCase());
				});
			return attributeName.join('');
		}

		/**
		 * Takes an XML attribute name and converts it to an actionscript constant name. e.g. property-name becomes PROPERTY_NAME.
		 * @param attributeName the specified attribute name
		 * @param suffix an optional suffix for the result
		 * @return the converted result
		 * 
		 */
		public static function attributeNameToConstant(attributeName:String, suffix:String):String {
			attributeName=attributeName.toUpperCase();
			attributeName=attributeName.split('-').join('_');
			return attributeName + suffix;
		}

		/**
		 * Converts a camel cased namespace title into a lowercase name. eg. MyNewNamespace becomes my_new_namespace
		 * @param namespaceTitle the specified namespace title
		 * @return the converted result
		 */
		public static function namespaceTitleToName(namespaceTitle:String):String {
			var chars:Array=namespaceTitle.split("");
			var namespaceName:Array=[];
			chars.forEach(function(item:String, index:int, arr:Array):void {
					if ((index == 0) || (item == item.toLowerCase())) {
						namespaceName.push(item);
					} else {
						namespaceName.push('_');
						namespaceName.push(item.toLowerCase());
					}
				});
			return namespaceName.join('').toLowerCase();
		}

		/**
		 * Returns true if the specfied type's name is any of the following: 'string', 'int', 'uint', 'boolean', 'number', 'class'.
		 * @param type The specified type
		 */
		public static function typeIsSimple(type:Type):Boolean {
			return ((type.name != null)) ? (_primitives.indexOf(type.name.toLowerCase()) > -1) : false;
		}
	}
}