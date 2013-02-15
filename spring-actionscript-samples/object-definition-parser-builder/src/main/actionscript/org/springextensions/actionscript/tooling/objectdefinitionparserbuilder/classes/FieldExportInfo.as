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
package org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes {
	import org.as3commons.reflect.Field;
	
	/**
	 * 
	 * @author Roland Zwaga
	 */
	public class FieldExportInfo extends AbstractExportInfo {

		/**
		 * Creates a new <code>FieldExportInfo</code> instance.
		 * @param field an <code>Field</code> instance that this info refers to
		 */
		public function FieldExportInfo(field:Field) {
			_field=field;
			_hasSimpleType=ExportUtils.typeIsSimple(field.type);
			xmlName=ExportUtils.actionscriptNameToAttribute(_field.name);
			constantName=ExportUtils.attributeNameToConstant(xmlName, attributeConstantSuffix);
		}

		[Bindable]
		/**
		 * True if the property must be set in the configuration markup
		 */
		public var isRequired:Boolean=false;

		[Bindable]
		/**
		 * True if this field is used in the code generation
		 */
		public var useInExport:Boolean=true;

		private var _attributeConstantSuffix:String="";

		private var _field:Field;

		private var _hasSimpleType:Boolean;

		/**
		 * A suffix for the constant field declaration in the ObjectDefinitionParser class. e.g. MYATTRIBUTE_NAME_ATTR where the '_ATTR' part is the suffix
		 * determined by this property.
		 */
		public function get attributeConstantSuffix():String {
			return _attributeConstantSuffix;
		}

		/**
		 * @private
		 */
		public function set attributeConstantSuffix(value:String):void {
			if (value != _attributeConstantSuffix) {
				_attributeConstantSuffix=value;
				constantName=ExportUtils.attributeNameToConstant(xmlName, _attributeConstantSuffix);
			}
		}

		/**
		 * The <code>Field</code> instance that this info refers to
		 */
		public function get field():Field {
			return _field;
		}

		/**
		 * True if the type name of this property is any of the following: 'string', 'int', 'uint', 'boolean', 'number', 'class'. 
		 */
		public function get hasSimpleType():Boolean {
			return _hasSimpleType;
		}
	}
}