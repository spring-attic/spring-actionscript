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
	 * <code>AbstractClassGenerator</code> subclass that can generate the source code for a <code>Namespace</code> class
	 * @author Roland Zwaga
	 */
	public class NamespaceClassGenerator extends AbstractClassGenerator {

		/**
		 * @inheritDoc
		 */		
		public function NamespaceClassGenerator(templateName:String, templateFileManager:TemplateFileManager) {
			super(templateName, templateFileManager);
		}

		/**
		 * @inheritDoc 
		 */
		override public function execute():GeneratorResult {
			var placeHolders:Dictionary=new Dictionary();
			placeHolders['package']=formatNamespace(namespaceExportInfo.targetClassNamespace);
			placeHolders['schemaurl']=namespaceExportInfo.schemaURL;
			placeHolders['namespacename']=ExportUtils.namespaceTitleToName(namespaceExportInfo.namespaceTitle);
			return new GeneratorResult(placeHolders['namespacename'] + '.as', generate(placeHolders));
		}

	}
}