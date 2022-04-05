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
package org.springextensions.actionscript.object.propertyeditor {

	import flash.errors.IllegalOperationError;

	import org.springextensions.actionscript.object.IPropertyEditor;

	/**
	 * Abstract base class for <code>IPropertyEditor</code> implementations.
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractPropertyEditor implements IPropertyEditor {

		private var _value:*;

		/**
		 * Creates a new <code>AbstractPropertyEditor</code> instance
		 * @throws flash.errors.IllegalOperationError When called directly
		 */
		public function AbstractPropertyEditor(self:AbstractPropertyEditor) {
			super();
			initAbstractPropertyEditor(self);
		}

		protected function initAbstractPropertyEditor(self:AbstractPropertyEditor):void {
			if (self !== this) {
				throw new IllegalOperationError("AbstractPropertyEditor is abstract");
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get text():String {
			return value.toString();
		}

		/**
		 * @private
		 */
		public function set text(value:String):void {
			throw new IllegalOperationError("set text must be implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function get value():* {
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(v:*):void {
			_value = v;
		}
	}
}
