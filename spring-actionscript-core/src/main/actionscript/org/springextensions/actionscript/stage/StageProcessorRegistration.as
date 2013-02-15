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
package org.springextensions.actionscript.stage {
	import flash.utils.Dictionary;

	/**
	 * Manages an <code>IObjectSelector</code> and its associated <code>IStageProcessor</code> instances.
	 * @see org.springextensions.actionscript.stage.IObjectSelector IObjectSelector
	 * @see org.springextensions.actionscript.stage.IStageProcessor IStageProcessor
	 * @author Roland Zwaga
	 * @sampleref stagewiring
	 */
	public class StageProcessorRegistration implements IObjectSelectorAware {

		private var _documentLookup:Dictionary;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>StageProcessorRegistration</code> instance.
		 * @param name Optional name for an initial <code>IStageProcessor</code>
		 * @param stageProcessor Optional initial <code>IStageProcessor</code> that will be added.
		 *
		 */
		public function StageProcessorRegistration(name:String = null, stageProcessor:IStageProcessor = null, objectSelector:IObjectSelector = null) {
			super();

			_processors = new Dictionary();
			_documentLookup = new Dictionary(true);
			_names = new Array();

			if ((name != null) && (stageProcessor != null) && (objectSelector != null)) {
				addStageProcessor(name, stageProcessor, objectSelector);
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// processors
		// ----------------------------

		private var _processors:Dictionary;

		/**
		 * A <code>Dictionary</code> lookup for the associated <code>IStageProcessor</code> instances.
		 */
		public function get processors():Dictionary {
			return _processors;
		}

		// ----------------------------
		// objectSelector
		// ----------------------------

		private var _objectSelector:IObjectSelector;

		/**
		 * The <code>IObjectSelector</code> that determines if the associated <code>IStageProcessor</code> instances
		 * will be invoked or not.
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
		// names
		// ----------------------------

		private var _names:Array;

		/**
		 * An <code>Array</code> of <code>Strings</code> that represent the names of the associated <code>IStageProcessor</code> instances.
		 * <p>This list also determines the order in which the <code>IStageProcessor</code> instances will be invoked.</p>
		 */
		public function get names():Array {
			return _names;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function getAllProcessors():Array {
			var result:Array = [];
			for each (var name:String in _names) {
				result = result.concat(_processors[name]);
			}
			return result;
		}

		/**
		 * Returns the <code>IStageProcessors</code> for the specified name, or null if the name doesn't exist in the current <code>StageProcessorRegistration</code> instance.
		 * @param name The specifed name
		 * @return An <code>Array</code> of <code>IStageProcessors</code> for the specified name, or null if the name doesn't exist.
		 */
		public function getProcessorsByName(name:String):Array {
			name = name.toLowerCase();
			var result:Array = null;
			if (_names.indexOf(name) > -1) {
				result = _processors[name] as Array;
			}
			return result;
		}

		/**
		 * Adds or override the <code>IStageProcessor</code> for the specified name. If the <code>objectSelector</code> property is null the <code>objectSelector</code> of
		 * the specified <code>IStageProcessor</code> will be assigned. Unless the <code>overrideSelector</code> is set to true, in which case the <code>objectSelector</code>
		 * property assignement is forced.
		 * @param name The name associated with the specified <code>IStageProcessor</code>.
		 * @param stageProcessor The <code>IStageProcessor</code> that will be added.
		 * @param overrideSelector If true the <code>objectSelector</code> property will be assigned regardless whether its null or not.
		 */
		public function addStageProcessor(name:String, stageProcessor:IStageProcessor, objectSelector:IObjectSelector, overrideSelector:Boolean = false):void {
			name = name.toLowerCase();
			var nameExists:Boolean = true;
			if (_names.indexOf(name) < 0) {
				_names[_names.length] = name;
				nameExists = false;
			}
			addProcessorToDocumentLookup(stageProcessor);
			var arr:Array = _processors[name] as Array;
			if (arr == null) {
				arr = [];
				_processors[name] = arr;
			}
			if (nameExists) {
				var procReplaced:Boolean = false;
				for (var i:int = 0; i < arr.length; i++) {
					var proc:IStageProcessor = arr[i];
					if (proc.document === stageProcessor.document) {
						arr[i] = stageProcessor;
						procReplaced = true;
						break;
					}
				}
				if (!procReplaced) {
					arr[arr.length] = stageProcessor;
				}
			} else {
				arr[arr.length] = stageProcessor;
			}
			if ((_objectSelector == null) || (overrideSelector)) {
				_objectSelector = objectSelector;
			}
		}

		public function removeStageProcessor(stageProcessor:IStageProcessor):void {
			for (var name:* in _processors) {
				var procs:Array = _processors[name];
				if (procs != null) {
					for (var i:uint = 0; i < procs.length; i++) {
						if (procs[i] === stageProcessor) {
							procs.splice(i, 1);
							if (procs.length < 1) {
								var idx:int = _names.indexOf(String(name));
								if (idx > -1) {
									_names.splice(idx, 1);
								}
								_processors[name] = null;
								delete _processors[name];
							}
							break;
						}
					}
				} else {
					delete _processors[name];
				}
			}
			removeProcessorFromDocumentLookup(stageProcessor);
		}

		/**
		 * Removes the <code>IStageProcessor</code> with the specified name.
		 * @param name The name of the <code>IStageProcessor</code> that will be removed
		 */
		public function removeStageProcessorByName(name:String, document:Object):void {
			name = name.toLowerCase();
			var procs:Array = _processors[name] as Array;
			if (procs != null) {
				var proc:IStageProcessor = null;
				for each (var stageProcessor:IStageProcessor in procs) {
					if (stageProcessor.document === document) {
						proc = stageProcessor;
						break;
					}
				}
				if (proc != null) {
					removeProcessorFromDocumentLookup(proc);
					var idx:int = procs.indexOf(proc);
					if (idx > -1) {
						procs.splice(idx, 1);
						if (procs.length < 1) {
							idx = _names.indexOf(name);
							if (idx > -1) {
								_names.splice(idx, 1);
							}
							_processors[name] = null;
							delete _processors[name];
						}
					}
				}
			}
		}

		/**
		 * Returns true if the current <code>StageProcessorRegistration</code> contains an <code>IStageProcessor</code>
		 * instance with the same <code>name</code> and <code>document</code> property as the specified <code>IStageProcessor</code>
		 * @param stageProcessor
		 */
		public function hasProcessorWithName(name:String, stageProcessor:IStageProcessor):Boolean {
			name = name.toLowerCase();
			return _names.some(function(item:String, index:int, arr:Array):Boolean {
				if (name == item) {
					var arr:Array = _processors[name];
					if (arr != null) {
						for each (var proc:IStageProcessor in arr) {
							if (proc.document === stageProcessor.document) {
								return true;
							}
						}
					}
				}
				return false;
			});
		}

		/**
		 * Returns true if the current <code>StageProcessorRegistration</code> contains the specified <code>IStageProcessor</code>
		 * instance.
		 * @param stageProcessor The specified <code>IStageProcessor</code> instance.
		 */
		public function containsProcessor(stageProcessor:IStageProcessor):Boolean {
			for each (var name:String in _names) {
				var arr:Array = _processors[name];
				if (arr != null) {
					if (arr.indexOf(stageProcessor) > -1) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * Returns an <code>Array</code> of <code>IStageProcessor</code> instances of the specified <code>Class</code>
		 * @param type The specified <code>Class</code>
		 * @return An <code>Array</code> of <code>IStageProcessor</code> instances, or null if no instances of the specified <code>Class</code> exist.
		 *
		 */
		public function getProcessorsByType(type:Class):Array {
			var result:Array;
			for (var name:String in _processors) {
				var procs:Array = _processors[name];
				if (procs != null) {
					for each (var proc:IStageProcessor in procs) {
						if (proc is type) {
							if (result == null) {
								result = [];
							}
							result[result.length] = proc;
						}
					}
				}
			}
			return result;
		}

		public function getProcessorsByDocument(document:Object):Array {
			return _documentLookup[document] as Array;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function addProcessorToDocumentLookup(stageProcessor:IStageProcessor):void {
			var arr:Array = _documentLookup[stageProcessor.document] as Array;
			if (arr == null) {
				arr = [];
			}
			arr[arr.length] = stageProcessor;
			_documentLookup[stageProcessor.document] = arr;
		}

		protected function removeProcessorFromDocumentLookup(stageProcessor:IStageProcessor):void {
			var arr:Array = _documentLookup[stageProcessor.document] as Array;
			if (arr != null) {
				var idx:int = arr.indexOf(stageProcessor);
				if (idx > -1) {
					arr.splice(idx, 1);
				}
			}
		}
	}
}