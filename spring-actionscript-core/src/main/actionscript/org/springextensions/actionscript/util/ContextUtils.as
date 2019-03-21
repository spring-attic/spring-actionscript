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
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Metadata;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public final class ContextUtils {

		public static const COMMA:String = ',';

		/**
		 *
		 * @param instance
		 */
		public static function disposeInstance(instance:Object):void {
			if (instance is IDisposable) {
				(instance as IDisposable).dispose();
			}
		}

		/**
		 *
		 * @param instance
		 * @param objectDefinitionRegistry
		 * @return
		 */
		public static function getCustomConfigurationForObjectName(instance:String, objectDefinitionRegistry:IObjectDefinitionRegistry):Vector.<Object> {
			var config:* = objectDefinitionRegistry.getCustomConfiguration(instance);
			var customConfiguration:Vector.<Object> = (config is Vector.<Object>) ? (config as Vector.<Object>) : new Vector.<Object>();
			if ((config != null) && !(config is Vector.<Object>)) {
				customConfiguration[customConfiguration.length] = config;
			}
			return customConfiguration;
		}

		/**
		 *
		 * @param propertyValue
		 * @return
		 */
		public static function commaSeparatedPropertyValueToStringVector(propertyValue:String):Vector.<String> {
			if (StringUtils.hasText(propertyValue)) {
				var parts:Array = propertyValue.split(COMMA);
				var result:Vector.<String> = new Vector.<String>();
				for each (var name:String in parts) {
					result[result.length] = StringUtils.trim(name);
				}
				return result;
			}
			return null;
		}

		/**
		 *
		 * @param metadata
		 * @param key
		 * @return
		 */
		public static function getMetadataArgument(metadata:Metadata, key:String):String {
			if (metadata.hasArgumentWithKey(key)) {
				return metadata.getArgument(key).value;
			}
			return null;
		}

		/**
		 *
		 * @param metadata
		 * @param key
		 * @return
		 */
		public static function getCommaSeparatedArgument(metadata:Metadata, key:String):Vector.<String> {
			if (metadata.hasArgumentWithKey(key)) {
				commaSeparatedPropertyValueToStringVector(metadata.getArgument(key).value);
			}
			return null;
		}

		/**
		 *
		 * @param arr
		 * @return
		 */
		public static function arrayToString(arr:Array):String {
			if (arr == null) {
				return "null";
			} else {
				var result:Array = [];
				for each (var item:* in arr) {
					result[result.length] = (item != null) ? item.toString() : "null";
				}
				return result.join(', ');
			}
		}
	}
}
