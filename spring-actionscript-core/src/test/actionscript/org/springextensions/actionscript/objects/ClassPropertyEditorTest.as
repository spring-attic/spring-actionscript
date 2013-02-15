/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.objects {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.ClassNotFoundError;
	import org.springextensions.actionscript.objects.propertyeditors.ClassPropertyEditor;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class ClassPropertyEditorTest extends TestCase {
		
		private var _p:IPropertyEditor;
		
		public function ClassPropertyEditorTest(methodName:String = null) {
			super(methodName);
		}
		
		override public function setUp():void {
			_p = new ClassPropertyEditor();
		}
		
		public function testTextValue_shouldReturnClass():void {
			_p.text = "flexunit.framework.TestCase";
			assertEquals(TestCase, _p.value);
		}
		
		public function testTextValue_shouldFailForNonExistingClass():void {
			try {
				_p.text = "NonExistingClass";
				var clazz:Class = _p.value;
				fail("value getter should throw ClassNotFoundError for non existing class");
			} catch (e:ClassNotFoundError) {
			}
		}
	
	}
}
