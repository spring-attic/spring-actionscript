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
package org.springextensions.actionscript.module {
	import mx.modules.Module;
	
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;

	/**
	 * Basic implementation of the <code>ISASModule</code> interface. This class is offered as a convenience
	 * base class.
	 * @author Roland Zwaga
	 */
	public class BasicSASModule extends Module implements ISASModule {

		/**
		 * Creates a new <code>BasicSASModule</code> instance and invokes the <code>initBasicSASModule()</code> method.
		 */
		public function BasicSASModule() {
			super();
			initBasicSASModule();
		}
		
		/**
		 * Creates an <code>FlexXMLApplicationContext</code> and sets itself as the value of the <code>FlexXMLApplicationContext.ownerModule</code> property.
		 */
		protected function initBasicSASModule():void {
			_moduleApplicationContext = new FlexXMLApplicationContext(null,this);
		}

		private var _applicationContext:IApplicationContext;
		public function get applicationContext():IApplicationContext {
			return _applicationContext
		}
		/**
		 * <p>The <code>IApplicationContext</code> instance that will act as the parent context for the <code>moduleApplicationContext</code> instance.</p>
		 * @inheritDoc
		 */
		public function set applicationContext(value:IApplicationContext):void {
			if (value !== _applicationContext) {
				_applicationContext = value;
				if (_moduleApplicationContext != null) {
					_moduleApplicationContext.parent = _applicationContext;
				}
			}
		}
		
		private var _moduleApplicationContext:FlexXMLApplicationContext;
		/**
		 * @inheritDoc 
		 */
		public function get moduleApplicationContext():FlexXMLApplicationContext {
			return _moduleApplicationContext;
		}
		/**
		 * @private
		 */
		public function set moduleApplicationContext(value:FlexXMLApplicationContext):void {
			if (value !== _moduleApplicationContext){
				_moduleApplicationContext = value;
				if (_moduleApplicationContext != null) {
					_moduleApplicationContext.parent = _applicationContext;
				}
			}
		}

	}
}