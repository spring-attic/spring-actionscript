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
package org.springextensions.actionscript.ioc.factory.metadata {
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.Method;
	import org.springextensions.actionscript.ioc.factory.config.IDestructionAwareObjectPostProcessor;
	import org.springextensions.actionscript.metadata.AbstractMetadataProcessor;

	/**
	 * Metadata processor that processes [PostConstruct] and [PreDestroy] metadata on methods.
	 *
	 * <p>Methods annotated with the [PostConstruct] metadata are invoked in the postProcessAfterInitialization method.
	 * This is after the invocation of the IInitializingObject.afterPropertiesSet() method and after the init method
	 * specified on the object definition.</p>
	 *
	 * <p>Methods annotated with the [PreDestroy] metadata are invoked in the postProcessBeforeDestruction method. This
	 * is after the destroy method specified in the object definition and before the invocation of the dispose method
	 * in case the object implements IDisposable.</p>
	 *
	 * <p>Methods can have multiple [PostConstruct] and/or [PreDestroy] annotations, in which case they will be
	 * invoked for each annotation.</p>
	 *
	 * @author Christophe Herreman
	 */
	public class InitDestroyMetadataProcessor extends AbstractMetadataProcessor implements IDestructionAwareObjectPostProcessor {

		// --------------------------------------------------------------------
		//
		// Public Static Constants
		//
		// --------------------------------------------------------------------

		public static const POST_CONSTRUCT_METADATA_NAME:String = "PostConstruct";

		public static const PRE_DESTROY_METADATA_NAME:String = "PreDestroy";

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static const logger:ILogger = LoggerFactory.getClassLogger(InitDestroyMetadataProcessor);

		// --------------------------------------------------------------------
		//
		// Private Variables
		//
		// --------------------------------------------------------------------

		private var _processedClasses:Array = [];

		private var _initMethods:InitDestroyMethodDictionary = new InitDestroyMethodDictionary();

		private var _destroyMethods:InitDestroyMethodDictionary = new InitDestroyMethodDictionary();

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function InitDestroyMetadataProcessor() {
			super(true, [POST_CONSTRUCT_METADATA_NAME, PRE_DESTROY_METADATA_NAME])
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		override public function process(instance:Object, container:IMetaDataContainer, metadataKey:String, objectName:String):void {
			if (!objectClassIsProcessed(instance)) {
				if (container is Method) {
					var method:Method = Method(container);
					var clazz:Class = method.declaringType.clazz;

					switch (metadataKey) {
						case POST_CONSTRUCT_METADATA_NAME:
							addInitMethod(clazz, method);
							logger.debug("Found init method '{0}' on class '{1}'", method.name, clazz);
							break;

						case PRE_DESTROY_METADATA_NAME:
							addDestroyMethod(clazz, method);
							logger.debug("Found destroy method '{0}' on class '{1}'", method.name, clazz);
							break;
					}

				}
			}
		}

		public function postProcessBeforeInitialization(object:*, objectName:String):* {
			return object;
		}

		public function postProcessAfterInitialization(object:*, objectName:String):* {
			markObjectClassAsProcessed(object);
			invokeInitMethods(object, objectName);
			return object;
		}

		public function postProcessBeforeDestruction(object:Object, objectName:String):void {
			invokeDestroyMethods(object, objectName);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function markObjectClassAsProcessed(object:Object):void {
			var clazz:Class = ClassUtils.forInstance(object);
			_processedClasses.push(clazz);
		}

		private function objectClassIsProcessed(object:Object):Boolean {
			var clazz:Class = ClassUtils.forInstance(object);
			return (_processedClasses.indexOf(clazz) > -1);
		}

		private function addInitMethod(clazz:Class, method:Method):void {
			_initMethods.addMethod(clazz, method);
		}

		private function addDestroyMethod(clazz:Class, method:Method):void {
			_destroyMethods.addMethod(clazz, method);
		}

		private function invokeInitMethods(object:*, objectName:String):void {
			var clazz:Class = ClassUtils.forInstance(object);
			var initMethods:Array = _initMethods.getMethods(clazz);

			for each (var initMethod:Method in initMethods) {
				logger.debug("Invoking init method '0' on object '{1}'", initMethod.name, objectName);
				initMethod.invoke(object, []);
			}
		}

		private function invokeDestroyMethods(object:*, objectName:String):void {
			var clazz:Class = ClassUtils.forInstance(object);
			var destroyMethods:Array = _destroyMethods.getMethods(clazz);

			for each (var destroyMethod:Method in destroyMethods) {
				logger.debug("Invoking destroy method '0' on object '{1}'", destroyMethod.name, objectName);
				destroyMethod.invoke(object, []);
			}
		}

	}
}