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
	 * AbstractBusinessDelegate acts as a base class for business delegates.
	 *
	 * It defines a "service" and a "responder" property.
	 *
	 * @author Christophe Herreman
	 */
	public class AbstractBusinessDelegate implements IBusinessDelegate {

		/**
		 * Creates a new AbstractBusinessDelegate object.
		 *
		 * @param service the service
		 * @param responder the responder that will handle the remote call
		 */
		public function AbstractBusinessDelegate(service:* = null, responder:IResponder = null) {
			this.service = service;
			this.responder = responder;
		}

		private var _responder:IResponder;

		private var _service:*;

		/**
		 * Returns the current <code>IResponder</code> iinstance for this delegate.
		 */
		public function get responder():IResponder {
			return _responder;
		}

		/**
		 * @private
		 */
		public function set responder(value:IResponder):void {
			_responder = value;
		}

		/**
		 * Returns the current service for this delegate.
		 * @return The service
		 */
		public function get service():* {
			return _service;
		}

		/**
		 * @private
		 */
		public function set service(value:*):void {
			_service = value;
		}
	}
}
