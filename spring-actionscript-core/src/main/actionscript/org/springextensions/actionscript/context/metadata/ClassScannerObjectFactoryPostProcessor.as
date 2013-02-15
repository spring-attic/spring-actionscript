/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.context.metadata {
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeTypeCache;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.core.IOrdered;
	import org.springextensions.actionscript.ioc.factory.IApplicationDomainAware;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.utils.ApplicationUtils;
	import org.springextensions.actionscript.utils.OrderedUtils;

	/**
	 * Factory post processor that creates a lookup of metadata names and class names. It also acts as
	 * a registry for <code>IClassScanner</code> implementations that will be invoked for the metadata
	 * names that were extracted from the loaderInfo.
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @docref componentscan.html
	 * @sampleref movie-app-metadata
	 * @see org.springextensions.actionscript.context.metadata.IClassScanner IClassScanner
	 */
	public class ClassScannerObjectFactoryPostProcessor implements IObjectFactoryPostProcessor, IApplicationDomainAware, IOrdered {

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _objectFactory:IConfigurableListableObjectFactory;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>ClassScannerObjectFactoryPostProcessor</code>.
		 */
		public function ClassScannerObjectFactoryPostProcessor() {
			super();
			addScanner(new ComponentClassScanner());
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// order
		// ----------------------------

		private var _order:int = 0;

		public function get order():int {
			return _order;
		}

		public function set order(value:int):void {
			_order = value;
		}

		// ----------------------------
		// scanners
		// ----------------------------

		private var _scanners:Array = [];

		public function get scanners():Array {
			return _scanners;
		}

		public function set scanners(value:Array):void {
			_scanners = value;
		}

		// ----------------------------
		// applicationDomain
		// ----------------------------

		private var _applicationDomain:ApplicationDomain;

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function addScanner(scanner:IClassScanner):void {
			if (_scanners.indexOf(scanner) < 0) {
				_scanners[_scanners.length] = scanner;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			_objectFactory = objectFactory;
			registerClassScanners(objectFactory);
			doMetaDataScan();
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function registerClassScanners(objectFactory:IConfigurableListableObjectFactory):void {
			var scanners:Array = objectFactory.getObjectNamesForType(IClassScanner);
			for each (var scannerName:String in scanners) {
				addScanner(objectFactory.getObject(scannerName));
			}
		}

		protected function doMetaDataScan():void {
			var app:Object = ApplicationUtils.application;
			ByteCodeType.metaDataLookupFromLoader(app.systemManager.loaderInfo);
			doScans();
		}

		protected function doScans():void {
			var typeCache:ByteCodeTypeCache = (ByteCodeType.getTypeProvider().getTypeCache() as ByteCodeTypeCache);
			_scanners = OrderedUtils.sortOrderedArray(_scanners);
			for each (var scanner:IClassScanner in _scanners) {
				if (scanner is IApplicationDomainAware) {
					var aa:IApplicationDomainAware = IApplicationDomainAware(scanner);
					aa.applicationDomain = _applicationDomain;
				}
				if (scanner is IApplicationContextAware) {
					var aca:IApplicationContextAware = IApplicationContextAware(scanner);
					if (aca.applicationContext == null) {
						aca.applicationContext = _objectFactory as IApplicationContext;
					}
				}
				for each (var name:String in scanner.metaDataNames) {
					var classNames:Array = typeCache.getClassesWithMetaData(name);
					for each (var className:String in classNames) {
						scanner.scan(className);
					}
				}
			}
		}

	}
}