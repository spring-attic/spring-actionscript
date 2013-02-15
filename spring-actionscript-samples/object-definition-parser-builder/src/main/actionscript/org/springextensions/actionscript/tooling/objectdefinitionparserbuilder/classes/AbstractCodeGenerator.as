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

	import org.as3commons.lang.Assert;

	/**
	 * Base class for  
	 * @author Roland Zwaga
	 */
	public class AbstractCodeGenerator {
		private var _templateFile:TemplateFile;

		public function get templateFile():TemplateFile {
			return _templateFile;
		}

		public function AbstractCodeGenerator(templateName:String, templateFileManager:TemplateFileManager) {
			Assert.notNull(templateFileManager, "templateFileManager parameter must not be null");
			_templateFile=templateFileManager.getTemplateFile(templateName);
		}

		public function generate(placeHolders:Dictionary):String {
			return _templateFile.generate(placeHolders);
		}
	}
}