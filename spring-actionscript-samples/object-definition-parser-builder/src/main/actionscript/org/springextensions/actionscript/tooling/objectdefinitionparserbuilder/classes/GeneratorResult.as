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
	/**
	 * Placeholder class for the output of a generator class
	 * @author Roland Zwaga
	 * 
	 */
	public final class GeneratorResult {

		/**
		 * Creates a new <code>GeneratorResult</code> instance
		 * @param fileName The filename for the generated code
		 * @param fileContents The file contents (the generated code)
		 * 
		 */
		public function GeneratorResult(fileName:String, fileContents:String) {
			_fileName=fileName;
			_fileContents=fileContents;
		}
		private var _fileContents:String;

		private var _fileName:String;

		/**
		 * The file contents (the generated code)
		 */
		public function get fileContents():String {
			return _fileContents;
		}

		/**
		 * The filename for the generated code
		 */
		public function get fileName():String {
			return _fileName;
		}
	}
}