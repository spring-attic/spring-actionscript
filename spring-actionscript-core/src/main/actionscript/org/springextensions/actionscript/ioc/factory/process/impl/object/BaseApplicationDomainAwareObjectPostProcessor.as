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
package org.springextensions.actionscript.ioc.factory.process.impl.object {
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class BaseApplicationDomainAwareObjectPostProcessor implements IObjectPostProcessor, IApplicationDomainAware {

		private static const NOT_IMPLEMENTED_IN_BASE_CLASS_ERROR:String = "Not implemented in base class";

		/**
		 * Creates a new <code>BaseApplicationDomainAwareObjectPostProcessor</code> instance.
		 */
		public function BaseApplicationDomainAwareObjectPostProcessor() {
			super();
		}

		private var _applicationDomain:ApplicationDomain;

		/**
		 *
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 * @private
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
			throw new IllegalOperationError(NOT_IMPLEMENTED_IN_BASE_CLASS_ERROR);
		}

		/**
		 * @inheritDoc
		 */
		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			throw new IllegalOperationError(NOT_IMPLEMENTED_IN_BASE_CLASS_ERROR);
		}
	}
}
