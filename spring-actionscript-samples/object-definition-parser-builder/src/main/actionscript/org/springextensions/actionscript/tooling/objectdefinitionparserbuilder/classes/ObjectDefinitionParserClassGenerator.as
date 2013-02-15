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
	import org.as3commons.lang.ClassUtils;
	/**
	 * <code>AbstractClassGenerator</code> subclass that can generate the source code for a <code>ObjectDefinitionParser</code> class
	 * @author Roland Zwaga
	 */
	public class ObjectDefinitionParserClassGenerator extends AbstractClassGenerator {

		/**
		 * @inheritDoc
		 */
		public function ObjectDefinitionParserClassGenerator(templateName:String, templateFileManager:TemplateFileManager) {
			super(templateName, templateFileManager);
		}

		/**
		 * @inheritDoc
		 */
		override public function execute():GeneratorResult {
			var placeHolders:Dictionary=new Dictionary();
			placeHolders['package']=formatNamespace(namespaceExportInfo.targetClassNamespace);
			placeHolders['wrappedclass']=classExportInfo.className;
			placeHolders['fullwrappedclass']=ClassUtils.getFullyQualifiedName(classExportInfo.type.clazz, true);
			placeHolders['mapped_properties']=generateMappedProperties(classExportInfo.fieldExportInfoList);
			placeHolders['mapped_references']=generateMappedReferences(classExportInfo.fieldExportInfoList);
			placeHolders['attribute_declarations']=generateAttributeDeclarations(classExportInfo.fieldExportInfoList);

			return new GeneratorResult(placeHolders['wrappedclass'] + templateFile.defaultPlaceHolders['templateFileManager'] + '.as', generate(placeHolders));
		}

		private function generateAttributeDeclarations(fieldExportInfoList:Array):String {
			var result:Array=[];
			fieldExportInfoList.forEach(function(item:FieldExportInfo, index:int, arr:Array):void {
					if (item.useInExport) {
						result.push(StringUtil.substitute("\t\t/** The {1} attribute */\n\t\tpublic static const {0}:String = \"{1}\"", item.constantName, item.xmlName));
					}
				});
			return result.join('\n');
		}

		private function generateMappedProperties(fieldExportInfoList:Array):String {
			var result:String="ParsingUtils.mapProperties(result.objectDefinition, node";
			var found:Boolean=false;
			fieldExportInfoList.forEach(function(item:FieldExportInfo, index:int, arr:Array):void {
					if ((item.useInExport) && (item.hasSimpleType)) {
						result+=", " + item.constantName;
						found=true;
					}
				});
			return (found) ? result + ");" : "";
		}

		private function generateMappedReferences(fieldExportInfoList:Array):String {
			var result:String="ParsingUtils.mapReferences(result.objectDefinition, node";
			var found:Boolean=false;
			fieldExportInfoList.forEach(function(item:FieldExportInfo, index:int, arr:Array):void {
					if ((item.useInExport) && (!item.hasSimpleType)) {
						result+=", " + item.constantName;
						found=true;
					}
				});
			return (found) ? result + ");" : "";
		}
	}
}