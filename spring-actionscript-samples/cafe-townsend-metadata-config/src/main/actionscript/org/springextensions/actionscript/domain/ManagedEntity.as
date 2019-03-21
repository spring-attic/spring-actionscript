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
package org.springextensions.actionscript.domain {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * A managed entity keeps track of the changes made to its properties.
	 *
	 * @author Christophe Herreman
	 */
	public class ManagedEntity extends Entity {

		private var _isDirty:Boolean = false;
		private var _properties:Array = new Array();
		private var _eventDispatcher:IEventDispatcher;

		/**
		 * Creates a new <code>ManagedEntity</code> instance.
		 */
		public function ManagedEntity(id:* = -1) {
			super(id);
			_eventDispatcher = new EventDispatcher(this);
		}

		/**
		 *
		 */
		public function getProperty(name:String):* {
			var result:*;
			var entityProperty:ManagedEntityProperty = getManagedEntityProperty(name);

			if (entityProperty) {
				result = entityProperty.value;
			}
			else {
				//throw new IllegalArgumentError("A property '" + name + "' was not found on this entity.");
				result = null;
			}
			return result;
		}

		/**
		 *
		 */
		public function setProperty(name:String, value:*):void {
			if (hasProperty(name)) {
				var property:ManagedEntityProperty = getManagedEntityProperty(name);
				property.value = value;
				dispatchEvent(new Event("isDirtyChanged"));
			}
			else {
				_properties.push(new ManagedEntityProperty(name, value));
			}
		}

		/**
		 *
		 */
		public function hasProperty(name:String):Boolean {
			return (getManagedEntityProperty(name) != null);
		}

		/**
		 *
		 */
		public function get isNew():Boolean {
			return (id == -1);
		}

		/**
		 *
		 */
		[Bindable("isDirtyChanged")]
		public function get isDirty():Boolean {
			var result:Boolean = false;

			if (isNew)
				return true;

			for (var i:int = 0; i<_properties.length; i++) {
				if (_properties[i].isDirty) {
					result = true;
					break;
				}
			}

			return result;
		}

		/**
		 *
		 */
		public function set isDirty(value:Boolean):void {
			_isDirty = value;
			if (!value) {
				for (var i:int = 0; i<_properties.length; i++) {
					_properties[i].isDirty = value;
				}
			}
			dispatchEvent(new Event("isDirtyChanged"));
		}

		/**
		 *
		 */
		private function getManagedEntityProperty(name:String):ManagedEntityProperty {
			var result:ManagedEntityProperty;

			for (var i:int = 0; i<_properties.length; i++) {
				if (_properties[i].name == name) {
					result = _properties[i];
					break;
				}
			}

			return result;
		}

	}
}
	import mx.events.PropertyChangeEvent;
	import org.springextensions.actionscript.domain.ManagedEntity;

class ManagedEntityProperty {
	private var _name:String = "";
	private var _value:*;
	private var _originalValue:*;
	private var _isDirty:Boolean = false;

	public function ManagedEntityProperty(name:String, value:*) {
		this.name = name;
		this.value = value;
	}

	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
	}

	public function get value():* {
		return _value;
	}

	public function set value(v:*):void {
		_value = v;
		_isDirty = (_originalValue != v);
	}

	public function get originalValue():* {
		return _originalValue;
	}

	public function set originalValue(value:*):void {
		_originalValue = value;
	}

	public function get isDirty():Boolean {
		var result:Boolean = _isDirty;

		if (value is ManagedEntity) {
			result = ManagedEntity(value).isDirty;
		}

		return result;
	}

	public function set isDirty(dirty:Boolean):void {
		_isDirty = dirty;
		if (!dirty) {
			_originalValue = value;
		}
	}

}