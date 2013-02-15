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
	import org.as3commons.reflect.Type;
	/**
	 * 
	 * @author Roland Zwaga
	 */
	public class ClassExportInfo extends AbstractExportInfo {

		/**
		 * Creates a new <code>ClassExportInfo</code> instance.
		 * @param type reflection info for the class to be exported
		 * @param fieldExportInfoList an array of <code>FieldExportInfo</code> instances
		 * 
		 */
		public function ClassExportInfo(type:Type, fieldExportInfoList:Array) {
			_type=type;
			_fieldExportInfoList=fieldExportInfoList;
			xmlName=ExportUtils.actionscriptNameToAttribute(_type.name);
			constantName=ExportUtils.attributeNameToConstant(xmlName, _elementConstantSuffix);
		}
		
		private var _elementConstantSuffix:String="";

		private var _fieldExportInfoList:Array;

		private var _type:Type;


		/**
		 * The name of the class that this export info refers to.
		 */
		public function get className():String {
			return _type.name;
		}

		/**
		 * A suffix for the constant field declaration in the NamespaceHandler class. e.g. MYELEMENT_NAME_ELM where the '_ELM' part is the suffix
		 * determined by this property.
		 */
		public function get elementConstantSuffix():String {
			return _elementConstantSuffix;
		}
		/**
		 * @private
		 */
		public function set elementConstantSuffix(value:String):void {
			if (value != _elementConstantSuffix) {
				_elementConstantSuffix=value;
				constantName=ExportUtils.attributeNameToConstant(xmlName, _elementConstantSuffix);
			}
		}

		[Bindable(event="fieldExportInfoListChanged")]
		/**
		 * An array of <code>FieldExportInfo</code> instances describing the export data for the class' properties
		 */
		public function get fieldExportInfoList():Array {
			return _fieldExportInfoList;
		}

		/**
		 * Reflection info for the class 
		 */
		public function get type():Type {
			return _type;
		}
	}
}