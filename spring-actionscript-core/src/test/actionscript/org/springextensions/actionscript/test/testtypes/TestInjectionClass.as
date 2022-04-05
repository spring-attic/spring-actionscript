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
package org.springextensions.actionscript.test.testtypes {
	import org.springextensions.actionscript.ioc.config.impl.xml.ns.spring_actionscript_objects;


	use namespace spring_actionscript_objects;

	public class TestInjectionClass {

		[Ignore]
		[Test(description="This test is being ignored")]
		public function testDummy():void {
		}

		private var _count:uint = 0;

		public function TestInjectionClass() {
			super();
		}

		spring_actionscript_objects var testProperty:String = "customTest";

		public var testProperty:String = "publicTest";

		public static var testStaticProperty:String = "staticTest";

		public var testComplex:Object = null;

		public function get count():uint {
			return _count;
		}

		public function testCounter():void {
			_count++;
		}

		spring_actionscript_objects function testCounter():void {
			_count += 2;
		}
	}
}
