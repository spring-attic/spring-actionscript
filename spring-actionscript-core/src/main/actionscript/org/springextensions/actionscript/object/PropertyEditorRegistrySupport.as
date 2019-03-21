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
	import flash.utils.Dictionary;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.springextensions.actionscript.object.propertyeditor.BooleanPropertyEditor;
	import org.springextensions.actionscript.object.propertyeditor.ClassPropertyEditor;
	import org.springextensions.actionscript.object.propertyeditor.NumberPropertyEditor;

	/**
	 * Default implementation of a property editor registry.
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyEditorRegistrySupport implements IPropertyEditorRegistry, IApplicationDomainAware {

		/**
		 * Creates a new <code>PropertyEditorRegistrySupport</code> instance.
		 *
		 */
		public function PropertyEditorRegistrySupport(applicationDomain:ApplicationDomain) {
			super();
			_applicationDomain = applicationDomain;
			_customEditors = new Dictionary()
			registerDefaultEditors();
		}

		private var _applicationDomain:ApplicationDomain;
		private var _customEditors:Dictionary;

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * @inheritDoc
		 */
		public function findCustomEditor(requiredType:Class):IPropertyEditor {
			return _customEditors[requiredType];
		}

		/**
		 * @inheritDoc
		 */
		public function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void {
			Assert.notNull(requiredType, "The required type cannot be null");
			Assert.notNull(propertyEditor, "The property editor cannot be null");
			if (propertyEditor is IApplicationDomainAware) {
				(propertyEditor as IApplicationDomainAware).applicationDomain = _applicationDomain;
			}
			_customEditors[requiredType] = propertyEditor;
		}

		/**
		 *
		 */
		private function registerDefaultEditors():void {
			registerCustomEditor(Boolean, new BooleanPropertyEditor());
			registerCustomEditor(Number, new NumberPropertyEditor());
			registerCustomEditor(Class, new ClassPropertyEditor());
		}
	}
}
