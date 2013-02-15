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
	import org.as3commons.lang.Assert;

	/**
	 * Abstract base class that all code generator org.springextensions.actionscript.samples.stagewiring.classes derive from.
	 * @author Roland Zwaga
	 */
	public class AbstractClassGenerator extends AbstractCodeGenerator {

		/**
		 * Creates a new <code>AbstractClassGenerator</code> instance.
		 * @param templateName The name of the template file this generator should use
		 * @param templateFileManager a <code>TemplateFileManager</code> used to retrieve the remplate file contents from
		 * 
		 */
		public function AbstractClassGenerator(templateName:String, templateFileManager:TemplateFileManager) {
			super(templateName, templateFileManager);
		}

		private var _classExportInfo:ClassExportInfo;

		private var _namespaceExportInfo:NamespaceExportInfo;

		/**
		 * A reference to <code>ClassExportInfo</code> instance whose property data can be used by this generator
		 */
		public function get classExportInfo():ClassExportInfo {
			return _classExportInfo;
		}
		/**
		 * @private
		 */		
		public function set classExportInfo(value:ClassExportInfo):void {
			_classExportInfo=value;
		}

		/**
		 * Every subclass of <code>AbstractClassGenerator</code> needs to implement this method, its implementation
		 * needss to take care of the actual code generation.
		 * @return a <code>GeneratorResult</code> instance that describes the file name and contents of the generated output
		 */
		virtual public function execute():GeneratorResult {
			throw new Error("Method not implemented in base class");
		}

		/**
		 * A reference to <code>NamespaceExportInfo</code> instance whose property data can be used by this generator
		 */
		public function get namespaceExportInfo():NamespaceExportInfo {
			return _namespaceExportInfo;
		}
		/**
		 * @private
		 */
		public function set namespaceExportInfo(value:NamespaceExportInfo):void {
			_namespaceExportInfo=value;
		}

		/**
		 * Removes a trailing period charcacter from the specified namespace string 
		 * @param namespacestr the specified namespace
		 * @return the formatted namespace
		 * 
		 */
		protected function formatNamespace(namespacestr:String):String {
			if (namespacestr.charAt(namespacestr.length - 1) == '.') {
				return namespacestr.slice(0, (namespacestr.length - 2));
			} else {
				return namespacestr;
			}
		}
	}
}