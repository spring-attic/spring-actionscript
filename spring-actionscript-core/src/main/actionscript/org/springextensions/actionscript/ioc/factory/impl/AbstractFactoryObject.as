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

	import flash.errors.IllegalOperationError;

	import org.springextensions.actionscript.ioc.factory.IFactoryObject;

	/**
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractFactoryObject implements IFactoryObject {

		public function AbstractFactoryObject() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get isSingleton():Boolean {
			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function getObject():* {
			throw new IllegalOperationError("Method is not implemented in abstract base class");
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectType():Class {
			throw new IllegalOperationError("Method is not implemented in abstract base class");
		}
	}
}
