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
	import org.as3commons.async.command.impl.DefaultApplicationBootstrapper;
	import org.as3commons.lang.ClassUtils;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.AbstractCustomObjectDefinitionComponent;
	import org.springextensions.actionscript.ioc.config.impl.mxml.custom.bootstrap.customconfiguration.BootstrapCustomConfigurator;
	import org.springextensions.actionscript.ioc.objectdefinition.ChildContextObjectDefinitionAccess;
	import org.springextensions.actionscript.ioc.objectdefinition.IBaseObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;
	import org.springextensions.actionscript.ioc.objectdefinition.impl.ObjectDefinitionBuilder;

	[DefaultProperty("childContent")]
	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class Bootstrap extends AbstractCustomObjectDefinitionComponent {

		/**
		 * Creates a new <code>Bootstrap</code> instance.
		 */
		public function Bootstrap() {
			super();
		}

		private var _childContent:Array;

		public function get childContent():Array {
			return _childContent;
		}

		public function set childContent(value:Array):void {
			_childContent = value;
		}

		public override function execute(applicationContext:IApplicationContext, objectDefinitions:Object, defaultDefinition:IBaseObjectDefinition=null, parentDefinition:IObjectDefinition=null, parentId:String=null):void {
			var builder:ObjectDefinitionBuilder = ObjectDefinitionBuilder.objectDefinitionForClass(DefaultApplicationBootstrapper);
			var customConfigurator:BootstrapCustomConfigurator = new BootstrapCustomConfigurator();
			builder.objectDefinition.customConfiguration = customConfigurator;
			builder.objectDefinition.childContextAccess = ChildContextObjectDefinitionAccess.NONE;
			objectDefinitions[id] = builder.objectDefinition;
			addModules(builder, applicationContext);
			builder.addMethodInvocation("load");
		}

		private function addModule(module:Module, builder:ObjectDefinitionBuilder, applicationContext:IApplicationContext):void {
			BootstrapCustomConfigurator(builder.objectDefinition.customConfiguration).addModuleData(module.url, module.rootViewId, module.parentContainerId);
			if (module.applicationDomain == null) {
				module.applicationDomain = applicationContext.applicationDomain;
			}
			builder.addMethodInvocation("addModule", [module.url, module.applicationDomain, module.securityDomain, module.flexModuleFactory]);
		}

		private function addModules(builder:ObjectDefinitionBuilder, applicationContext:IApplicationContext):void {
			for each (var obj:* in _childContent) {
				if (obj is Module) {
					addModule(obj, builder, applicationContext);
				} else if (obj is StyleModule) {
					addStyleModule(obj, builder, applicationContext);
				} else if (obj is ResourceBundle) {
					addResourceBundle(obj, builder);
				} else if (obj is ResourceModule) {
					addResourceModule(obj, builder, applicationContext);
				} else {
					throw new Error("Illegal child object for Bootstrap: " + ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(obj)));
				}
			}
		}

		private function addResourceBundle(resourceBundle:ResourceBundle, builder:ObjectDefinitionBuilder):void {
			builder.addMethodInvocation("addResourceBundle", [resourceBundle.url, resourceBundle.name, resourceBundle.locale]);
		}

		private function addResourceModule(resourceModule:ResourceModule, builder:ObjectDefinitionBuilder, applicationContext:IApplicationContext):void {
			if (resourceModule.applicationDomain == null) {
				resourceModule.applicationDomain = applicationContext.applicationDomain;
			}
			builder.addMethodInvocation("addResourceModule", [resourceModule.url, resourceModule.update, resourceModule.applicationDomain, resourceModule.securityDomain]);
		}

		private function addStyleModule(styleModule:StyleModule, builder:ObjectDefinitionBuilder, applicationContext:IApplicationContext):void {
			if (styleModule.applicationDomain == null) {
				styleModule.applicationDomain = applicationContext.applicationDomain;
			}
			builder.addMethodInvocation("addStyleModule", [styleModule.url, styleModule.update, styleModule.applicationDomain, styleModule.securityDomain, styleModule.flexModuleFactory]);
		}
	}
}
