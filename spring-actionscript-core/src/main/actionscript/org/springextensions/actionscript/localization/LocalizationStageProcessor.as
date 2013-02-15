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
package org.springextensions.actionscript.localization {

	import flash.events.Event;
	import flash.utils.Dictionary;

	import mx.resources.IResourceManager;

	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.stage.AbstractStageProcessor;
	import org.springextensions.actionscript.stage.selectors.PropertyValueBasedObjectSelector;

	/**
	 * <code>IStageProcessor</code> that can assign resource values based on the value of specified property on a stage component.
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.stage.selectors.PropertyValueBasedObjectSelector PropertyValueBasedObjectSelector
	 * @docref container-documentation.html#the_localizationstageprocessor_class
	 * @sampleref localization
	 * @externalref http://labs.adobe.com/wiki/index.php/Flex_3:Feature_Introductions:_Runtime_Localization
	 */
	public class LocalizationStageProcessor extends AbstractStageProcessor {

		/**
		 * A Dictionary instance used to keep track of the stage components that have already been
		 * processed by the current <code>LocalizationStageProcessor</code>. This Dictionary
		 * instance is created with the <code>weakKeys</code> constructor argument set to <code>true</code>
		 * and will therefore not cause any memory leaks should any of the components be removed
		 * from the stage permanently.
		 */
		protected var componentCache:Dictionary;

		/**
		 * Creates a new <code>LocalizationStageProcessor</code> instance.
		 */
		public function LocalizationStageProcessor() {
			super(this);
			componentCache = new Dictionary(true);
			_resourceSuffixes = ['text', 'label', 'toolTip', 'prompt', 'dataProvider', 'title', 'headerText'];
			objectSelector = new PropertyValueBasedObjectSelector();
		}

		private var _resourceManager:IResourceManager;

		/**
		 * The <code>IResourceManager</code> instance used to retrieve resource values from.
		 */
		public function get resourceManager():IResourceManager {
			return _resourceManager;
		}

		/**
		 * @private
		 */
		public function set resourceManager(value:IResourceManager):void {
			if (value !== _resourceManager) {
				disconnectListeners();
				_resourceManager = value;
				connectListeners();
			}
		}

		private var _resourceSuffixes:Array;

		/**
		 * <p>An <code>Array</code> of suffixes that correspond to property names on the stage component.</p>
		 * <p>For example, a button with id 'myButton':<br/>
		 * &lt;Button id="myButton"/&gt;<br/>
		 * Can have its label property assigned automatically if a resourceName exists with this name:<br/>
		 * myButton_label=Click this button</p>
		 * @default ['text','label','toolTip','prompt','dataProvider','title','headerText']
		 */
		public function get resourceSuffixes():Array {
			return _resourceSuffixes;
		}

		/**
		 * @private
		 */
		public function set resourceSuffixes(value:Array):void {
			_resourceSuffixes = value;
		}

		private var _bundleName:String;

		/**
		 * The name of the resource bundle that contains all te resource values.
		 */
		public function get bundleName():String {
			return _bundleName;
		}

		/**
		 * @private
		 */
		public function set bundleName(value:String):void {
			_bundleName = value;
		}

		override public function process(object:Object):Object {
			Assert.hasText(_bundleName, "resourceName property must not be null or empty");
			Assert.notNull(_resourceSuffixes, "bundleSuffixes property must not be null");
			Assert.notNull(_resourceManager, "resourceManager property must not be null");
			if (componentCache[object] == null) {
				componentCache[object] = true;
				var propertyName:String = (objectSelector as Object).hasOwnProperty("propertyName") ? objectSelector['propertyName'] : "id";
				assignResourceStrings(object, propertyName);
			}
			return object;
		}

		/**
		 * Removes the <code>reassignResourceStrings</code> method as an <code>Event.CHANGE</code> listener.
		 */
		protected function disconnectListeners():void {
			if (_resourceManager != null) {
				_resourceManager.removeEventListener(Event.CHANGE, resourceManagerChange_handler);
			}
		}

		/**
		 * Adds the <code>reassignResourceStrings</code> method as an <code>Event.CHANGE</code> listener.
		 */
		protected function connectListeners():void {
			if (_resourceManager != null) {
				_resourceManager.addEventListener(Event.CHANGE, resourceManagerChange_handler);
			}
		}

		/**
		 * Handles the <code>Event.CHANGE</code> on the <code>resourceManager</code>, when invoked it re-assigns all the resource
		 * values to each stage component that has been processed.
		 * @param event An <code>Event.ADDED</code> event
		 */
		protected function resourceManagerChange_handler(event:Event):void {
			var propertyName:String = (objectSelector as Object).hasOwnProperty("propertyName") ? objectSelector['propertyName'] : "id";
			for (var object:Object in componentCache) {
				assignResourceStrings(object, propertyName);
			}
		}

		/**
		 *
		 * @param object The stage component that will be processed
		 * @param propertyName The property name of the specified stage component whose value will be used as a base name for the resource values.
		 *
		 */
		protected function assignResourceStrings(object:Object, propertyName:String):void {
			_resourceSuffixes.forEach(function(item:String, idx:int, arr:Array):void {
					assignResourceString(object, propertyName, item);
				});
		}

		/**
		 * <p>Combines the <code>propertyName</code> and <code>resourceSuffix</code> into a resource name with the form <code>propertyName</code> + _ + <code>resourceSuffix</code>.</p>
		 * <p>If the specified <code>object</code> has a property with the name specified by the <code>resourceSuffix</code> value, if a necessary resource value exists it is assigned
		 * to the property</p>
		 * @param object The stage component that will be processed
		 * @param propertyName The property name of the specified stage component whose value will be used as a base name for the resource values.
		 * @param resourceSuffix The suffix that together with the property name value forms the resourcename
		 */
		protected function assignResourceString(object:Object, propertyName:String, resourceSuffix:String):void {
			if (object.hasOwnProperty(propertyName)) {
				var resourceName:String = String(object[propertyName]) + '_' + resourceSuffix;
				var value:Object = _resourceManager.getObject(_bundleName, resourceName);
				if ((value != null) && (object.hasOwnProperty(resourceSuffix))) {
					object[resourceSuffix] = value;
				}
			}
		}

		override public function dispose():void {
			super.dispose();
			componentCache = null;
			disconnectListeners();
			_resourceManager = null;
		}

	}
}