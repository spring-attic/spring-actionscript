/*
* Copyright 2007-2012 the original author or authors.
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
	import org.springextensions.actionscript.ioc.config.impl.RuntimeObjectReference;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ArgumentDefinition implements ICloneable {

		private var _value:*;
		private var _ref:RuntimeObjectReference;
		private var _lazyPropertyResolving:Boolean;
		
		/**
		 * Creates a new <code>ArgumentDefinition</code> instance.
		 */
		public function ArgumentDefinition(val:*, rf:RuntimeObjectReference=null, lazy:Boolean=false) {
			super();
			_value = val;
			_ref = rf;
			_lazyPropertyResolving = lazy;
		}

		public function get lazyPropertyResolving():Boolean {
			return _lazyPropertyResolving;
		}

		public function set lazyPropertyResolving(value:Boolean):void {
			_lazyPropertyResolving = value;
		}

		public function get value():* {
			return _value;
		}

		public function set value(val:*):void {
			_value = val;
		}

		public function get ref():RuntimeObjectReference {
			return _ref;
		}

		public function set ref(value:RuntimeObjectReference):void {
			_ref = value;
		}
		
		public function get argumentValue():* {
			return (_ref == null) ? _value : _ref;
		}

		public function clone():* {
			var refClone:RuntimeObjectReference = (ref != null) ? ref.clone() : null;
			return new ArgumentDefinition(value, refClone, lazyPropertyResolving);
		}
		
		public static function newInstance(value:*, lazyPropertyResolving:Boolean=false):ArgumentDefinition {
			if (value is ArgumentDefinition) {
				return value;
			}
			return (value is RuntimeObjectReference) ? new ArgumentDefinition(null, value, lazyPropertyResolving) : new ArgumentDefinition(value, null, lazyPropertyResolving);
		}
		
		public static function newInstances(values:Array):Vector.<ArgumentDefinition> {
			if ((values) && (values.length > 0)) {
				var result:Vector.<ArgumentDefinition> = new Vector.<ArgumentDefinition>();
				var len:int = values.length;
				for(var i:int=0; i <len; ++i) {
					result[result.length] = newInstance(values[i]);
				}
				return result;
			}
			return null;
		}

	}
}
