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
	 * Allows programmatic manipulation of the services inside Cairngorm's
	 * ServiceLocator. This enabled the IoC Container to configure the
	 * ServiceLocator at runtime.
	 *
	 * <p>Here's an example of a service locator xml definition:<br/>
	 * <listing version="3.0"> &lt;object id="serviceLocator" class="org.springextensions.actionscript.ioc.util.CairngormServiceLocator" factory-method="getInstance"&gt;
	 *   &lt;property name="productService"&gt;
	 *     &lt;ref&gt;productService&lt;/ref&gt;
	 *   &lt;/property&gt;
	 * &lt;/object&gt;</listing></p>
	 *
	 * <p>The <code>productService</code> is defined as:<br/>
	 * <listing version="3.0"> &lt;object id="productService" class="com.renaun.rpc.RemoteObjectAMF0">
	 *   &lt;property name="id" value="productService"/>
	 *   &lt;property name="endpoint" value="http://localhost/amfphp/gateway.php"/>
	 *   &lt;property name="source" value="com.adobe.cairngorm.samples.store.business.ProductDelegate"/>
	 *   &lt;property name="showBusyCursor" value="true"/>
	 *   &lt;property name="makeObjectsBindable" value="true"/>
	 * &lt;/object>
	 * </listing></p>
	 *
	 * @author Christophe Herreman
	 * @docref extensions-documentation.html#the_servicelocator
	 */
	public dynamic  class CairngormServiceLocator extends ServiceLocator {
		
		private static var _instance:CairngormServiceLocator;
		
		/**
		 * Returns the singleton instance of the <code>CairngormServiceLocator</code>.
		 */
		public static function getInstance():CairngormServiceLocator {
			if (_instance == null)
				_instance = new CairngormServiceLocator();
			return _instance;
		}
		
		/**
		 * Creates a new <code>CairngormServiceLocator</code> object.
		 * Note: this constructor should never be called. To obtain an instance
		 * of this class, call the static <code>getInstance</code> method.
		 */
		public function CairngormServiceLocator() {
			if (_instance != null) {
				throw Error("Only one instance of the CairngormServiceLocator can be created, use the static getInstance() method to obtain a reference");
			}
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
