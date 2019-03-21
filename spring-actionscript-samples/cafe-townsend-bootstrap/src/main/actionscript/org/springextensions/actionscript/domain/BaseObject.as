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
	
	//import flash.system.ApplicationDomain;
	import flash.system.ApplicationDomain;
	
	import mx.collections.IList;
	import mx.utils.ObjectUtil;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.Enum;
	import org.as3commons.lang.ICloneable;
	import org.as3commons.lang.IEquals;
	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.Variable;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.utils.TypeResolver;
	
	/**
	 * Base object that offers core functionality for working with object such as an <code>equals()</code>, <code>clone()</code> and <code>copyFrom()</code>
	 * method.
	 * @author Christophe Herreman
	 */
	public class BaseObject implements IEquals, ICloneable, ICopyFrom, IApplicationDomainAware {
		
		protected static const PROPERTY_PROTOTOYPE:String = "prototype";

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>BaseObject</code> instance.
		 */
		public function BaseObject() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// applicationDomain
		// ----------------------------

		private var _applicationDomain:ApplicationDomain;

		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Clones this object.
		 *
		 * @return a clone (exact copy) of this object
		 */
		public function clone():* {
			var clazz:Class = ClassUtils.forInstance(this,_applicationDomain);
			var result:* = new clazz();
			result.copyFrom(this);
			return result;
		}
		
		/**
		 * Copies all properties from the given object into this object.
		 *
		 * @param other the other object from which to copy all its properties
		 */
		public function copyFrom(other:*):void {
			if (this != other) {
				var type:Type = Type.forInstance(this, _applicationDomain);
				
				// copy all variables
				for each (var variable:Variable in type.variables) {
					cloneField(variable.name, other);
				}
				
				// copy all accessors (properties defined by getter/setter) if they have READ_WRITE access
				for each (var acc:Accessor in type.accessors) {
					if (acc.access == AccessorAccess.READ_WRITE) {
						cloneField(acc.name, other);
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function equals(other:Object):Boolean {
			return doEquals(other, [PROPERTY_PROTOTOYPE]);
		}
		
		/**
		 * Clones a single field.
		 *
		 * @param name the name of the field
		 * @param other the original object
		 */
		protected function cloneField(name:String, other:*):void {
			var newValue:* = other[name];
			
			if (newValue is IList) {
				if (this[name]) {
					this[name].removeAll();

					for each (var item:*in newValue) {
						var clonedItem:* = clonePropertyValue(item);
						this[name].addItem(clonedItem);
					}
				}
			} else if (ObjectUtil.isSimple(newValue)) {
				this[name] = newValue;
			} else {
				this[name] = clonePropertyValue(newValue, name);
			}
		}
		
		/**
		 * Clones the value of a property/field. Subclasses can override this method if they wish to clone
		 * properties in a specific way.
		 *
		 * @param value the value of the property
		 * @param name the name of the property
		 */
		protected function clonePropertyValue(value:*, name:String = ""):* {
			var result:*;
			
			if (value is ICloneable) {
				result = value.clone();
			} else if (value is Enum) {
				result = value;
			} else if (value is IList) {
				result.removeAll();
				
				/*if (property is TypedCollection) {
				   result = new TypedCollection((property as TypedCollection).type);
				   }
				   else {
				   var clazz:Class = ClassUtils.forInstance(property);
				   result = ClassUtils.newInstance(clazz);
				 }*/
				
				for each (var item:*in value) {
					result.addItem(clonePropertyValue(item));
				}
			} else {
				result = ObjectUtils.clone(value);
			}
			return result;
		}
		
		/**
		 *
		 */
		protected function doEquals(other:*, ignoredProperties:Array):Boolean {
			if (this == other) {
				return true;
			}
			
			if (!(other is ClassUtils.forInstance(this,_applicationDomain))) {
				return false;
			}
			
			var type:Type = Type.forInstance(this, _applicationDomain);
			var fields:Array = type.accessors.concat(type.variables); // variables + accessors
			
			// check each field for equality
			for each (var field:Field in fields) {
				var isIgnoredProperty:Boolean = (ignoredProperties.indexOf(field.name) != -1);
				
				if (!isIgnoredProperty) {
					if (this[field.name] != null && other[field.name] != null) {
						var clazz:Class = field.type.clazz;
						
						if (clazz == null) {
							try {
								clazz = ClassUtils.forName(typeof(this[field.name]),_applicationDomain);
							} catch (e:Error) {
								clazz = TypeResolver.resolveType(this[field.name]);
							}
						}
						
						if (ClassUtils.isImplementationOf(clazz, IEquals,_applicationDomain)) {
							if (!IEquals(this[field.name]).equals(other[field.name])) {
								return false;
							}
						} else {
							if (this[field.name] != other[field.name]) {
								return false;
							}
						}
					} else if (this[field.name] != other[field.name]) {
						return false;
					}
				}
			}
			
			return true;
		}
	}
}