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
package org.springextensions.actionscript.cairngorm.business {
	
	import mx.rpc.IResponder;
	
	import org.as3commons.lang.ClassUtils;
	
	/**
	 * Business delegate factory.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 * @docref extensions-documentation.html#the_delegate_factory
	 */
	public class BusinessDelegateFactory implements IBusinessDelegateFactory {
		
		/**
		 * Creates a new <code>BusinessDelegateFactory</code> instance.
		 */
		public function BusinessDelegateFactory() {
		}
		
		private var _delegateClass:Class;
		
		private var _responder:IResponder;
		
		private var _service:*;
		
		/**
		 * @inheritDoc
		 */
		public function createBusinessDelegate():IBusinessDelegate {
			var result:IBusinessDelegate = ClassUtils.newInstance(_delegateClass);
			result.service = _service;
			result.responder = _responder;
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set delegateClass(value:Class):void {
			if (ClassUtils.isImplementationOf(value,IBusinessDelegate)){
				_delegateClass = value;
			}
			else {
				throw new TypeError("delegateClass needs to implement IBusinessDelegate");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set responder(value:IResponder):void {
			_responder = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set service(value:*):void {
			_service = value;
		}
	}
}
