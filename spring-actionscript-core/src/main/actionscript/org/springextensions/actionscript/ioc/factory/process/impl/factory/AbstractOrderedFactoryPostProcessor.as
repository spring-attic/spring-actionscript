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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.IOrdered;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;


	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractOrderedFactoryPostProcessor implements IObjectFactoryPostProcessor, IOrdered {
		private var _order:int;

		public function AbstractOrderedFactoryPostProcessor(orderPosition:int) {
			super();
			_order = orderPosition;
		}

		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			throw new Error("Not implemented in abstract base class");
		}

		public function get order():int {
			return _order;
		}

		public function set order(value:int):void {
			_order = value;
		}
	}
}
