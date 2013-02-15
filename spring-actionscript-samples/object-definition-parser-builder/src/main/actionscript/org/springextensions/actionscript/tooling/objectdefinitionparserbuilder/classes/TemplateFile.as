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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import org.springextensions.actionscript.utils.MultilineString;
	/**
	 * An object that can replace a list of place holders in a given string.
	 * @author Roland Zwaga
	 */
	public class TemplateFile {

		/**
		 * Creates a new <code>TemplateFile</code> instance.
		 * @param file The <code>File</code> instance that refers to the template file containing the placeholders that need to be processed
		 * @param defaultPlaceHolders A <code>Dictionary</code> instance containing a collection of placeholders that are globally used in every output
		 * 
		 */
		public function TemplateFile(file:File, defaultPlaceHolders:Dictionary=null) {
			_name=file.name;
			_defaultPlaceHolders=(defaultPlaceHolders != null) ? defaultPlaceHolders : new Dictionary();
			readContents(file);
		}

		/**
		 * The contents of the template file.
		 */
		protected var contents:String;

		private var _defaultPlaceHolders:Dictionary;

		private var _name:String;
		
		public var placeholderPrefix:String = "";
		public var placeholderSuffix:String = "";

		/**
		 * A <code>Dictionary</code> instance containing a collection of placeholders that are globally used in every output
		 */
		public function get defaultPlaceHolders():Dictionary {
			return _defaultPlaceHolders;
		}

		/**
		 * Copies the template contents, replaces all the place holders and returns the generated result
		 * @param placeHolders instance specific <code>Dictionary</code> of placeholders
		 * @return the generated result
		 */
		public function generate(placeHolders:Dictionary):String {
			var contentCopy:String=contents;
			var holder:String="";
			for (var key:String in _defaultPlaceHolders) {
				holder=placeholderPrefix + key + placeholderSuffix;
				contentCopy=contentCopy.split(holder).join(_defaultPlaceHolders[key]);
			}
			for (key in placeHolders) {
				holder=placeholderPrefix + key + placeholderSuffix;
				contentCopy=contentCopy.split(holder).join(placeHolders[key]);
			}
			return contentCopy;
		}

		/**
		 * The filename of the loaded templatefile. e.g. namespace.template 
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * Reads the contents of the template file and assigns it to the contents property. 
		 */
		public function readContents(file:File):void {
			var textFile:FileStream=new FileStream();
			var result:String="";
			try {
				textFile.open(file, FileMode.READ);
				contents=textFile.readUTFBytes(file.size);
				contents=new MultilineString(contents).lines.join("\n");
			} finally {
				textFile.close();
			}
		}
	}
}