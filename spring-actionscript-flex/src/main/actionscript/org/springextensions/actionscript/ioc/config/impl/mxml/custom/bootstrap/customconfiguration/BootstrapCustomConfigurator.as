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
package org.springextensions.actionscript.ioc.config.impl.mxml.custom.bootstrap.customconfiguration {
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;

	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.modules.IModuleInfo;

	import org.as3commons.async.command.IApplicationBootstrapper;
	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.command.event.CompositeCommandEvent;
	import org.as3commons.async.command.impl.GenericOperationCommand;
	import org.as3commons.async.operation.impl.LoadModuleOperation;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.objectdefinition.ICustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.util.Environment;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class BootstrapCustomConfigurator implements ICustomConfigurator, IApplicationContextAware {
		private static const PERIOD:String = '.';
		private static var logger:ILogger = getClassLogger(BootstrapCustomConfigurator);

		/**
		 * Creates a new <code>BootstrapCustomConfigurator</code> instance.
		 */
		public function BootstrapCustomConfigurator() {
			super();
			_moduleData = {};
		}

		private var _applicationContext:IApplicationContext;

		private var _moduleData:Object;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		public function addModuleData(url:String, viewId:String, parentViewId:String):void {
			_moduleData[url] = {view: viewId, parent: parentViewId};
		}

		public function execute(instance:*, objectDefinition:IObjectDefinition):* {
			var bootstrap:IApplicationBootstrapper = instance;
			bootstrap.addEventListener(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, onCompositeCommandAfterExecuteCommand, false, 0, true);
		}

		public function getParentViewById(root:DisplayObjectContainer, parentId:String):UIComponent {
			var parts:Array = parentId.split(PERIOD);
			var id:String = parts.shift();
			var result:UIComponent;
			var len:int = (root is IVisualElementContainer) ? (root as IVisualElementContainer).numElements : root.numChildren;
			for (var i:int = 0; i < len; ++i) {
				var dp:UIComponent = (root is IVisualElementContainer) ? (root as IVisualElementContainer).getElementAt(int(i)) as UIComponent : root.getChildAt(int(i)) as UIComponent;
				if (dp.id == id) {
					result = dp;
					break;
				}
			}
			if (result == null) {
				logger.error("Could not resolve root view to add the module to. Id is: {0}", [parentId]);
				throw new IllegalOperationError("Could not resolve root view to add the module to. Id is: " + parentId);
			}
			if ((result != null) && (parts.length > 0)) {
				result = getParentViewById(result, parts.join(PERIOD));
			}
			return result;
		}

		public function getRootViewById(viewName:String, context:IApplicationContext):UIComponent {
			for each (var component:UIComponent in context.rootViews) {
				if (component.id == viewName) {
					return component;
				}
			}
			return Environment.getCurrentApplication() as UIComponent;
		}

		private function addToDisplayList(module:UIComponent, info:Object):void {
			var view:UIComponent;
			if (info.view == null) {
				if (_applicationContext.rootViews.length > 0) {
					view = _applicationContext.rootViews[0] as UIComponent;
				} else {
					view = Environment.getCurrentApplication() as UIComponent;
				}
			} else {
				view = getRootViewById(info.view, _applicationContext);
			}
			if (info.parent != null) {
				view = getParentViewById(view, info.parent);
			}
			if ((view is IVisualElement) && (module is IVisualElement)) {
				(view as IVisualElementContainer).addElement(module as IVisualElement);
			} else {
				view.addChild(module);
			}
		}

		private function onCompositeCommandAfterExecuteCommand(event:CompositeCommandEvent):void {
			if ((event.command is GenericOperationCommand) && ((event.command as GenericOperationCommand).operationClass === LoadModuleOperation)) {
				var moduleInfo:IModuleInfo = (event.command as IAsyncCommand).result;
				processModuleInfo(moduleInfo);
			}
		}

		private function processModuleInfo(moduleInfo:IModuleInfo):void {
			var module:UIComponent = moduleInfo.factory.create() as UIComponent;
			addToDisplayList(module, _moduleData[moduleInfo.url]);
		}
	}
}
