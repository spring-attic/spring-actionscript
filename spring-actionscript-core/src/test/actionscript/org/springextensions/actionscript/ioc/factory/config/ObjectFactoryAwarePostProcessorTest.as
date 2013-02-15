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
package org.springextensions.actionscript.ioc.factory.config {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.IllegalArgumentError;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.support.AbstractObjectFactory;
	
	/**
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class ObjectFactoryAwarePostProcessorTest extends TestCase {
		
		public function ObjectFactoryAwarePostProcessorTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testNew():void {
			try {
				var pp:ObjectFactoryAwarePostProcessor = new ObjectFactoryAwarePostProcessor(null);
				fail("Instantiating ObjectFactoryAwarePostProcessor with null argument should fail");
			} catch (e:IllegalArgumentError) {
			}
		}
		
		public function testPostProcessBeforeInitialization():void {
			var objectFactory:IObjectFactory = new AbstractObjectFactory();
			var pp:ObjectFactoryAwarePostProcessor = new ObjectFactoryAwarePostProcessor(objectFactory);
			var object:ObjectFactoryAwareObject = new ObjectFactoryAwareObject();
			assertNull(object.objectFactory);
			pp.postProcessBeforeInitialization(object, "anObject");
			assertNotNull(object.objectFactory);
			assertEquals(objectFactory, object.objectFactory);
		}
	
	}
}

import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
import org.springextensions.actionscript.ioc.factory.IObjectFactory;

class ObjectFactoryAwareObject implements IObjectFactoryAware {
	
	private var _objectFactory:IObjectFactory;
	
	public function ObjectFactoryAwareObject() {
	}
	
	public function set objectFactory(value:IObjectFactory):void {
		_objectFactory = value;
	}
	
	public function get objectFactory():IObjectFactory {
		return _objectFactory;
	}

}
