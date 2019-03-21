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

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.mxml.MXMLApplicationContext;
	import org.springextensions.actionscript.context.impl.mxml.MXMLApplicationContextBase;
	import org.springextensions.actionscript.module.ModulePolicy;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultFlexAutowiringStageProcessor extends DefaultAutowiringStageProcessor {

		private static const logger:ILogger = getClassLogger(DefaultFlexAutowiringStageProcessor);

		private var _policy:ModulePolicy;
		private var _moduleClass:Class;

		/**
		 * Creates a new <code>DefaultFlexAutowiringStageProcessor</code> instance.
		 */
		public function DefaultFlexAutowiringStageProcessor() {
			super();
		}

		protected function get moduleClass():Class {
			if (_moduleClass == null) {
				try {
					_moduleClass = applicationContext.applicationDomain.getDefinition("mx.modules.IModule") as Class;
				} catch (e:Error) {
				}
				if (_moduleClass == null) {
					try {
						_moduleClass = applicationContext.applicationDomain.getDefinition("mx.modules.Module") as Class;
					} catch (e:Error) {
					}
				}
				logger.debug("Determined that module class to check for is {0}", [_moduleClass]);
			}
			return _moduleClass;
		}

		protected function set moduleClass(value:Class):void {
			_moduleClass = value;
		}

		override public function process(displayObject:DisplayObject):DisplayObject {
			if ((moduleClass != null) && (displayObject is moduleClass)) {
				if (!componentCache[displayObject]) {
					var modulePolicy:ModulePolicy = getPolicy(applicationContext);
					if ((modulePolicy === ModulePolicy.AUTOWIRE) || (applicationContext.rootViews.indexOf(displayObject) > -1)) {
						logger.debug("Encountered a module on stage, autowiring it");
						return super.process(displayObject);
					} else {
						applicationContext.stageProcessorRegistry.registerStageObjectProcessor(this, new IgnoreModuleObjectSelector(), displayObject);
						logger.debug("Encountered a module on stage, ignoring it");
						return displayObject;
					}
				} else {
					return displayObject;
				}
			}
			return super.process(displayObject);
		}

		protected function getPolicy(applicationContext:IApplicationContext):ModulePolicy {
			if (_policy == null) {
				if (applicationContext is MXMLApplicationContextBase) {
					_policy = (applicationContext as MXMLApplicationContextBase).modulePolicy;
				} else {
					_policy = ModulePolicy.AUTOWIRE;
				}
			}
			return _policy;
		}
	}
}
