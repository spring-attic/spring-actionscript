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
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.collections.Properties;
	
	/**
	 * Helper class for the <code>PropertiesPreprocessor</code> class.
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @see org.springextensions.actionscript.ioc.factory.xml.preprocessors.PropertiesPreprocessor PropertiesPreprocessor
	 * @docref container-documentation.html#external_property_files
	 */
	public final class PropertiesUtils {
		
		/**
		 * 
		 * @param properties
		 * @param key
		 * @return 
		 * 
		 */
		public static function getProperty(properties:Array, key:String):String {
			Assert.notNull(properties, "The properties cannot be null");
			
			var result:String;
			
			for (var i:int = 0; i < properties.length; i++) {
				if (properties[i] is Properties) {
					var props:Properties = properties[i] as Properties;
					result = props.getProperty(key);
					
					if (null != result) {
						break;
					}
				}
			}
			return result;
		}
	}
}
