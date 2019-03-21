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
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistry;
	import org.springextensions.actionscript.util.Environment;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class PopupAndTooltipWireManager implements IDisposable {

		public static var instances:int = 0;

		private static const SYSTEM_MANAGER_NAME:String = "systemManager";
		private static const WINDOW_NAME:String = "window";

		private var _popups:Dictionary;
		private static var logger:ILogger = getClassLogger(PopupAndTooltipWireManager);

		/**
		 * Creates a new <code>PopupAndTooltipWireManager</code> instance.
		 */
		public function PopupAndTooltipWireManager() {
			super();
			_popups = new Dictionary(true);
			_cache = new Dictionary(true);
			instances++;
		}

		private var _isDisposed:Boolean;
		private var _popupManagerImpl:Object;
		private var _stageProcessorRegistry:IStageObjectProcessorRegistry;
		private var _toolTipManagerImpl:Object;
		private var _mxInternalNamespace:Object;
		private var _popInfoFieldQName:QName;
		private var _cache:Dictionary;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!isDisposed) {
				if (_popupManagerImpl != null) {
					IEventDispatcher(_popupManagerImpl).removeEventListener("addedPopUp", onAddPopUp);
				}
				if (_toolTipManagerImpl != null) {
					IEventDispatcher(_toolTipManagerImpl).removeEventListener("addChild", onAddChild);
				}
				_popups = null;
				_popupManagerImpl = null;
				_toolTipManagerImpl = null;
				_stageProcessorRegistry = null;
				logger.debug("Instance {0} has been disposed...", [this]);
			}
		}

		public function initializePopupsAndTooltips(stageProcessorRegistry:IStageObjectProcessorRegistry):Boolean {
			if (!Environment.isFlash) {
				_stageProcessorRegistry = stageProcessorRegistry;
				var singleton:Object = getDefinitionByName("mx.core.Singleton");
				if (singleton == null) {
					return false;
				}
				_popupManagerImpl = singleton.getInstance("mx.managers::IPopUpManager");
				if (_popupManagerImpl != null) {
					try {
						_mxInternalNamespace = getDefinitionByName("mx.core.mx_internal");
					} catch (e:Error) {
					}
					if (_mxInternalNamespace == null) {
						return false;
					}
					_popInfoFieldQName = new QName(_mxInternalNamespace, "popupInfo");
					IEventDispatcher(_popupManagerImpl).addEventListener("addedPopUp", onAddPopUp, false, 0, true);
					logger.debug("Added 'addedPopUp' listener to IPopUpManager instance");
				}
				_toolTipManagerImpl = singleton.getInstance("mx.managers::IToolTipManager2");
				if (_toolTipManagerImpl != null) {
					IEventDispatcher(_toolTipManagerImpl).addEventListener("addChild", onAddChild, false, 0, true);
					logger.debug("Added 'addChild' listener to IToolTipManager2 instance");
				}
				return true;
			} else {
				return false;
			}
		}

		private function onAddChild(event:Event):void {
			if (_toolTipManagerImpl.currentTarget != null) {
				var selectors:Dictionary = _stageProcessorRegistry.getAssociatedObjectSelectors(_toolTipManagerImpl.currentTarget);
				if (selectors != null) {
					logger.debug("Detected tooltip {0}", [_toolTipManagerImpl.currentTarget]);
					for (var selector:* in selectors) {
						_stageProcessorRegistry.approveDisplayObjectAfterAdding(_toolTipManagerImpl.currentTarget, IObjectSelector(selector), selectors[selector]);
					}
				}
			}
		}

		private function onAddPopUp(event:Event):void {
			if (WINDOW_NAME in event) {
				var window:Object = event[WINDOW_NAME];
				if (window) {
					activateWindow(event, window);
					wireWindow(window);
				}
			}
		}

		private static function activateWindow(event:Event, window:Object):void {
			if (SYSTEM_MANAGER_NAME in event) {
				var systemManager:Object = event[SYSTEM_MANAGER_NAME];
				if (systemManager) {
					var activeWindowManager:Object = systemManager.getImplementation("mx.managers::IActiveWindowManager");
					activeWindowManager.activate(window);
				}
			}
		}

		private function wireWindow(window:*):void {
			var popUpParent:DisplayObject = getPopUpParent(window);
			if (popUpParent) {
				_popups[window] = popUpParent;
				logger.debug("Detected popup {0}", [window]);
				wirePopup(popUpParent, window);
				IEventDispatcher(window).addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true, 0, true);
			}
		}

		private function getPopUpParent(window:*):DisplayObject {
			var result:DisplayObject;

			try {
				var infos:Array = _popupManagerImpl[_popInfoFieldQName];

				for each (var info:* in infos) {
					if (info.owner === window) {
						result = info.parent;
						break;
					}
				}
			} catch (e:Error) {
			}

			return result;
		}

		private function onAddedToStage(event:Event):void {
			var displayObject:DisplayObject = event.target as DisplayObject;
			var parent:DisplayObject = displayObject.parent;
			if (parent != null) {
				while ((_popups[parent] == null) && (parent.parent != null)) {
					parent = parent.parent;
				}
			}
			if ((parent != null) && (!(parent is Stage))) {
				wirePopup(_popups[parent], displayObject, false);
			}
		}

		private function wirePopup(popUpParent:DisplayObject, component:DisplayObject, recurse:Boolean=true):void {
			var selectors:Dictionary = _stageProcessorRegistry.getAssociatedObjectSelectors(popUpParent);
			if (selectors != null) {
				processDisplayObject(selectors, component, recurse);
			}
		}

		private function processDisplayObject(selectors:Dictionary, component:DisplayObject, recurse:Boolean=true):void {
			if (_cache[component] == null) {
				_cache[component] = true;
				for (var selector:* in selectors) {
					_stageProcessorRegistry.approveDisplayObjectAfterAdding(component, IObjectSelector(selector), selectors[selector]);
					if ((recurse == true) && (component is DisplayObjectContainer)) {
						var container:DisplayObjectContainer = component as DisplayObjectContainer;
						if (container != null) {
							for (var i:int = 0; i < container.numChildren; ++i) {
								processDisplayObject(selectors, container.getChildAt(i));
							}
						}
					}
				}
			}
		}


	}
}
