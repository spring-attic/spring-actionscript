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
	import flash.events.IEventDispatcher;
	/**
	 * Base class for export info org.springextensions.actionscript.samples.stagewiring.classes
	 * @author Roland Zwaga
	 */
	public class AbstractExportInfo extends EventDispatcher {

		/**
		 * Creates a new <code>ExportInfoBase</code> instance
		 */
		public function AbstractExportInfo(target:IEventDispatcher=null) {
			super(target);
		}

		private var _attributeName:String;

		private var _constantName:String;

		/**
		 * The name of a constant field. e.g. CLASS_NAME_ATTR
		 */
		public function get constantName():String {
			return _constantName;
		}

		[Bindable(event="constantNameChanged")]
		/**
		 * @private
		 */		
		public function set constantName(value:String):void {
			if (value != _constantName) {
				_constantName=value;
				dispatchEvent(new Event("constantNameChanged"));
			}
		}


		/**
		 * The name of an XML element. e.g. class-name
		 */
		public function get xmlName():String {
			return _attributeName;
		}

		[Bindable(event="attributeNameChanged")]
		/**
		 * @private
		 */
		public function set xmlName(value:String):void {
			if (value != _attributeName) {
				_attributeName=value;
				dispatchEvent(new Event("attributeNameChanged"));
			}
		}
	}
}