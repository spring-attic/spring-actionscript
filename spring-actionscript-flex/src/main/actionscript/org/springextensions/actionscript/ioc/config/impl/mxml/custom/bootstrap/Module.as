/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.bootstrap {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;

	import mx.core.IContainer;
	import mx.core.IFlexModuleFactory;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class Module extends BootstrapModuleBase {

		public static const PARENTCONTAINERID_CHANGED_EVENT:String = "parentContainerIdChanged";
		public static const ROOTVIEWID_CHANGED_EVENT:String = "rootViewIdChanged";
		public static const FLEXMODULEFACTORY_CHANGED_EVENT:String = "flexModuleFactoryChanged";

		/**
		 * Creates a new <code>Module</code> instance.
		 */
		public function Module() {
			super();
		}

		private var _moduleURL:String;
		private var _parentContainerId:String;
		private var _rootViewId:String;
		private var _flexModuleFactory:IFlexModuleFactory;

		[Bindable(event="rootViewIdChanged")]
		public function get rootViewId():String {
			return _rootViewId;
		}

		public function set rootViewId(value:String):void {
			if (_rootViewId != value) {
				_rootViewId = value;
				dispatchEvent(new Event(ROOTVIEWID_CHANGED_EVENT));
			}
		}

		[Bindable(event="parentContainerIdChanged")]
		public function get parentContainerId():String {
			return _parentContainerId;
		}

		public function set parentContainerId(value:String):void {
			if (_parentContainerId != value) {
				_parentContainerId = value;
				dispatchEvent(new Event(PARENTCONTAINERID_CHANGED_EVENT));
			}
		}

		public function get flexModuleFactory():IFlexModuleFactory {
			return _flexModuleFactory;
		}

		public function set flexModuleFactory(value:IFlexModuleFactory):void {
			if (_flexModuleFactory !== value) {
				_flexModuleFactory = value;
				dispatchEvent(new Event(FLEXMODULEFACTORY_CHANGED_EVENT));
			}
		}

	}
}
