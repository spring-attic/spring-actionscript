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
package org.springextensions.actionscript.util {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Type;

	/**
	 * TypeUtils contains utility methods for working with objects.
	 *
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public final class TypeUtils {

		private static const NUMBER_CLASS_NAME:String = "Number";
		private static const STRING_CLASS_NAME:String = "String";
		private static const UINT_CLASS_NAME:String = "uint";
		private static const INT_CLASS_NAME:String = "int";
		private static const BOOLEAN_CLASS_NAME:String = "Boolean";
		private static const ARRAY_CLASS_NAME:String = "Array";
		private static const DATE_CLASS_NAME:String = "Date";
		private static const TRUE_VALUE:String = "true";
		private static const FALSE_VALUE:String = "false";

		/**
		 * @return <code>true</code> in case the Class is a "simple" property
		 * (String, Number, int, uint, Boolean, Date, Class), <code>false</code>
		 * otherwise.
		 */
		public static function isSimpleProperty(type:Type):Boolean {
			if (type == null || type === Type.UNTYPED || type === Type.VOID) {
				return false;
			}
			switch (type.fullName) {
				case NUMBER_CLASS_NAME:
				case UINT_CLASS_NAME:
				case INT_CLASS_NAME:
				case STRING_CLASS_NAME:
				case BOOLEAN_CLASS_NAME:
				case ARRAY_CLASS_NAME:
				case DATE_CLASS_NAME:
					return true;
					break;
				default:
					return false;
					break;
			}
		}

		/**
		 *
		 * @param value
		 * @return
		 */
		public static function resolveType(value:String):Class {
			var result:Class;

			switch (true) {
				case TRUE_VALUE == value.toLowerCase():
					result = Boolean;
					break;
				case FALSE_VALUE == value.toLowerCase():
					result = Boolean;
					break;
				case !isNaN(Number(value)):
					result = Number;
					break;
				default:
					result = String;
			}

			return result;
		}

	}
}
