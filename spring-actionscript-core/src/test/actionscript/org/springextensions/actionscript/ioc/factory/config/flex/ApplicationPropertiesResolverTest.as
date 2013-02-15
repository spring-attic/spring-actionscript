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
package org.springextensions.actionscript.ioc.factory.config.flex {
	import org.springextensions.actionscript.context.support.AbstractApplicationContext;
	import org.springextensions.actionscript.flexunit.FlexUnitTestCase;

	public class ApplicationPropertiesResolverTest extends FlexUnitTestCase {

		public function ApplicationPropertiesResolverTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testConstructor():void {
			var appr:ApplicationPropertiesResolver = new ApplicationPropertiesResolver();
			try	{
				appr.postProcessObjectFactory(new AbstractApplicationContext());
				assertTrue(true);
			} catch(e:Error){
				fail("ApplicationPropertiesResolver should not fail");
			}
		}

		public function testApplicationProperties():void {
			var appr:ApplicationPropertiesResolver = new ApplicationPropertiesResolver();
			appr.postProcessObjectFactory(new AbstractApplicationContext());

		}

	}
}