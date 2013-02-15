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
package org.springextensions.actionscript.utils {
	
	import flexunit.framework.TestCase;
	import org.as3commons.reflect.Type;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class TypetUtilsTest extends TestCase {
		
		public function TypetUtilsTest(methodName:String = null) {
			super(methodName);
		}
		
		
		
		public function testForSimpleClass():void {
			
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(String)));
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(int)));
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(uint)));
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(Number)));
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(Boolean)));
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(Date)));
			assertTrue(TypeUtils.isSimpleProperty(Type.forClass(Class)));
		
		}
		
		public function testForNonSimpleClass():void {
			assertFalse(TypeUtils.isSimpleProperty(Type.forClass(TestCase)));
		}
	
	/*public function testGetClassInfo_shouldReturnStringInfo():void {
	   assertEquals("String", ObjectUtils.getClassInfo("a").name);
	   }
	
	   public function testGetClassInfo_shouldReturnNumberInfoForFloat():void {
	   assertEquals("Number", ObjectUtils.getClassInfo(13.5).name);
	   }
	
	   public function testGetClassInfo_shouldReturnNumberInfoForNegativeFloat():void {
	   assertEquals("Number", ObjectUtils.getClassInfo(-13.5).name);
	   }
	
	   public function testGetClassInfo_shouldReturnNumberInfoWithInt():void {
	   assertEquals("int", ObjectUtils.getClassInfo(-13).name);
	   }
	
	   public function testGetClassInfo_shouldReturnNumberInfoWithUint():void {
	   var number:uint = 13;
	   assertEquals("uint", ObjectUtils.getClassInfo(number).name);
	   }
	
	   public function testGetClassInfo_shouldReturnBooleanInfo():void {
	   assertEquals("Boolean", ObjectUtils.getClassInfo(true).name);
	   assertEquals("Boolean", ObjectUtils.getClassInfo(false).name);
	   }
	
	   public function testGetClassInfo_shouldReturnDateInfo():void {
	   assertEquals("Date", ObjectUtils.getClassInfo(new Date()).name);
	   }
	
	   public function testGetClassInfo_shouldReturnArrayInfo():void {
	   assertEquals("Array", ObjectUtils.getClassInfo(new Array()).name);
	 }*/
	
	}
}
