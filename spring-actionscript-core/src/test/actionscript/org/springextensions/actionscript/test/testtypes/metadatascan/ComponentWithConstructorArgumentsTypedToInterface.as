/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.test.testtypes.metadatascan {

	/**
	 *  @author Christophe Herreman
	 */
	[Component]
	public class ComponentWithConstructorArgumentsTypedToInterface {

		[Ignore]
		[Test(description="This test is being ignored")]
		public function testDummy():void {
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ComponentWithConstructorArgumentsTypedToInterface(arg1:IAnnotatedComponent, arg2:AnnotatedNamedComponent) {
			_arg1 = arg1;
			_arg2 = arg2;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// arg1
		// ----------------------------

		private var _arg1:IAnnotatedComponent;

		public function get arg1():IAnnotatedComponent {
			return _arg1;
		}

		// ----------------------------
		// arg2
		// ----------------------------

		private var _arg2:AnnotatedNamedComponent;

		public function get arg2():AnnotatedNamedComponent {
			return _arg2;
		}

	}
}
