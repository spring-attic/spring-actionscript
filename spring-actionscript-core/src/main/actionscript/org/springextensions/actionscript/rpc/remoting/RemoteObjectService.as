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
package org.springextensions.actionscript.rpc.remoting {

	import mx.rpc.remoting.RemoteObject;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.rpc.AbstractRPCService;
	import org.springextensions.actionscript.rpc.IService;

	/**
	 * Service that invokes methods on a remote object and returns an <code>IOperation</code> for each of these calls.
	 * @see org.springextensions.actionscript.core.operation.IOperation IOperation 
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#services
	 */
	public class RemoteObjectService extends AbstractRPCService {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new RemoteObjectService.
		 *
		 * @param remoteObject the remote object
		 */
		public function RemoteObjectService(remoteObject:RemoteObject = null) {
			super();
			this.remoteObject = remoteObject;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// remoteObject
		// ----------------------------

		private var _remoteObject:RemoteObject;

		/**
		 * The <code>RemoteObject</code> that is used by the current <code>AbstractRemoteObjectService</code>
		 * to perform its task.
		 */
		public function get remoteObject():RemoteObject {
			return _remoteObject;
		}

		/**
		 * @private
		 */
		public function set remoteObject(value:RemoteObject):void {
			_remoteObject = value;
		}

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function call(methodName:String, ... parameters):IOperation {
			Assert.state(remoteObject != null, "The remoteObject property must not be null");
			return new RemoteObjectOperation(remoteObject, methodName, parameters);
		}

	}
}