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
package org.springextensions.actionscript.context.impl.mxml {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import mx.binding.utils.BindingUtils;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;

	import org.springextensions.actionscript.context.ContextShareSettings;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.config.IConfigurationPackage;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.context.impl.mxml.event.MXMLContextEvent;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.module.ModulePolicy;
	import org.springextensions.actionscript.util.ContextUtils;
	import org.springextensions.actionscript.context.IMXMLApplicationContext;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MXMLApplicationContextBase extends DefaultApplicationContext implements IMXMLObject, IMXMLApplicationContext {

		public static const AUTOADDCHILDREN_CHANGED_EVENT:String = "autoAddChildrenChanged";
		public static const AUTOLOAD_CHANGED_EVENT:String = "autoLoadChanged";
		public static const CONFIGURATIONPACKAGE_CHANGED_EVENT:String = "configurationPackageChanged";
		public static const DEFAULTSHARESETTINGS_CHANGED_EVENT:String = "defaultShareSettingsChanged";
		public static const MODULEPOLICY_CHANGED_EVENT:String = "modulePolicyChanged";
		public static var sharedContextDispatcher:IEventDispatcher = new EventDispatcher();

		{
			BindingUtils;
			PopUpManager;
		}

		/**
		 * Creates a new <code>MXMLApplicationContextBase</code> instance.
		 */
		public function MXMLApplicationContextBase(parent:IApplicationContext=null, rootViews:Vector.<DisplayObject>=null, objFactory:IObjectFactory=null) {
			_modulePolicy = ModulePolicy.AUTOWIRE;
			super(parent, rootViews, objFactory);
		}

		private var _autoAddChildren:Boolean = true;
		private var _autoLoad:Boolean = true;
		private var _configurationPackage:IConfigurationPackage;
		private var _defaultShareSettings:ContextShareSettings;
		private var _document:Object;
		private var _id:String;
		private var _isDisposed:Boolean;
		private var _modulePolicy:ModulePolicy;
		protected var contextInitialized:Boolean;

		[Bindable(event="modulePolicyChanged")]
		public function get modulePolicy():ModulePolicy {
			return _modulePolicy;
		}

		public function set modulePolicy(value:ModulePolicy):void {
			if ((value != null) && (_modulePolicy !== value)) {
				_modulePolicy = value;
				dispatchEvent(new Event(MODULEPOLICY_CHANGED_EVENT));
			}
		}

		[Bindable(event="autoAddChildrenChanged")]
		public function get autoAddChildren():Boolean {
			return _autoAddChildren;
		}

		public function set autoAddChildren(value:Boolean):void {
			if (_autoAddChildren != value) {
				_autoAddChildren = value;
				dispatchEvent(new Event(AUTOADDCHILDREN_CHANGED_EVENT));
			}
		}

		[Bindable(event="autoLoadChanged")]
		public function get autoLoad():Boolean {
			return _autoLoad;
		}

		public function set autoLoad(value:Boolean):void {
			if (_autoLoad != value) {
				_autoLoad = value;
				dispatchEvent(new Event(AUTOLOAD_CHANGED_EVENT));
			}
		}

		[Bindable(event="configurationPackageChanged")]
		public function get configurationPackage():IConfigurationPackage {
			return _configurationPackage;
		}

		public function set configurationPackage(value:IConfigurationPackage):void {
			if (_configurationPackage !== value) {
				_configurationPackage = value;
				dispatchEvent(new Event(CONFIGURATIONPACKAGE_CHANGED_EVENT));
			}
		}

		[Bindable(event="defaultShareSettingsChanged")]
		public function get defaultShareSettings():ContextShareSettings {
			return _defaultShareSettings;
		}

		public function set defaultShareSettings(value:ContextShareSettings):void {
			if (_defaultShareSettings !== value) {
				_defaultShareSettings = value;
				dispatchEvent(new Event(DEFAULTSHARESETTINGS_CHANGED_EVENT));
			}
		}

		public function initializeContext():void {
			if (!contextInitialized) {
				var rootView:DisplayObject = _document as DisplayObject;
				addRootView(rootView);
				if (_configurationPackage != null) {
					configure(_configurationPackage);
				}
				ContextUtils.disposeInstance(_configurationPackage);
				_configurationPackage = null;
				contextInitialized = true;
				sharedContextDispatcher.dispatchEvent(new MXMLContextEvent(MXMLContextEvent.CREATED, this));
			}
		}

		public function initialized(document:Object, id:String):void {
			_document = document;
			_id = id;
			initializeContext();
			if (_document is IEventDispatcher) {
				IEventDispatcher(_document).addEventListener(FlexEvent.CREATION_COMPLETE, onComplete);
			}
		}

		/**
		 *
		 */
		override public function load():void {
			initializeContext();
			super.load();
		}

		private function loadContext():void {
			if (_document.hasOwnProperty("systemManager")) {
				var sm:SystemManager = _document["systemManager"];
				if (sm.isTopLevelRoot()) {
					sharedContextDispatcher.addEventListener(MXMLContextEvent.CREATED, onChildContextCreated);
				}
			}
			if (_autoLoad) {
				load();
			}
		}

		/**
		 *
		 * @param event
		 */
		private function onComplete(event:FlexEvent):void {
			IEventDispatcher(_document).removeEventListener(FlexEvent.CREATION_COMPLETE, onComplete);
			loadContext();
		}

		private function onChildContextCreated(event:MXMLContextEvent):void {
			if (_autoAddChildren) {
				addChildContext(event.applicationContext, _defaultShareSettings);
			}
		}
	}
}
