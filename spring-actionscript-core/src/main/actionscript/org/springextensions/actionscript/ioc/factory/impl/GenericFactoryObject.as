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
package org.springextensions.actionscript.ioc.factory.impl {

	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.MethodInvoker;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;
	import org.springextensions.actionscript.util.ContextUtils;

	/**
	 * <code>IFactoryObject</code> implementation that serves as a proxy for a factory object instance that doesn't implement the <code>IFactoryObject</code> interface.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class GenericFactoryObject implements IFactoryObject, IDisposable {
		private static const CONSTRUCTOR_FIELD_NAME:String = "constructor";
		private var _objectType:Class;
		private var _methodInvoker:MethodInvoker;
		private var _isSingleton:Boolean;
		private var _singletonInstance:*;
		private var _isDisposed:Boolean;

		private static var logger:ILogger = getClassLogger(GenericFactoryObject);

		/**
		 * Creates a new <code>GenericFactoryObject</code> instance.
		 */
		public function GenericFactoryObject(wrappedFactory:Object, methodName:String, singleton:Boolean=true) {
			super();
			_methodInvoker = new MethodInvoker();
			_methodInvoker.target = wrappedFactory;
			_methodInvoker.method = methodName;
			_isSingleton = singleton;
		}

		public function getObject():* {
			if (_singletonInstance != null) {
				return _singletonInstance;
			} else {
				return createInstance();
			}
		}

		protected function createInstance():* {
			var result:* = _methodInvoker.invoke();
			if (_objectType == null) {
				if (Object(result).hasOwnProperty(CONSTRUCTOR_FIELD_NAME)) {
					_objectType = Object(result)[CONSTRUCTOR_FIELD_NAME] as Class;
				}
			}
			if (_isSingleton) {
				_singletonInstance = result;
			}
			logger.debug("Executed factory {0}'s factory method {1}, returning result: {2}", [_methodInvoker.target, _methodInvoker.method, result]);
			return result;
		}


		public function getObjectType():Class {
			return _objectType;
		}

		public function get isSingleton():Boolean {
			return _isSingleton;
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		public function dispose():void {
			if (!_isDisposed) {
				ContextUtils.disposeInstance(_methodInvoker.target);
				_methodInvoker.target = null;
				_methodInvoker = null;
				_isDisposed = true;
				logger.debug("Instance {0} has been disposed...", [this])
			}
		}


		public function toString():String {
			return "GenericFactoryObject{objectType:" + _objectType + ", isSingleton:" + _isSingleton + "}";
		}


	}
}
