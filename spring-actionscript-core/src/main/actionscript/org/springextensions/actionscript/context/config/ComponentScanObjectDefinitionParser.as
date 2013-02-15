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
package org.springextensions.actionscript.context.config {
	import flash.display.LoaderInfo;

	import mx.managers.SystemManager;
	import mx.modules.Module;

	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeTypeCache;
	import org.as3commons.lang.StringUtils;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.metadata.ComponentClassScanner;
	import org.springextensions.actionscript.context.metadata.IClassScanner;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.xml.IObjectDefinitionParser;
	import org.springextensions.actionscript.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.springextensions.actionscript.utils.ApplicationUtils;
	import org.springextensions.actionscript.utils.ClassNameUtils;

	/**
	 * Parser for the context:component-scan element.
	 *
	 * @author Christophe Herreman
	 */
	public class ComponentScanObjectDefinitionParser implements IObjectDefinitionParser {

		// --------------------------------------------------------------------
		//
		// Public Static Constants
		//
		// --------------------------------------------------------------------

		public static const BASE_PACKAGE_ATTRIBUTE:String = "base-package";
		public static const OWNER_MODULE_PROPERTY_NAME:String = "ownerModule";

		// -------------------------------------------------------------
		//
		// Constructor
		//
		// -------------------------------------------------------------

		public function ComponentScanObjectDefinitionParser() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function parse(node:XML, xmlParser:XMLObjectDefinitionsParser):IObjectDefinition {
			var scanner:IClassScanner = createScanner(xmlParser);

			doBytecodeReflection(xmlParser.applicationContext);
			scanPackages(scanner, getBasePackages(node));

			return null;
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function createScanner(xmlParser:XMLObjectDefinitionsParser):IClassScanner {
			var result:ComponentClassScanner = new ComponentClassScanner();
			result.applicationContext = xmlParser.applicationContext;
			return result;
		}

		protected function getBasePackages(node:XML):Array {
			var result:Array = [];
			var basePackageAttributes:XMLList = node.attribute(BASE_PACKAGE_ATTRIBUTE);

			if (basePackageAttributes.length() > 0) {
				var basePackageValue:String = basePackageAttributes[0].toString();
				var basePackagesRaw:Array = basePackageValue.split(",");

				for each (var basePackageRaw:String in basePackagesRaw) {
					result.push(StringUtils.trim(basePackageRaw));
				}
			}

			return result;
		}

		protected function doBytecodeReflection(applicationContext:IApplicationContext):void {
			var loaderInfo:LoaderInfo;
			if (Object(applicationContext).hasOwnProperty(OWNER_MODULE_PROPERTY_NAME) && (Object(applicationContext)[OWNER_MODULE_PROPERTY_NAME] != null)) {
				loaderInfo = Object(applicationContext)[OWNER_MODULE_PROPERTY_NAME].loaderInfo;
			} else {
				var app:Object = ApplicationUtils.application;
				loaderInfo = app.systemManager.loaderInfo
			}
			ByteCodeType.metaDataLookupFromLoader(loaderInfo);
		}

		protected function scanPackages(scanner:IClassScanner, basePackages:Array):void {
			var typeCache:ByteCodeTypeCache = ByteCodeTypeCache(ByteCodeType.getTypeProvider().getTypeCache());
			var classNames:Array = typeCache.getClassesWithMetadata(ComponentClassScanner.COMPONENT_METADATA);
			var classNamesThatMatchBasePackages:Array = ClassNameUtils.getClassNamesThatMatchBasePackages(classNames, basePackages);

			scanner.scanClassNames(classNamesThatMatchBasePackages);
		}


	}
}