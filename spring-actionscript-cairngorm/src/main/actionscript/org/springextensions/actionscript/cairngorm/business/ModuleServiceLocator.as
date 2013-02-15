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
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.soap.WebService;

	/**
	 * dynamic subclass of the <code>ServiceLocator</code> that does not have the <code>getInstance()</code>
	 * singleton method, use the scope="singleton" attribute in your Spring Actionscript configuration
	 * instead to make sure only one instance fo the <code>ModuleServiceLocator</code> will be instantiated.
	 * @author Roland Zwaga
	 */
	public dynamic class ModuleServiceLocator extends ServiceLocator {

		/**
		 * Creates a new <code>ModuleServiceLocator</code> instance.
		 * 
		 */
		public function ModuleServiceLocator() {
		}
		
		/**
		 * Returns the <code>HTTPService</code> with the specified name or null if it wasn't found.
		 */
		override public  function getHTTPService(name:String):HTTPService {
			return this[name];
		}
		
		/**
		 * Returns the <code>RemoteObject</code> with the specified name or null if it wasn't found.
		 */
		override public  function getRemoteObject(name:String):RemoteObject {
			return this[name];
		}
		
		/**
		 * Returns the <code>WebService</code> with the specified name or null if it wasn't found.
		 */
		override public  function getWebService(name:String):WebService {
			return this[name];
		}

	}
}