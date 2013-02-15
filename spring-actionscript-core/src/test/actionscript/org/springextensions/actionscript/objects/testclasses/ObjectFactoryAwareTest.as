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
package org.springextensions.actionscript.objects.testclasses {
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;

	public class ObjectFactoryAwareTest implements IObjectFactoryAware {

		public function ObjectFactoryAwareTest() {
		}

		private var _objectFactory:IObjectFactory;

		public function get objectFactory():IObjectFactory {
			return _objectFactory;
		}

		public function set objectFactory(objectFactory:IObjectFactory):void {
			_objectFactory = objectFactory;
		}

	}
}