/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.context.support.mxml
{
	import flash.errors.IllegalOperationError;
	
	import mx.core.IMXMLObject;
	
	import org.as3commons.lang.ICloneable;

	/**
	 * Abstract base class for non-visual MXML components
	 * @author Roland Zwaga
	 * @docref container-documentation.html#composing_mxml_based_configuration_metadata
	 */
	public class AbstractMXMLObject implements IMXMLObject, ICloneable {
		
		public function AbstractMXMLObject(self:AbstractMXMLObject) {
			super();
			abstractMXMLObjectInit(self);
		}
		
		protected function abstractMXMLObjectInit(self:AbstractMXMLObject):void {
			if (self != this) {
				throw new IllegalOperationError("AbstractMXMLObject is abstract");
			}
		}

		private var _document:Object;
		/**
		 *  The MXML document that created this object.
		 */
		public function get document():Object{
			return _document;
		}
		
		private var _id:String;
		/**
		 * The identifier used by <code>document</code> to refer to this object.
		 */
		public function get id():String{
			return _id;
		}
		/**
		 * @private
		 */
		public function set id(value:String):void{
			_id = value;
		}

		/**
		 * @inheritDoc
		 */
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		protected var _isInitialized:Boolean = false;
		public function get isInitialized():Boolean {
			return _isInitialized;
		}
		
		public function initializeComponent():void {
			throw new Error("method not implemented in abstract base");
		}
		
		/**
		 * @throws Error subclasses of <code>AbstractMXMLObject</code> need to implement this method otherwise an Error is thrown.
		 * @inheritDoc
		 */
		public function clone():*{
			throw new Error("method not implemented in abstract base");
		}
		
	}
}