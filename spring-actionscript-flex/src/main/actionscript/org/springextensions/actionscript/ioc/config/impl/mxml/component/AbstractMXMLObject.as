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
package org.springextensions.actionscript.ioc.config.impl.mxml.component {
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;

	import mx.core.IMXMLObject;

	import org.as3commons.lang.ICloneable;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.mxml.ISpringConfigurationComponent;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;

	/**
	 * Abstract base class for non-visual MXML components
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractMXMLObject extends EventDispatcher implements IMXMLObject, ICloneable, ISpringConfigurationComponent {

		public function AbstractMXMLObject(self:AbstractMXMLObject) {
			super();
			if (self !== this) {
				throw new IllegalOperationError("AbstractMXMLObject is abstract");
			}
		}

		private var _document:Object;

		/**
		 *  The MXML document that created this object.
		 */
		public function get document():Object {
			return _document;
		}

		private var _id:String;

		/**
		 * The identifier used by <code>document</code> to refer to this object.
		 */
		public function get id():String {
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:String):void {
			_id = value;
		}

		/**
		 * @inheritDoc
		 */
		public function initialized(document:Object, id:String):void {
			_document = document;
			_id = id;
		}

		protected var _isInitialized:Boolean = false;

		public function get isInitialized():Boolean {
			return _isInitialized;
		}

		public function initializeComponent(context:IApplicationContext, defaultDefinition:IBaseObjectDefinition):void {
			throw new Error("method not implemented in abstract base");
		}

		/**
		 * @throws Error subclasses of <code>AbstractMXMLObject</code> need to implement this method otherwise an Error is thrown.
		 * @inheritDoc
		 */
		public function clone():* {
			throw new Error("method not implemented in abstract base");
		}

	}
}
