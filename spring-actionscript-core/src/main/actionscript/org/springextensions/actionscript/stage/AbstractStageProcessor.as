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
package org.springextensions.actionscript.stage {

	import flash.errors.IllegalOperationError;

	import org.springextensions.actionscript.ioc.IDisposable;

	/**
	 * Abstract base class for <code>IStageProcessor</code> implementations.
	 * @author Roland Zwaga
	 * @sampleref stagewiring
	 * @docref container-documentation.html#the_istageprocessor_interface
	 */
	public class AbstractStageProcessor implements IStageProcessor, IObjectSelectorAware, IDisposable {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Abstract constructor
		 * @throws flash.errors.IllegalOperationError When called directly
		 */
		public function AbstractStageProcessor(self:AbstractStageProcessor) {
			super();
			abstractStageProcessorInit(self);
		}

		protected function abstractStageProcessorInit(self:AbstractStageProcessor):void {
			if (self != this) {
				throw new IllegalOperationError("AbstractStageProcessor is abstract");
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// objectSelector
		// ----------------------------

		private var _objectSelector:IObjectSelector;

		/**
		 * @inheritDoc
		 */
		public function get objectSelector():IObjectSelector {
			return _objectSelector;
		}

		/**
		 * @private
		 */
		public function set objectSelector(value:IObjectSelector):void {
			_objectSelector = value;
		}

		// ----------------------------
		// document
		// ----------------------------

		private var _document:Object;

		/**
		 * @inheritDoc
		 */
		public function get document():Object {
			return _document;
		}

		/**
		 * @private
		 */
		public function set document(value:Object):void {
			_document = value;
		}

		// ----------------------------
		// isDisposed
		// ----------------------------

		private var _isDisposed:Boolean = false;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @throws flash.errors.IllegalOperationError When called directly
		 * @inheritDoc
		 */
		public function process(object:Object):Object {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		public function dispose():void {
			_document = null;
			_isDisposed = true;
		}

	}
}