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
package org.springextensions.actionscript.stage {
	import flash.display.DisplayObject;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.stageprocessing.impl.AbstractStageObjectProcessor;

	/**
	 * This <code>IStageProcessor</code> uses certain stage components to be assigned to a specified target object. The assignment is done either by setting a property or
	 * calling a method, specified by the <code>targetProperty</code> and <code>targetMethod</code> properties respectively.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class GenericStageProcessor extends AbstractStageObjectProcessor {

		private static const LOGGER:ILogger = getClassLogger(GenericStageProcessor);

		/**
		 * Creates a new <code>GenericStageProcessor</code> instance.
		 */
		public function GenericStageProcessor() {
			super(this);
		}

		private var _targetObject:Object;

		/**
		 * The name of the object as declared in the application context to which the selected stage component(s) will be assigned.
		 */
		public function get targetObject():Object {
			return _targetObject;
		}

		/**
		 * @private
		 */
		public function set targetObject(value:Object):void {
			_targetObject = value;
		}

		private var _targetProperty:String;

		/**
		 * The name of the property on the target object to which the selected stage component(s) will be assigned.
		 */
		public function get targetProperty():String {
			return _targetProperty;
		}

		/**
		 * @private
		 */
		public function set targetProperty(value:String):void {
			_targetProperty = value;
		}

		private var _targetMethod:String;

		/**
		 * The name of the method on the target object to which the selected stage component(s) will be passed.
		 */
		public function get targetMethod():String {
			return _targetMethod;
		}

		/**
		 * @private
		 */
		public function set targetMethod(value:String):void {
			_targetMethod = value;
		}

		/**
		 * Either assigns the specified object to the specified property (<code>targetProperty</code>)
		 * or calls the specified method (<code>targetMethod</code>) and passes the object to it.
		 * @throws Error If neither <code>targetProperty</code> nor <code>targetMethod</code> has been set.
		 */
		override public function process(object:DisplayObject):DisplayObject {
			Assert.notNull(_targetObject, "targetObject must not be null");
			if ((!StringUtils.hasText(_targetProperty)) && (!StringUtils.hasText(_targetMethod))) {
				throw new Error("Either targetProperty or targetMethod property must have a value");
			}
			if (StringUtils.hasText(_targetProperty)) {
				_targetObject[_targetProperty] = object;
			}
			if (StringUtils.hasText(_targetMethod)) {
				_targetObject[_targetMethod](object);
			}
			return object;
		}
	}
}
