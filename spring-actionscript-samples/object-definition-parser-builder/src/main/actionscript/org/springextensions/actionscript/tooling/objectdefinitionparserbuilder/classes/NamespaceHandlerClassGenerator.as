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
	/**
	 * <code>AbstractClassGenerator</code> subclass that can generate the source code for a <code>NamespaceHandler</code> class
	 * @author Roland Zwaga
	 */
	public class NamespaceHandlerClassGenerator extends AbstractClassGenerator {

		/**
		 * @inheritDoc
		 */
		public function NamespaceHandlerClassGenerator(templateName:String, templateFileManager:TemplateFileManager) {
			super(templateName, templateFileManager);
		}

		/**
		 * @inheritDoc
		 */
		override public function execute():GeneratorResult {
			var placeHolders:Dictionary=new Dictionary();
			placeHolders['package']=formatNamespace(namespaceExportInfo.targetClassNamespace);
			placeHolders['schemaurl']=namespaceExportInfo.schemaURL;
			placeHolders['namespacetitle']=namespaceExportInfo.namespaceTitle;
			placeHolders['namespacename']=ExportUtils.namespaceTitleToName(namespaceExportInfo.namespaceTitle);
			placeHolders['element_declarations']=generateElementDeclarations(namespaceExportInfo.classExportInfoList);
			placeHolders['parserregistrations']=generateParserRegistrations(namespaceExportInfo.classExportInfoList);
			return new GeneratorResult(placeHolders['namespacetitle'] + templateFile.defaultPlaceHolders['namespacehandlerclassnamesuffix'] + '.as', generate(placeHolders));
		}

		private function generateElementDeclarations(classExportInfoList:Array):String {
			var result:Array=[];
			classExportInfoList.forEach(function(item:ClassExportInfo, index:int, arr:Array):void {
					result.push(StringUtil.substitute("\t\tpublic static const {0}:String = \"{1}\"", item.constantName, item.xmlName));
				});
			return result.join("\n");
		}

		private function generateParserRegistrations(classExportInfoList:Array):String {
			var result:Array=[];
			classExportInfoList.forEach(function(item:ClassExportInfo, index:int, arr:Array):void {
					result.push(StringUtil.substitute("\t\t\tregisterObjectDefinitionParser({0}, new {1}{2}());", item.constantName, item.className, templateFile.defaultPlaceHolders['namespacehandlerclassnamesuffix']));
				});
			return result.join("\n");
		}
	}
}