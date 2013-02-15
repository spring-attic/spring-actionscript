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
package org.springextensions.actionscript.ioc.autowire {

	import flash.system.ApplicationDomain;

	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.reflect.Field;
	import org.as3commons.reflect.Metadata;
	import org.springextensions.actionscript.ioc.AutowireMode;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;

	/**
	 * Extension of the <code>DefaultAutowireProcessor</code> that also allows object fields to be bound to
	 * other objects.
	 * <p>Use this annotation syntax to use field binding in your object:</p>
	 * <code>
	 * [Autowired(host="objectName","property.chain")]
	 * public var myProperty:String;
	 * </code>
	 * <p>Where the <code>objectName</code> key is an object name in the container.</p>
	 * <p>This autowire processor is created by default by the FlexXMLApplicationContext</p>
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.context.support.FlexXMLApplicationContext FlexXMLApplicationContext
	 * @sampleref stagewiring
	 * @docref container-documentation.html#binding_a_stage_component_to_a_property_of_an_object_in_the_container
	 */
	public class DefaultFlexAutowireProcessor extends DefaultAutowireProcessor {

		private static const LOGGER:ILogger = getLogger(DefaultFlexAutowireProcessor);

		/**
		 * Metadata argument key used for bindings, the value of this key determines the host object's property chain.
		 */
		public static const AUTOWIRED_PROPERTY_NAME:String = "property";

		/**
		 * Creates a new <code>DefaultFlexAutowireProcessor</code> instance.
		 */
		public function DefaultFlexAutowireProcessor(objectFactory:IObjectFactory) {
			super(objectFactory);
		}

		/**
		 * <p>Checks for the existence of a host and chain metadata argument key, if found the <code>bindField()</code> method is invoked.</p>
		 * @inheritDoc
		 */
		override protected function autoWireField(object:Object, field:Field, objectName:String):void {
			var fieldMetaData:Array = getAutowiredOrInjectMetadata(field);

			for each (var metadata:Metadata in fieldMetaData) {
				if (((metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_MODE) && metadata.getArgument(AUTOWIRED_ARGUMENT_MODE).value == AutowireMode.BYNAME.name)) || ((metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_NAME)) && (!metadata.hasArgumentWithKey(AUTOWIRED_PROPERTY_NAME)))) {
					autoWireFieldByName(object, field, metadata, objectName);
				} else if (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_EXTERNALPROPERTY)) {
					autoWireFieldByPropertyName(object, field, metadata, objectName);
				} else if (metadata.hasArgumentWithKey(AUTOWIRED_PROPERTY_NAME)) {
					bindField(object, field, metadata, objectName);
				} else {
					autoWireFieldByType(object, field, metadata, objectName);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function getApplicationDomain(object:Object):ApplicationDomain {
			if ((object is UIComponent) && UIComponent(object).moduleFactory) {
				var component:UIComponent = UIComponent(object);
				return component.moduleFactory.info().currentDomain as ApplicationDomain;
			}
			return super.getApplicationDomain(object);
		}

		/**
		 * Retrieves the values for the host and chain argument keys and uses these to create a binding
		 * between the host object and the specified object being autowired.
		 * @param object The object that is being autowired
		 * @param field The field that will receive the binding
		 * @param metadata The metadata describing the binding
		 * @param objectName The name of the object as known by the container
		 * @throws Error when binding fails
		 */
		protected function bindField(object:Object, field:Field, metadata:Metadata, objectName:String):void {
			//[Autowired(name="objecName",property="property.chain")]
			var host:String = (metadata.hasArgumentWithKey(AUTOWIRED_ARGUMENT_NAME)) ? metadata.getArgument(AUTOWIRED_ARGUMENT_NAME).value : field.name;
			var chain:Array = metadata.getArgument(AUTOWIRED_PROPERTY_NAME).value.split('.');
			try {
				BindingUtils.bindProperty(object, field.name, objectFactory.getObject(host), chain);
			} catch (e:Error) {
				throw new Error(StringUtil.substitute("Autowiring tried to bind field '{0}.{1}' with '{2}.{3}', but failed. Original exception was: {4}", objectName, field.name, host, chain.join('.'), e.message));
			}
			LOGGER.debug("Binding field '{0}.{1}' with '{2}.{3}'", [objectName, field.name, host, chain.join('.')]);
		}

	}
}
