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
package org.springextensions.actionscript.ioc.factory.process.impl.factory {
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.as3commons.bytecode.reflect.ByteCodeTypeCache;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.IOrdered;
	import org.as3commons.lang.util.OrderedUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.config.impl.metadata.ILoaderInfoAware;
	import org.springextensions.actionscript.ioc.config.impl.metadata.WaitingOperation;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.metadata.IClassScanner;
	import org.springextensions.actionscript.util.ContextUtils;
	import org.springextensions.actionscript.util.Environment;

	/**
	 * Factory post processor that creates a lookup of metadata names and class names. It also acts as
	 * a registry for <code>IClassScanner</code> implementations that will be invoked for the metadata
	 * names that were extracted from the loaderInfo.
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ClassScannerObjectFactoryPostProcessor implements IObjectFactoryPostProcessor, IApplicationDomainAware, IOrdered, IDisposable {

		private static var logger:ILogger = getClassLogger(ClassScannerObjectFactoryPostProcessor);

		/**
		 * Creates a new <code>ClassScannerObjectFactoryPostProcessor</code>.
		 */
		public function ClassScannerObjectFactoryPostProcessor() {
			super();
		}

		private var _applicationDomain:ApplicationDomain;
		private var _isDisposed:Boolean;
		private var _objectFactory:IObjectFactory;
		private var _order:int = 0;
		private var _scanners:Vector.<IClassScanner>;
		private var _timeOutToken:uint = 0;
		private var _waitingOperation:WaitingOperation;

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 *
		 */
		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 *
		 */
		public function get order():int {
			return _order;
		}

		/**
		 * @private
		 */
		public function set order(value:int):void {
			_order = value;
		}

		/**
		 *
		 */
		public function get scanners():Vector.<IClassScanner> {
			return _scanners;
		}

		/**
		 * @private
		 */
		public function set scanners(value:Vector.<IClassScanner>):void {
			_scanners = value;
		}

		/**
		 *
		 * @param scanner
		 */
		public function addScanner(scanner:IClassScanner):void {
			_scanners ||= new Vector.<IClassScanner>();
			if (_scanners.indexOf(scanner) < 0) {
				logger.debug("Added class scanner {0}", [scanner]);
				_scanners[_scanners.length] = scanner;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			if (!_isDisposed) {
				_isDisposed = true;
				_applicationDomain = null;
				for each (var scanner:IClassScanner in _scanners) {
					ContextUtils.disposeInstance(scanner);
				}
				_scanners = null;
				if (_timeOutToken > 0) {
					clearTimeout(_timeOutToken);
				}
				ContextUtils.disposeInstance(_waitingOperation);
				_waitingOperation = null;
				_objectFactory = null;
				logger.debug("Instance {0} has been disposed...", [this]);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			_objectFactory = objectFactory;
			registerClassScanners(objectFactory);
			var operation:IOperation;
			if ((_scanners != null) && (_scanners.length > 0)) {
				var loaderInfo:LoaderInfo = (objectFactory as ILoaderInfoAware) ? ILoaderInfoAware(objectFactory).loaderInfo : null;
				operation = doMetaDataScan(loaderInfo);
			}
			return operation;
		}

		/**
		 *
		 * @param objectFactory
		 */
		public function registerClassScanners(objectFactory:IObjectFactory):void {
			var scanners:Vector.<String> = objectFactory.objectDefinitionRegistry.getObjectDefinitionNamesForType(IClassScanner);
			for each (var scannerName:String in scanners) {
				addScanner(objectFactory.getObject(scannerName));
				logger.debug("Registered class scanner with name {0}", [scannerName]);
			}
		}

		/**
		 *
		 * @param loaderInfo
		 * @return
		 */
		public function doMetaDataScan(loaderInfo:LoaderInfo):IOperation {
			if (loaderInfo != null) {
				ByteCodeType.metaDataLookupFromLoader(loaderInfo);
				var typeCache:ByteCodeTypeCache = (ByteCodeType.getTypeProvider().getTypeCache() as ByteCodeTypeCache);
				registerClassScannersFromInterfaceLookup(typeCache, _objectFactory);
				doScans(typeCache);
				if (_waitingOperation != null) {
					_waitingOperation.dispatchCompleteEvent();
				}
				return null;
			} else if (!Environment.isFlash) {
				return waitForStage();
			} else {
				throw new IllegalOperationError("loaderInfo instance must not be null");
			}
		}

		public function registerClassScannersFromInterfaceLookup(cache:ByteCodeTypeCache, objectFactory:IObjectFactory):void {
			var interfaceName:String = ClassUtils.getFullyQualifiedName(IClassScanner, true);
			var classNames:Array = cache.interfaceLookup[interfaceName];
			for each (var className:String in classNames) {
				var type:Type = Type.forName(className, objectFactory.applicationDomain);
				if (type.constructor.parameters.length == 0) {
					try {
						var scanner:IClassScanner = objectFactory.createInstance(type.clazz);
						addScanner(scanner);
						logger.debug("Found and created IClassScanner implementation: {0}", [type.clazz]);
					} catch (e:Error) {
					}
				}
			}
		}

		/**
		 *
		 * @param typeCache
		 */
		public function doScans(typeCache:ByteCodeTypeCache):void {
			_scanners = _scanners.sort(OrderedUtils.orderedCompareFunction);
			for each (var scanner:IClassScanner in _scanners) {
				doScan(scanner, typeCache);
			}
		}

		/**
		 *
		 * @param scanner
		 * @param typeCache
		 */
		public function doScan(scanner:IClassScanner, typeCache:ByteCodeTypeCache):void {
			if (scanner is IApplicationDomainAware) {
				IApplicationDomainAware(scanner).applicationDomain = _applicationDomain;
			}
			if (scanner is IApplicationContextAware) {
				IApplicationContextAware(scanner).applicationContext = _objectFactory as IApplicationContext;
			}
			for each (var name:String in scanner.metadataNames) {
				var classNames:Array = typeCache.getClassesWithMetadata(name);
				for each (var className:String in classNames) {
					logger.debug("Scanning class {0} with metadata: {1}", [className, name]);
					var type:Type = Type.forName(className, _applicationDomain);
					scanner.process(className, name, [type]);
				}
			}
		}

		/**
		 *
		 */
		protected function setStageTimer():void {
			if (_timeOutToken < 1) {
				_timeOutToken = setTimeout(function():void {
					clearTimeout(_timeOutToken);
					_timeOutToken = 0;
					var stage:Stage = Environment.getCurrentStage();
					if (stage == null) {
						setStageTimer();
					} else {
						logger.debug("Flash stage detected, starting scans...");
						doMetaDataScan(stage.loaderInfo);
					}
				}, 500);
			}
		}

		/**
		 *
		 * @return
		 */
		protected function waitForStage():IOperation {
			_waitingOperation = new WaitingOperation();
			setStageTimer();
			return _waitingOperation;
		}
	}
}
