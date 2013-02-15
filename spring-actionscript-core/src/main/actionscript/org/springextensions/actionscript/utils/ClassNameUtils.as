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
	import org.as3commons.lang.StringUtils;

	/**
	 * @author Christophe Herreman
	 */
	public final class ClassNameUtils {

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public static function getClassNamesThatMatchBasePackages(classNames:Array, basePackages:Array):Array {
			var result:Array = [];

			for each (var className:String in classNames) {
				if (classNameMatchesBasePackages(className, basePackages)) {
					result.push(className);
				}
			}

			return result;
		}

		public static function classNameMatchesBasePackages(className:String, basePackages:Array):Boolean {
			var result:Boolean = false;

			if (basePackages.length == 0) {
				result = true;
			}

			for each (var basePackage:String in basePackages) {
				if (classNameMatchesPackagePattern(className, basePackage)) {
					result = true;
					break;
				}
			}

			return result;
		}

		/**
		 *  Returns true if the className matches the given package pattern.
		 *
		 * @param className
		 * @param packagePattern
		 * @return
		 */
		public static function classNameMatchesPackagePattern(className:String, packagePattern:String):Boolean {
			Assert.hasText(className, "The classname must have text");

			if (!StringUtils.hasText(packagePattern)) {
				packagePattern = "";
			}

			packagePattern = StringUtils.trim(packagePattern);

			if (StringUtils.hasText(packagePattern) && !StringUtils.startsWith(packagePattern, "*")) {
				packagePattern = "^" + packagePattern;
			}

			return (className.search(new RegExp(packagePattern)) > -1);
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ClassNameUtils() {
		}
	}
}
