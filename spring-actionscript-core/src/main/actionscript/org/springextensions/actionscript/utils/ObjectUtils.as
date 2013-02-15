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
package org.springextensions.actionscript.utils {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringBuffer;
	import org.as3commons.reflect.Type;

	/**
	 * ObjectsUtils contains utility methods for working with objects.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public final class ObjectUtils {

		private static const ARRAY_ELEMENT_SEPARATOR:String = ", ";
		private static const ARRAY_END:String = "]";
		private static const ARRAY_START:String = "[";
		private static const EMPTY_ARRAY:String = ARRAY_START + ARRAY_END;
		private static const NULL_STRING:String = "null";
		private static const MODULE_FACTORY_PROPERTY_NAME:String = "moduleFactory";

		/**
		 * Returns the <code>Class</code> for the specified instance, if the instance is a <code>UIComponent</code> its <code>ApplicationDomain</code>
		 * is retrieved and used for the <code>Class</code> retrieval.
		 * @param instance The object to be inspected
		 * @return The <code>Class</code> for the object.
		 */
		public static function getClass(instance:Object, applicationDomain:ApplicationDomain = null):Class {
			if (applicationDomain == null) {
				try {
					applicationDomain = ((instance != null) && (instance.hasOwnProperty(MODULE_FACTORY_PROPERTY_NAME)) && (instance[MODULE_FACTORY_PROPERTY_NAME] != null)) ? instance[MODULE_FACTORY_PROPERTY_NAME].info().currentDomain as ApplicationDomain : null;
				} catch (e:*) {
					applicationDomain = null;
				}
			}
			return ClassUtils.forInstance(instance, applicationDomain) as Class;
		}

		/**
		 * Return a String representation of the contents of the specified array.
		 *
		 * <p>
		 * The String representation consists of a list of the array's elements,
		 * enclosed in curly braces (<code>"[]"</code>). Adjacent elements are separated
		 * by the characters <code>","</code> (a comma). Returns <code>"null"</code>
		 * if array is null.
		 *
		 * @param array the array to build a String representation for
		 * @return a String representation of <code>array</code>
		 */
		public static function nullSafeToString(array:Array):String {
			if (array == null) {
				return NULL_STRING;
			}

			if (array.length == 0) {
				return EMPTY_ARRAY;
			}

			var buffer:StringBuffer = new StringBuffer();
			buffer.append(ARRAY_START);
			buffer.append(array.toString());
			buffer.append(ARRAY_END);
			return buffer.toString();
		}

	}

}
