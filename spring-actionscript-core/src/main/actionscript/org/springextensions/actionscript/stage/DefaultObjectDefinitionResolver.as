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
package org.springextensions.actionscript.stage {

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.ObjectDefinitionScope;
	import org.springextensions.actionscript.utils.ObjectUtils;

	/**
	 * Default <code>IObjectDefinitionResolver</code> used for wiring.
	 *
	 * <p>
	 * Attempt to resolve an IObjectDefinition for the passed object:
	 * 	<ol>
	 * 		<li>Name lookup. Uses <code>objectIdProperty</code> as the object property name
	 * 			to be used to match an object definition (default: <code>"name"</code>).</li>
	 * 		<li>Type lookup. Used if the preceding hasn't find a matching object definition.
	 * 			Will try to find an object definition with the same type of the object (it will
	 *          assign the object definition only if a single matching object definition is found).</li>
	 * 		<li>Default object definition. Just assign a default object definition having the
	 *          object complete class name as id and marked as prototype.</li>
	 * 	</ol>
	 * </p>
	 *
	 * @author Martino Piccinato
	 *
	 * @see org.springextensions.actionscript.context.support.FlexXMLApplicationContext
	 * @see FlexStageObjectSelectorFactoryPostProcessor
	 * @sampleref stagewiring
	 * @docref container-documentation.html#how_to_determine_which_objectdefinition_to_use_for_which_stage_component
	 */
	public class DefaultObjectDefinitionResolver implements IObjectDefinitionResolver, IApplicationContextAware {

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var logger:ILogger = getLogger(DefaultObjectDefinitionResolver);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function DefaultObjectDefinitionResolver(applicationContext:IApplicationContext = null) {
			super();
			_applicationContext = applicationContext;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// applicationContext
		// ----------------------------

		private var _applicationContext:IApplicationContext;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		// ----------------------------
		// objectIdProperty
		// ----------------------------

		private var _objectIdProperty:String = "name";

		/**
		 * @param value The name of the property to be used for lookup by name
		 * @default <code>"name"</code>
		 */
		public function set objectIdProperty(value:String):void {
			_objectIdProperty = value;
		}

		// ----------------------------
		// lookupByType
		// ----------------------------

		private var _lookupByType:Boolean = true;

		/**
		 * @param value <code>true</code> if the resolver has to look up possible
		 * matching <code>IObjectDefinition</code> by type, <code>false</code> otherwise.
		 * @default <code>true</code>
		 */
		public function set lookupByType(value:Boolean):void {
			_lookupByType = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function resolveObjectDefinition(object:*):IObjectDefinition {
			var objectDefinition:IObjectDefinition = null;

			if (_objectIdProperty) {
				objectDefinition = getObjectDefinitionByName(object);
			}

			if (!objectDefinition && _lookupByType) {
				objectDefinition = getObjectDefinitionByType(object);
			}

			return objectDefinition;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function getObjectDefinitionByName(object:*):IObjectDefinition {
			if (_applicationContext) {
				if (_objectIdProperty.length > 0 && object[_objectIdProperty] && _applicationContext.containsObject(object[_objectIdProperty])) {
					logger.debug("Retrieved by name IObjectDefinition {0} for object {1}", [object[_objectIdProperty], object]);
					return _applicationContext.getObjectDefinition(object[_objectIdProperty]);
				}
			}

			return null;
		}

		private function getObjectDefinitionByType(object:*):IObjectDefinition {
			var objectDefinition:IObjectDefinition = null;
			var cls:Class = ObjectUtils.getClass(object);
			var objectDefinitionNames:Array = _applicationContext.getObjectNamesForType(cls);
			var prototypeObjectDefinitionNames:Array = [];

			for (var i:int = 0; i < objectDefinitionNames.length; i++) {
				if (_applicationContext.getObjectDefinition(objectDefinitionNames[i]).scope == ObjectDefinitionScope.PROTOTYPE) {
					prototypeObjectDefinitionNames.push(objectDefinitionNames[i]);
				}
			}

			if (prototypeObjectDefinitionNames.length == 0) {
				//logger.debug("Can't find a prototype scoped IObjectDefinition whose type" + " match the object type for {0}", object);
			} else if (prototypeObjectDefinitionNames.length == 1) {
				//logger.debug("Found a prototype scoped IObjectDefinition whose type" + " match the object type for {0}, using this as object definition", object);
				objectDefinition = _applicationContext.getObjectDefinition(prototypeObjectDefinitionNames.pop());
			} else {
				//logger.debug("Found {0} prototype scoped IObjectDefinition matching" + " the object type, can't decide which one to use (object: {1})", prototypeObjectDefinitionNames.length, object);
			}

			return objectDefinition;
		}

	}
}
