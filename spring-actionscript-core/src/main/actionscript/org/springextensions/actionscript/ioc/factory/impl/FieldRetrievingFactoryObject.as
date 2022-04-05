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
package org.springextensions.actionscript.ioc.factory.impl {
	import flash.system.ApplicationDomain;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IllegalArgumentError;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.ioc.factory.IInitializingObject;

	/**
	 * <p><code>FieldRetrievingFactoryObject</code> is an <code>IFactoryObject</code> implementation which retrieves a static or non-static field value.
	 * It is typically used for retrieving public static constants, which may then be used to set a property value or
	 * constructor argument for another object.</p>
	 * <p>Configuration example of how to retrieve a field on an object instance:</p>
	 * <pre>
	 * &lt;object class="org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject"&gt;
	 *   &lt;property name="targetObject" ref="modelLocator" /&gt;
	 *   &lt;property name="targetField" value="users" /&gt;
	 * &lt;/object&gt;
	 * </pre>
	 * <p>Configuration example of how to retrieve a static field on a class:</p>
	 * <pre>
	 * &lt;object class="org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject"&gt;
	 *   &lt;property name="targetClass" value="mx.core.FlexVersion"/&gt;
	 *   &lt;property name="staticField" value="CURRENT_VERSION"/&gt;
	 * &lt;/object&gt;
	 * </pre>
	 * <p>Configuration example of how to retrieve a field on a class property chain:</p>
	 * <pre>
	 * &lt;object class="org.springextensions.actionscript.ioc.factory.config.FieldRetrievingFactoryObject"&gt;
	 *   &lt;property name="targetClass" value="mx.core.Application"/&gt;
	 *   &lt;property name="targetField" value="application.systemManager"/&gt;
	 * &lt;/object&gt;
	 * </pre>
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class FieldRetrievingFactoryObject extends AbstractFactoryObject implements IInitializingObject, IApplicationDomainAware {
		private static const PERIOD:String = ".";

		/**
		*  Creates a new <code>FieldRetrievingFactoryObject</code> instance.
		*/
		public function FieldRetrievingFactoryObject() {
			super();
		}

		private var _applicationDomain:ApplicationDomain;
		private var _field:Field;
		private var _propertiesSet:Boolean = false;
		private var _staticField:String = "";
		private var _targetClass:Class;
		private var _targetField:String = "";
		private var _targetObject:*;

		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * The static field whose value needs to be retrieved
		 */
		public function get staticField():String {
			return _staticField;
		}

		/**
		 * @private
		 */
		public function set staticField(value:String):void {
			_staticField = StringUtils.trim(value);
		}

		/**
		 * The class that holds the static field value defined by the staticField property.
		 * @return
		 *
		 */
		public function get targetClass():Class {
			return _targetClass;
		}

		/**
		 * @private
		 */
		public function set targetClass(value:Class):void {
			_targetClass = value;
		}

		/**
		 * The field whose value needs to be retrieved
		 */
		public function get targetField():String {
			return _targetField;
		}

		/**
		 * @private
		 */
		public function set targetField(value:String):void {
			_targetField = StringUtils.trim(value);
		}

		/**
		 * The target instance that holds the property value defined by the targetField property.
		 */
		public function get targetObject():* {
			return _targetObject;
		}

		/**
		 * @private
		 */
		public function set targetObject(value:*):void {
			_targetObject = value;
		}

		/**
		 * @inheritDoc
		 */
		public function afterPropertiesSet():void {
			if (!_propertiesSet) {
				if (targetClass != null && targetObject != null) {
					throw new IllegalArgumentError("Specify either targetClass or targetObject, not both");
				}

				if (!targetClass && !targetObject) {
					if (targetField != "") {
						throw new IllegalArgumentError("Specify targetClass or targetObject in combination with targetField");
					}

					// Try to parse static field into class and field.
					var lastDotIndex:int = staticField.lastIndexOf(PERIOD);

					if (-1 == lastDotIndex) {
						throw new IllegalArgumentError("The staticField argument must be the full path to a static property e.g. 'mx.logging.LogEventLevel.DEBUG'");
					}

					var className:String = staticField.substring(0, lastDotIndex);
					var fieldName:String = staticField.substring(lastDotIndex + 1);
					targetClass = ClassUtils.forName(className, _applicationDomain);
					targetField = fieldName;
				} else if (targetField == "") {
					// Either targetClass or targetObject specified.
					throw new IllegalArgumentError("targetField is required");
				}

				// Try to get the exact method first.
				targetClass = (targetObject) ? ClassUtils.forInstance(targetObject, _applicationDomain) : targetClass;
				var type:Type = Type.forClass(targetClass, _applicationDomain);
				if (targetField.indexOf(PERIOD) < 0) {
					_field = type.getField(targetField);
				} else {
					_field = resolvePropertyChain();
				}
				_propertiesSet = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function getObject():* {
			afterPropertiesSet();

			if (targetObject) {
				return targetObject[targetField];
			} else if (targetClass) {
				return targetClass[targetField];
			}

			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function getObjectType():Class {
			afterPropertiesSet();

			var object:* = getObject();

			if (object) {
				return ClassUtils.forInstance(object, _applicationDomain);
			} else {
				return _field.type.clazz;
			}
		}

		private function resolvePropertyChain():Field {
			var propertyNames:Array = targetField.split(PERIOD);
			targetField = propertyNames.pop().toString();
			var propName:String;
			if (targetObject == null) {
				propName = String(propertyNames.shift());
				targetObject = targetClass[propName];
			}
			for each (propName in propertyNames) {
				targetObject = targetObject[propName];
			}
			var type:Type = Type.forInstance(targetObject, _applicationDomain);
			return type.getField(targetField);
		}
	}
}
