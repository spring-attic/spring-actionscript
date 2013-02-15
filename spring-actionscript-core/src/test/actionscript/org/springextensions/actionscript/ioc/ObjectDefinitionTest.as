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
package org.springextensions.actionscript.ioc {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.ObjectUtils;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class ObjectDefinitionTest extends TestCase {
		
		public function ObjectDefinitionTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testNew():void {
			var o:ObjectDefinition = new ObjectDefinition("flexunit.framework.TestCase");
			assertEquals("flexunit.framework.TestCase", o.className);
			assertNotNull(o.constructorArguments);
			assertEquals(0, o.constructorArguments.length);
			assertNotNull(o.properties);
			assertEquals(0, ObjectUtils.getNumProperties(o.properties));
			assertNotNull(o.scope);
			assertEquals(ObjectDefinitionScope.SINGLETON, o.scope);
		}
		
		public function testIsSingleton():void {
			var o:ObjectDefinition = new ObjectDefinition("flexunit.framework.TestCase");
			o.isSingleton = false;
			assertFalse(o.isSingleton);
			assertEquals(ObjectDefinitionScope.PROTOTYPE, o.scope);
			o.isSingleton = true;
			assertTrue(o.isSingleton);
			assertEquals(ObjectDefinitionScope.SINGLETON, o.scope);
		}
	
	}
}
