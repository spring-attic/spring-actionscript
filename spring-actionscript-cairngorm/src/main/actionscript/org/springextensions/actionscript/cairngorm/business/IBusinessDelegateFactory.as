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

	/**
	 * Defines a business delegate factory.
	 *
	 * @author Christophe Herreman
	 * @author Bert Vandamme
	 * @docref extensions-documentation.html#the_delegate_factory
	 */
	public interface IBusinessDelegateFactory {

		/**
		 * The type of the delegate that the current <code>IBusinessDelegateFactory</code> is able to create.
		 */
		function set delegateClass(value:Class):void;

		/**
		 * The service object that will be injected into every delegate that the current <code>IBusinessDelegateFactory</code> creates. 
		 */
		function set service(value:*):void;

		/**
		 * The <code>IResponder</code> instance that will be injected into every delegate that the current <code>IBusinessDelegateFactory</code> creates. 
		 */
		function set responder(value:IResponder):void;

		/**
		 * Returns a fully configured delegate instance of the type specified by the <code>delegateClass</code> property.
		 */
		function createBusinessDelegate():IBusinessDelegate;

	}
}
