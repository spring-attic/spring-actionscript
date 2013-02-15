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
package org.springextensions.actionscript.objects {

	//import flash.utils.Dictionary;
	//import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.objects.propertyeditors.BooleanPropertyEditor;
	import org.springextensions.actionscript.objects.propertyeditors.ClassPropertyEditor;
	import org.springextensions.actionscript.objects.propertyeditors.NumberPropertyEditor;
	
	/**
	 * Default implementation of a property editor registry.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class PropertyEditorRegistrySupport implements IPropertyEditorRegistry, IApplicationDomainAware {
		
		private var _customEditors:Dictionary = new Dictionary();
		
		/**
		 * Creates a new <code>PropertyEditorRegistrySupport</code> instance.
		 *
		 */
		public function PropertyEditorRegistrySupport(applicationDomain:ApplicationDomain) {
			super();
			_applicationDomain = applicationDomain;
			registerDefaultEditors();
		}
		
		private var _applicationDomain:ApplicationDomain;
		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void {
			Assert.notNull(requiredType, "The required type cannot be null");
			Assert.notNull(propertyEditor, "The property editor cannot be null");
			if (propertyEditor is IApplicationDomainAware){
				(propertyEditor as IApplicationDomainAware).applicationDomain = _applicationDomain;
			}
			_customEditors[requiredType] = propertyEditor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function findCustomEditor(requiredType:Class):IPropertyEditor {
			return _customEditors[requiredType];
		}
		
		private function registerDefaultEditors():void {
			registerCustomEditor(Boolean, new BooleanPropertyEditor());
			registerCustomEditor(Number, new NumberPropertyEditor());
			registerCustomEditor(Class, new ClassPropertyEditor());
		}
	}
}
