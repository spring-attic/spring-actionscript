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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.as3commons.reflect.Type;
	/**
	 * Main placeholder class that contains all the export information for a complete batch of files
	 * that together represent a custom namespacehandling unit
	 * @author Roland Zwaga
	 * 
	 */
	public class NamespaceExportInfo extends EventDispatcher {

		/**
		 * Creates a new <code>NamespaceExportInfo</code> instance.
		 */
		public function NamespaceExportInfo() {
			super();
		}

		private var _classExportInfoList:Array=[];

		private var _generatorResults:Array=[];

		private var _namespaceTitle:String="MyNewNamespace";

		private var _schemaURL:String="http://www.";

		private var _targetClassNamespace:String="";

		[Bindable(event="classExportInfoListChanged")]
		/**
		 * An array of <code>ClassExportInfo</code> instances. 
		 */
		public function get classExportInfoList():Array {
			return _classExportInfoList;
		}

		[Bindable(event="generatorResultsChanged")]
		/**
		 * An array of <code>GeneratorResult</code> instances. 
		 */
		public function get generatorResults():Array {
			return _generatorResults;
		}

		/**
		 * True if this instances already contains a <code>ClassExportInfo</code> instance for the specified <code>Type</code>
		 * @param type the specified <code>Type</code> instance.
		 */
		public function hasClassExportInfo(type:Type):Boolean {
			return _classExportInfoList.some(function(item:ClassExportInfo, index:int, arr:Array):Boolean {
					return (item.type === type);
				});
		}

		/**
		 * The title of the namespace. e.g. MyNewNamespace 
		 */
		public function get namespaceTitle():String {
			return _namespaceTitle;
		}

		[Bindable(event="namespaceTitleChanged")]
		/**
		 * @private
		 */		
		public function set namespaceTitle(value:String):void {
			if (value != _namespaceTitle) {
				_namespaceTitle=value;
				dispatchEvent(new Event("namespaceTitleChanged"));
			}
		}

		/**
		 * The URL for the generated schema file. e.g. http://www.mydomain.com/schema/mynewnamespace 
		 */
		public function get schemaURL():String {
			return _schemaURL;
		}

		[Bindable(event="schemaURLChanged")]
		/**
		 * @private 
		 */
		public function set schemaURL(value:String):void {
			if (value != _schemaURL) {
				_schemaURL=value;
				dispatchEvent(new Event("schemaURLChanged"));
			}
		}

		/**
		 * The actionscript namespace for the generated org.springextensions.actionscript.samples.stagewiring.classes. All generated actionscript org.springextensions.actionscript.samples.stagewiring.classes
		 * will receive this namespace. e.g. org.springextensions.actionscript.customnamespaces
		 */
		public function get targetClassNamespace():String {
			return _targetClassNamespace;
		}

		[Bindable(event="targetClassNamespaceChanged")]
		/**
		 * @private
		 */
		public function set targetClassNamespace(value:String):void {
			if (value != _targetClassNamespace) {
				_targetClassNamespace=value;
				dispatchEvent(new Event("targetClassNamespaceChanged"));
			}
		}
	}
}