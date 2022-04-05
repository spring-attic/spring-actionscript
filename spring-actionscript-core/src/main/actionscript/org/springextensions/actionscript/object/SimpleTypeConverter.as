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
package org.springextensions.actionscript.object {
	import flash.system.ApplicationDomain;
	import org.springextensions.actionscript.util.TypeUtils;

	/**
	 * Simple implementation of the <code>ITypeConverter</code> interface.
	 * @author Roland Zwaga
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class SimpleTypeConverter extends PropertyEditorRegistrySupport implements ITypeConverter {

		/**
		 * Creates a new <code>SimpleTypeConverter</code> instance.
		 */
		public function SimpleTypeConverter(applicationDomain:ApplicationDomain) {
			super(applicationDomain);
		}

		/**
		 * @inheritDoc
		 */
		public function convertIfNecessary(value:*, requiredType:Class=null):* {
			if (!requiredType) {
				requiredType = TypeUtils.resolveType(value.toString());
			}

			if (value is requiredType) {
				return value;
			}

			if (!(value is String)) {
				value = value.toString();
			}

			var result:* = value;
			var editor:IPropertyEditor = findCustomEditor(requiredType);

			if (editor) {
				editor.text = value;
				result = editor.value;
			}

			return result;
		}
	}
}
