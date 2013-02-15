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
	
	import org.as3commons.lang.IllegalStateError;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class ObjectDefinitionScopeTest extends TestCase {
		
		public function ObjectDefinitionScopeTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testNew():void {
			try {
				var scope:ObjectDefinitionScope = new ObjectDefinitionScope("newscope");
				fail("Creating new ObjectDefintionScope instances should fail.");
			} catch (e:IllegalStateError) {
			}
		}
		
		public function testValues():void {
			var singletonScope:ObjectDefinitionScope = ObjectDefinitionScope.SINGLETON;
			var prototypeScope:ObjectDefinitionScope = ObjectDefinitionScope.PROTOTYPE;
			assertEquals(ObjectDefinitionScope.SINGLETON_NAME, singletonScope.name);
			assertEquals(ObjectDefinitionScope.PROTOTYPE_NAME, prototypeScope.name);
		}
		
		public function testFromName():void {
			assertEquals(ObjectDefinitionScope.SINGLETON, ObjectDefinitionScope.fromName("singleton"));
			assertEquals(ObjectDefinitionScope.PROTOTYPE, ObjectDefinitionScope.fromName("prototype"));
		}
		
		public function testFromName_shouldReturnSingletonForInvalidName():void {
			assertEquals(ObjectDefinitionScope.SINGLETON, ObjectDefinitionScope.fromName("does_not_exist"));
		}
	
	}
}
