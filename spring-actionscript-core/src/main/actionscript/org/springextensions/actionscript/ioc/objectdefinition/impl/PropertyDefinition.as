/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.springextensions.actionscript.ioc.objectdefinition.impl {
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.StringUtils;
	/**
	 * Describes the the configuration of a single instance property.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PropertyDefinition implements ICloneable {

		public function PropertyDefinition(propertyName:String, propertyValue:*, ns:String=null, propertyIsStatic:Boolean=false, lazy:Boolean=false, lazyResolving:Boolean=false) {
			super();
			_name = propertyName;
			_valueDefinition = ArgumentDefinition.newInstance(propertyValue, lazyResolving);
			_namespaceURI = ns;
			_isStatic = propertyIsStatic;
			_isLazy = lazy;
			_lazyPropertyResolving = lazyResolving;
		}

		private var _isLazy:Boolean;
		private var _isSimple:Boolean;
		private var _isStatic:Boolean;
		private var _lazyPropertyResolving:Boolean;
		private var _name:String;
		private var _namespaceURI:String;
		private var _qName:QName;
		private var _valueDefinition:ArgumentDefinition;

		public function get isLazy():Boolean {
			return _isLazy;
		}

		public function set isLazy(value:Boolean):void {
			_isLazy = value;
		}

		public function get isSimple():Boolean {
			return _isSimple;
		}

		public function set isSimple(value:Boolean):void {
			_isSimple = value;
		}

		public function get isStatic():Boolean {
			return _isStatic;
		}

		public function set isStatic(value:Boolean):void {
			_isStatic = value;
		}

		public function get lazyPropertyResolving():Boolean {
			return _lazyPropertyResolving;
		}

		public function set lazyPropertyResolving(value:Boolean):void {
			_lazyPropertyResolving = value;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get namespaceURI():String {
			return _namespaceURI;
		}

		public function set namespaceURI(value:String):void {
			_namespaceURI = value;
		}

		public function get qName():QName {
			return _qName ||= createQName();
		}

		public function get valueDefinition():ArgumentDefinition {
			return _valueDefinition;
		}

		public function set valueDefinition(value:ArgumentDefinition):void {
			_valueDefinition = value;
		}

		public function clone():* {
			var prop:PropertyDefinition = new PropertyDefinition(this.name, this.valueDefinition.argumentValue, this.namespaceURI, this.isStatic, this.isLazy, this.lazyPropertyResolving);
			prop.isSimple = this.isSimple;
			return prop;
		}

		public function toString():String {
			return "PropertyDefinition{name:\"" + _name + "\", namespaceURI:\"" + _namespaceURI + "\", value:" + _valueDefinition + ", isStatic:" + _isStatic + ", isSimple:\"" + _isSimple + ", isLazy:\"" + _isLazy + ", lazyPropertyResolving:\"" + _lazyPropertyResolving + "\"}";
		}

		private function createQName():QName {
			var ns:String = StringUtils.hasText(_namespaceURI) ? _namespaceURI : "";
			var prefix:String = StringUtils.hasText(ns) ? null : "";
			return new QName(new Namespace(prefix, ns), _name);
		}
	}
}
