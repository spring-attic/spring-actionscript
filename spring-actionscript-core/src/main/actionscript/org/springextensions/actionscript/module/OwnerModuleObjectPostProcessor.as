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

	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;

	/**
	 * <code>IObjectPostProcessor</code> that will check if an object implements the <code>IOwnerModuleAware</code> interface
	 * and will optionally inject it with the ownerModule of the specified <code>IObjectFactory</code>
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.ioc.factory.IObjectFactory IObjectFactory
	 */
	public class OwnerModuleObjectPostProcessor implements IObjectPostProcessor, IObjectFactoryAware {

		/**
		 * Creates a new <code>OwnerModuleObjectPostProcessor</code> instance.
		 */
		public function OwnerModuleObjectPostProcessor() {
			super();
		}
		
		private var _ownerModuleSource:IOwnerModuleAware;
		private var _objectFactory:IObjectFactory;
		
		/**
		 * <p>Will check if the specified <code>IObjectFactory</code> is also an <code>IOwnerModuleAware</code>, and if so
		 * wil store a strongly typed reference to it.</p>
		 * @inheritDoc
		 */
		public function set objectFactory(objectFactory:IObjectFactory):void {
			_ownerModuleSource = (objectFactory as IOwnerModuleAware);
			_objectFactory = objectFactory;
		}

		/**
		 * <p>Will check if the current <code>OwnerModuleObjectPostProcessor</code> stores a valid <code>IOwnerModuleAware</code> instance.
		 * If so it will check if the specified <code>object</code> also implements <code>IOwnerModuleAware</code>, if this is the case
		 * its <code>IOwnerModuleAware.ownerModule</code> property will be injected with the stored <code>IOwnerModuleAware.ownerModule</code> value.</p>
		 * @inheritDoc 
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			if (_ownerModuleSource != null) {
				var ownerModuleTarget:IOwnerModuleAware = (object as IOwnerModuleAware);
				if ((ownerModuleTarget != null) && (ownerModuleTarget.ownerModule == null)){
					ownerModuleTarget.ownerModule = _ownerModuleSource.ownerModule;
				}
			}
			return object;
		}
		/**
		 * Not used in this implementation. 
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}

	}
}