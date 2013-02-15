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
package org.springextensions.actionscript.utils {
	
	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.Type;
	
	/**
	 * TypeUtils contains utility methods for working with objects.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.9
	 * </p>
	 */
	public final class TypeUtils {
		
		/**
		 * @return <code>true</code> in case the Class is a "simple" property
		 * (String, Number, int, uint, Boolean, Date, Class), <code>false</code>
		 * otherwise.
		 */
		public static function isSimpleProperty(type:Type):Boolean {
			
			if (type == null || type == Type.UNTYPED || type == Type.VOID)
				return false;
			
			var clazz:Class = type.clazz;
			
			if (ClassUtils.isSubclassOf(clazz, String, type.applicationDomain) || clazz === String || ClassUtils.isSubclassOf(clazz, int, type.applicationDomain)
                    || clazz === int || ClassUtils.isSubclassOf(clazz, uint, type.applicationDomain) || clazz === uint
                    || ClassUtils.isSubclassOf(clazz, Number, type.applicationDomain) || clazz === Number
                    || ClassUtils.isSubclassOf(clazz, Boolean, type.applicationDomain) || clazz === Boolean
                    || ClassUtils.isSubclassOf(clazz, Date, type.applicationDomain) || clazz === Date
                    || ClassUtils.isSubclassOf(clazz, Class, type.applicationDomain) || clazz === Class) {
				return true;
			}
			
			return false;
		
		}

}
}
