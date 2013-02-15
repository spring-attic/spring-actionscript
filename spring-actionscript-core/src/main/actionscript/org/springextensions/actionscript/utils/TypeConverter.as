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
	
	/**
	 * Converts a variable from one type to another.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public final class TypeConverter {
		
		/**
		 * Converts a variable from a String to the best suited type for the
		 * variable.
		 *
		 * @param value the value to convert
		 */
		public static function execute(value:String, applicationDomain:ApplicationDomain=null):* {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:*;

			switch (true) {
				case "true" == value:
					result = true;
					break;
				case "false" == value:
					result = false;
					break;
				case!isNaN(Number(value)):
					result = Number(value);
					break;
				default:
					// check for a class
					try {
						result = ClassUtils.forName(value, applicationDomain);
					} catch (e:Error) {
						// this is not a class, let's look for a static property
						if (value.indexOf(".") != -1) {
							var list:Array = value.split(".");
							var last:String = list.pop() as String;
							
							try {
								result = ClassUtils.forName(list.join("."),applicationDomain);
								
								if (result[last]) {
									result = result[last];
								}
							} catch (e:Error) {
								result = value;
							}
						} else {
							result = value;
						}
					}
					
					
					break;
			}
			return result;
		}
	}
}
