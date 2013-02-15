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
package org.springextensions.actionscript.ioc.factory.config {

	import org.springextensions.actionscript.objects.IPropertyEditor;

	/**
	 * <code>IObjectFactoryPostProcessor</code> implementation that allows for convenient
	 * registration of custom property editors.
	 *
	 * @author Christophe Herreman
	 */
	public class CustomEditorConfigurer implements IObjectFactoryPostProcessor {

		private var _customEditors:Object;

		/**
		 * Creates a new CustomEditorConfigurer.
		 */
		public function CustomEditorConfigurer() {
		}

		/**
		 * Sets the customer editors for this configurer.
		 */
		public function set customEditors(value:Object):void {
			_customEditors = value;
		}

		/**
		 * @inheritDoc
		 */
		public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			if (_customEditors) {
				for (var key:String in _customEditors) {
					var editor:IPropertyEditor = _customEditors[key];
					var editorClass:Class = objectFactory.getClassForName(key);
					objectFactory.registerCustomEditor(editorClass, editor);
				}
			}
		}
	}
}
