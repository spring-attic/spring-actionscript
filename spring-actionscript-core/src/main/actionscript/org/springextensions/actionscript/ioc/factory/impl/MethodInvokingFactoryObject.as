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

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.MethodInvoker;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;
	import org.springextensions.actionscript.ioc.factory.IFactoryObject;

	/**
	 * <p><code>MethodInvokingFactoryObject</code> is an <code>IFactoryObject</code> implementation which retrieves the result of a method invocation
	 * on a specified object or class which may then be used to set a property value or constructor argument for another object.</p>
	 * <p>Configuration example of how to retrieve an <code>IResourceManager</code> instance:</p>
	 * <pre>
	 * &lt;object class="org.springextensions.actionscript.ioc.factory.impl.MethodInvokingFactoryObject"&gt;
	 *   &lt;property name="targetClass" value="mx.resources.ResourceManager" /&gt;
	 *   &lt;property name="targetMethod" value="getInstance" /&gt;
	 * &lt;/object&gt;
	 * </pre>
	 * @author Roland Zwaga
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class MethodInvokingFactoryObject extends MethodInvoker implements IFactoryObject, IApplicationContextAware {

		/**
		 * Creates a new <code>MethodInvokingFactoryObject</code> instance.
		 */
		public function MethodInvokingFactoryObject() {
			super();
		}

		private var _applicationContext:IApplicationContext;

		/**
		 * @private
		 */
		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		/**
		 * @inheritDoc
		 */
		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		private var _target:*;

		/**
		 * @inheritDoc
		 */
		override public function set target(value:*):void {
			_target = value;
		}

		/**
		 * The class that holds the static field value defined by the staticField property.
		 * @return
		 */
		public function get targetClass():Class {
			return target as Class;
		}

		/**
		 * @private
		 */
		public function set targetClass(value:Class):void {
			target = value;
		}

		/**
		 * The target instance that holds the property value defined by the targetField property.
		 */
		public function get targetObject():* {
			return target;
		}

		/**
		 * @private
		 */
		public function set targetObject(value:*):void {
			target = value;
		}

		/**
		 * @private
		 */
		public function get targetMethod():String {
			return method;
		}

		/**
		 * @private
		 */
		public function set targetMethod(value:String):void {
			method = value;
		}

		/**
		 * @inheritDoc
		 */
		public function getObject():* {
			Assert.notNull(_applicationContext, "applicationContext property must have been set");
			if (_target is RuntimeObjectReference) {
				super.target = _applicationContext.getObject(RuntimeObjectReference(_target).objectName);
			} else {
				super.target = (_target is String) ? ClassUtils.forName(String(_target), _applicationContext.applicationDomain) : _target;
			}
			super.arguments = [];
			if (_arguments) {
				var args:Array = [];
				for each (var obj:Object in _arguments) {
					args[args.length] = (obj is RuntimeObjectReference) ? _applicationContext.getObject(RuntimeObjectReference(obj).objectName) : obj;
				}
				super.arguments = args;
			}
			return invoke();
		}

		private var _arguments:Array;

		override public function set arguments(value:Array):void {
			_arguments = value;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectType():Class {
			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function get isSingleton():Boolean {
			return false;
		}

		public function toString():String {
			return "MethodInvokingFactoryObject{target:" + target + ", arguments:[" + arguments + "]}";
		}

	}
}
