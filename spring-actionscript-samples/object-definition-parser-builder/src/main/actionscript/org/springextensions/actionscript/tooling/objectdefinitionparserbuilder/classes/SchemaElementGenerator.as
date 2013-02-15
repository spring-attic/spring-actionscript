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
	import flash.utils.Dictionary;
	import mx.utils.StringUtil;
	import org.as3commons.reflect.Type;
	/**
	 * <code>AbstractClassGenerator</code> subclass that can generate the xsd code for an XML element.
	 * @author Roland Zwaga
	 */
	public class SchemaElementGenerator extends AbstractClassGenerator {

		/**
		 * @inheritDoc
		 */
		public function SchemaElementGenerator(templateName:String, templateFileManager:TemplateFileManager) {
			super(templateName, templateFileManager);
		}

		/**
		 * @inheritDoc 
		 */
		override public function execute():GeneratorResult {
			var placeHolders:Dictionary=new Dictionary();
			placeHolders['elementname']=classExportInfo.xmlName;
			placeHolders['attributenames']=generateAttributeElement(classExportInfo.fieldExportInfoList);
			return new GeneratorResult('', generate(placeHolders));
		}

		private function generateAttributeElement(fieldExportInfoList:Array):String {
			var result:Array=[];

			fieldExportInfoList.forEach(function(item:FieldExportInfo, index:int, arr:Array):void {
					if (item.useInExport) {
						result.push(StringUtil.substitute("\t\t\t\t<xsd:attribute name=\"{0}\" type=\"{1}\"{2}/>", item.xmlName, getXSDType(item.field.type), getRequired(item.isRequired)));
					}
				});

			return result.join("\n");
		}

		private function getRequired(isRequired:Boolean):String {
			return (isRequired) ? " use=\"required\"" : "";
		}

		private function getXSDType(type:Type):String {
			if (type.name != null) {
				switch (type.name.toLowerCase()) {
					case "int":
					case "uint":
					case "number":
						return "xs:integer";
					case "boolean":
						return "xs:boolean";
					default:
						return "xs:string";
				}
			} else {
				return "xs:string";
			}
		}
	}
}