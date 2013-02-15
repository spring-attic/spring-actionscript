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
package org.springextensions.actionscript.metadata {
	import flash.errors.IllegalOperationError;

	import org.as3commons.reflect.IMetadataContainer;

	/**
	 * Abstract base class for <code>IMetadataProcessor</code> implementations.
	 * @author Roland Zwaga
	 * @docref annotations.html
	 * @sampleref metadataprocessor
	 */
	public class AbstractMetadataProcessor implements IMetadataProcessor {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>AbstractMetadataProcessor</code> instance.
		 * @param processBefore value to be assigned to the <code>processBeforeInitialization</code> property.
		 * @param metadataNames value to be assigned to the <code>metadataNames</code> property.
		 */
		public function AbstractMetadataProcessor(processBefore:Boolean, metadataNames:Array = null) {
			super();
			init(processBefore, metadataNames);
		}

		/**
		 * Initializes the current <code>AbstractMetadataProcessor</code>.
		 * @param processBefore value to be assigned to the <code>processBeforeInitialization</code> property.
		 * @param metadataNames value to be assigned to the <code>metadataNames</code> property.
		 */
		protected function init(processBefore:Boolean, metadataNames:Array):void {
			_metadataNames = (metadataNames != null) ? metadataNames : [];
			_processBeforeInitialization = processBefore;
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// metadataNames
		// ----------------------------

		private var _metadataNames:Array;

		/**
		 * @inheritDoc
		 */
		public function get metadataNames():Array {
			return _metadataNames;
		}

		// ----------------------------
		// processBeforeInitialization
		// ----------------------------

		private var _processBeforeInitialization:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get processBeforeInitialization():Boolean {
			return _processBeforeInitialization;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Throws an error when invoked directly, needs to be overriden by a subclass.
		 * @throws flash.errors.IllegalOperationError
		 */
		public function process(instance:Object, container:IMetadataContainer, name:String, objectName:String):void {
			throw new IllegalOperationError("method process not implemented in abstract base class");
		}
	}
}