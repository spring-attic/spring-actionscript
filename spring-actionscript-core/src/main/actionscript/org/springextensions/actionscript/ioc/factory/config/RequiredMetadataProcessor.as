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
package org.springextensions.actionscript.ioc.factory.config {
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.factory.NoSuchObjectDefinitionError;
	import org.springextensions.actionscript.ioc.factory.support.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.metadata.AbstractMetadataProcessor;

	/**
	 * <code>IMetadataProcessor</code> implementation that enforces required properties to have been configured. A
	 * property is marked as required by adding [Required] metadata to the property definition:
	 * <listing version="3.0">
	 * [Required]
	 * public var myProperty:Type;
	 * </listing>
	 * <p />
	 * In order to add this post processor to you configuration add the following line to the xml:
	 * <p />
	 * <code>
	 * &lt;object class="org.springextensions.actionscript.ioc.factory.config.RequiredMetadataObjectPostProcessor" /&gt;
	 * </code>
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @docref container-documentation.html#enforcing_required_property_injections
	 */
	public class RequiredMetadataProcessor extends AbstractMetadataProcessor implements IObjectFactoryAware {

		private static const REQUIRED_METADATA_NAME:String = "Required";

		private var _objectFactory:IObjectFactory;
		private var _objectDefinitionRegistry:IObjectDefinitionRegistry;

		/**
		 * Constructs <code>RequiredMetadataObjectPostProcessor</code>
		 */
		public function RequiredMetadataProcessor() {
			super(true, [REQUIRED_METADATA_NAME]);
		}

		/**
		 * Will check the metadata of the given object to see if any property contains [Required] metadata.
		 * If it has this type of metadata and is not available in the object definition an error
		 * will be thrown.
		 *
		 * @param object    The object that has been instantiated
		 * @param objectName  The name of the object
		 *
		 * @throws org.springextensions.actionscript.errors.IllegalArgumentError    If the property was required but not defined.
		 * @inheritDoc
		 */
		override public function process(instance:Object, container:IMetaDataContainer, name:String, objectName:String):void {
			var field:Field = container as Field;
			if (field == null) {
				return;
			}

			var propertyDefinition:Object;
			if (_objectDefinitionRegistry) {
				try {
					var objectDefinition:IObjectDefinition = _objectDefinitionRegistry.getObjectDefinition(objectName);
					propertyDefinition = objectDefinition.properties[field.name];
					Assert.notNull(propertyDefinition, "Could not find property description of '" + field.name + "' in description of '" + objectName + "', the class '" + field.declaringType.fullName + "' has it marked as required.");
				} catch (e:NoSuchObjectDefinitionError) {
					// fail silently, we are probably here because of a view component not having an explicit definition
				}
			}
		}

		/**
		 * This method has not been implemented
		 * @inheritDoc
		 */
		public function postProcessAfterInitialization(object:*, objectName:String):* {
			return object;
		}

		/**
		 * @inheritDoc
		 */
		public function set objectFactory(objectFactory:IObjectFactory):void {
			_objectFactory = objectFactory;
			_objectDefinitionRegistry = (_objectFactory as IObjectDefinitionRegistry);
		}
	}
}
