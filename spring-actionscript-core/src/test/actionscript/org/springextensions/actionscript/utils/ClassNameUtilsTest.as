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

	import flexunit.framework.TestCase;

	public class ClassNameUtilsTest extends TestCase {

		public function ClassNameUtilsTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests - classNameMatchesPackagePattern
		//
		// --------------------------------------------------------------------

		public function testClassNameMatchesPackagePattern():void {
			var className:String = "com.company.MyClass";

			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, ""));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com"));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com."));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.*"));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.company"));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.company."));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.company.*"));
		}

		public function testClassNameMatchesPackagePattern_withDoubleColonInClassName():void {
			var className:String = "com.company::MyClass";

			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, ""));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com"));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com."));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.*"));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.company"));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.company."));
			assertTrue(ClassNameUtils.classNameMatchesPackagePattern(className, "com.company.*"));
		}

		// --------------------------------------------------------------------
		//
		// Tests - classNameMatchesBasePackages
		//
		// --------------------------------------------------------------------

		public function testClassNameMatchesBasePackages():void {
			var className:String = "com.company.MyClass";

			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, [""]));
			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, ["com"]));
			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, ["com", "org"]));
			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, ["com.company", "org.company", "net.company"]));

			assertFalse(ClassNameUtils.classNameMatchesBasePackages(className, ["net"]));
			assertFalse(ClassNameUtils.classNameMatchesBasePackages(className, ["net", "org"]));
		}

		public function testClassNameMatchesBasePackages_withDoubleColonInClassName():void {
			var className:String = "com.company::MyClass";

			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, [""]));
			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, ["com"]));
			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, ["com", "org"]));
			assertTrue(ClassNameUtils.classNameMatchesBasePackages(className, ["com.company", "org.company", "net.company"]));

			assertFalse(ClassNameUtils.classNameMatchesBasePackages(className, ["net"]));
			assertFalse(ClassNameUtils.classNameMatchesBasePackages(className, ["net", "org"]));
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		public function testGetClassNamesThatMatchBasePackages():void {
			var classNames:Array = ["com.company.MyClass", "com.company.view.MyView", "net.company.MyClass"];
			var basePackages:Array = ["com.*"];

			var matches:Array = ClassNameUtils.getClassNamesThatMatchBasePackages(classNames, basePackages);

			assertEquals(2, matches.length);
			assertTrue(matches.indexOf("com.company.MyClass") > -1);
			assertTrue(matches.indexOf("com.company.view.MyView") > -1);
		}
	}
}
