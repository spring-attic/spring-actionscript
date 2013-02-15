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
	/**
	 * <code>AbstractClassGenerator</code> subclass that can generate the xsd code for a list of XML elements.
	 * @author Roland Zwaga
	 */
	public class SchemaGenerator extends AbstractClassGenerator {

		/**
		 * @param schemaElementGenerator a <code>SchemaElementGenerator</code> instance used to generate the individual element parts of the schema
		 * @inheritDoc
		 */
		public function SchemaGenerator(templateName:String, templateFileManager:TemplateFileManager, schemaElementGenerator:SchemaElementGenerator) {
			super(templateName, templateFileManager);
			_schemaElementGenerator=schemaElementGenerator;
		}

		private var _schemaElementGenerator:SchemaElementGenerator;

		/**
		 * @inheritDoc 
		 */
		override public function execute():GeneratorResult {
			var placeHolders:Dictionary=new Dictionary();
			placeHolders['schemaurl']=namespaceExportInfo.schemaURL;
			placeHolders['schemaelements']=generateSchemaElements(namespaceExportInfo.classExportInfoList);

			var fileName:String=ExportUtils.namespaceTitleToName(namespaceExportInfo.namespaceTitle) + ".xsd";
			fileName=fileName.split('_').join('-');

			return new GeneratorResult(fileName, generate(placeHolders));
		}

		private function generateSchemaElements(classExportInfoList:Array):String {
			var result:Array=[];
			classExportInfoList.forEach(function(item:ClassExportInfo, index:int, arr:Array):void {
					_schemaElementGenerator.classExportInfo=item;
					result.push(_schemaElementGenerator.execute().fileContents);
				});
			return result.join("\n");
		}
	}
}