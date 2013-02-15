/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.core {
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.collections.Map;

	/**
	 * Support class for AttributeAccessors, providing a base implementation of
	 * all methods. To be extended by subclasses.
	 *
	 * @author Andrew Lewisohn
	 * @since 1.1
	 * @see org.springextensions.actionscript.core.IAttributeAccessor
	 */
	public class AttributeAccessorSupport implements IAttributeAccessor {

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 * Map with String keys and Object values.
		 */
		private const attributes:Map = new Map();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function AttributeAccessorSupport() {
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function attributeNames():Array {
			var keys:Array = [];

			for (var key:String in attributes) {
				keys.push(key);
			}

			return keys.sort();
		}

		/**
		 * @inheritDoc
		 */
		public function getAttribute(name:String):Object {
			Assert.notNull(name, "Name cannot be null.");
			return attributes.get(name);
		}

		/**
		 * @inheritDoc
		 */
		public function hasAttribute(name:String):Boolean {
			Assert.notNull(name, "Name cannot be null.");
			return attributes.contains(name);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAttribute(name:String):Object {
			Assert.notNull(name, "Name cannot be null.");
			return attributes.remove(name);
		}

		/**
		 * @inheritDoc
		 */
		public function setAttribute(name:String, value:Object):void {
			Assert.notNull(name, "Name cannot be null.");

			if (value != null) {
				attributes.put(name, value);
			} else {
				removeAttribute(name);
			}
		}
	}
}