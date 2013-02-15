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
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	/**
	 * Class that can manage a list of <code>TemplateFile</code> instances.
	 * @author Roland Zwaga
	 * 
	 */
	public class TemplateFileManager {

		/**
		 * Creates a new <code>TemplateFileManager</code> manager
		 * @param templatePath fully path to the directory that contains all the template files.
		 * @param defaultPlaceHolders A <code>Dictionary</code> instance containing a collection of placeholders that are globally used in every output
		 */
		public function TemplateFileManager(templatePath:String, defaultPlaceHolders:Dictionary=null) {
			_templateFiles=new Dictionary();
			_templatePath=templatePath;
			_defaultPlaceHolders=new Dictionary();
			for (var key:String in defaultPlaceHolders) {
				_defaultPlaceHolders[key.toLowerCase()]=defaultPlaceHolders[key];
			}
		}
		
		/**
		 * A prefix for the template placeholders. e.g. ${
		 */
		public var placeholderPrefix:String = "";
		/**
		 * A suffix for the template placeholders. e.g. }
		 */
		public var placeholderSuffix:String = "";

		private var _defaultPlaceHolders:Dictionary;
		private var _templateFiles:Dictionary;
		private var _templatePath:String;

		/**
		 * Adds a <code>TemplateFile</code> to the list.
		 */
		public function addTemplateFile(templateFile:TemplateFile):void {
			_templateFiles[templateFile.name]=templateFile;
		}

		/**
		 * A <code>Dictionary</code> instance containing a collection of placeholders that are globally used in every output. Assigned to each <code>TemplateFile</code> instance.
		 */
		public function get defaultPlaceHolders():Dictionary {
			return _defaultPlaceHolders;
		}

		/**
		 * @param name The name of the desired <code>TemplateFile</code>
		 * @return The specified <code>TemplateFile</code> instance, or <code>null</code> if the instance with the specified name wasn't found.
		 */
		public function getTemplateFile(name:String):TemplateFile {
			return _templateFiles[name] as TemplateFile;
		}

		/**
		 * Retrieves a list of files from the specified template path and creates a <code>TemplateFile</code> for each of them.
		 */
		public function load():void {
			var templateDirectory:File=new File(File.applicationDirectory.nativePath + File.separator + _templatePath);
			if (templateDirectory.exists) {
				var files:Array=templateDirectory.getDirectoryListing();
				files.forEach(function(item:File, index:int, arr:Array):void {
						var templateFile:TemplateFile=new TemplateFile(item, _defaultPlaceHolders);
						templateFile.placeholderPrefix = placeholderPrefix;
						templateFile.placeholderSuffix = placeholderSuffix;
						_templateFiles[templateFile.name]=templateFile;
					});
			}
			else {
				throw new Error(File.applicationDirectory.nativePath + File.separator + _templatePath + ", this directory does not exist");
			}
		}
	}
}