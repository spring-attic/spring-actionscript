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
package org.springextensions.actionscript.rpc.soap {
	
	import mx.rpc.soap.WebService;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.AbstractOperation;
	import org.springextensions.actionscript.rpc.AbstractRPC;

	public class AbstractWebServiceOperation extends AbstractRPC {
		
		protected var webService:WebService;
		
		public function AbstractWebServiceOperation(webService:WebService, methodName:String, parameters:Array = null) {
			Assert.notNull(webService,"webService argument must not be null");
			super(methodName, parameters);
			this.webService = webService;
		}
	}
}