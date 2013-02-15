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
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	/**
	 * Class that can extratc the catalog.xml en library.swf files from a specified .swc file
	 * @author Roland Zwaga
	 */
	public class SWCExtractor {

		/**
		 * Creates a new <code>SWCExtractor</code> instance.
		 * @param loadedData <code>IDataInput</code> input that represents the byte data of a .swc file
		 * 
		 */
		public function SWCExtractor(loadedData:IDataInput) {
			_swcZip=new ZipFile(loadedData);
		}

		private var _swcZip:ZipFile;

		/**
		 * Extracts the contents of the catalog.xml file and returns this as an <code>XML</code> object. 
		 */
		public function getCatalog():XML {
			var result:XML=null;
			for (var i:int=0; i < _swcZip.entries.length; i++) {
				var entry:ZipEntry=_swcZip.entries[i] as ZipEntry;
				if (entry.name == "catalog.xml") {
					result=new XML(_swcZip.getInput(entry).readUTFBytes(entry.size));
					break;
				}
			}
			return result;
		}

		/**
		 * Extract the library.swf and returns it as a <code>ByteArray</code> that can be loaded by a <code>Loader</code> instance. 
		 */
		public function getSWF():ByteArray {
			var result:ByteArray=null;
			for (var i:int=0; i < _swcZip.entries.length; i++) {
				var entry:ZipEntry=_swcZip.entries[i] as ZipEntry;
				if (entry.name == "library.swf") {
					result=_swcZip.getInput(entry);
					break;
				}
			}
			return result;
		}
	}
}