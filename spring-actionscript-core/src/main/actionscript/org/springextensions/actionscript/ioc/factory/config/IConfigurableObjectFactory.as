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

	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.objects.IPropertyEditor;
	import org.springextensions.actionscript.objects.ITypeConverter;

	/**
	 * Defines the methods for configuring object factories.
	 *
	 * @author Christophe Herreman
	 */
	public interface IConfigurableObjectFactory extends IObjectFactory {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * Object post processors to apply when creating objects
		 */
		function get objectPostProcessors():Array;
		
		/**
		 * The current type converter implementation
		 *
		 * @default an instance of SimpleTypeConverter
		 *
		 * @see org.springextensions.actionscript.objects.SimpleTypeConverter SimpleTypeConverter
		 */
		function get typeConverter():ITypeConverter;

		/**
		 * @private
		 */
		function set typeConverter(value:ITypeConverter):void;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds the specified <code>IObjectPostProcessor</code> to the current object factory.
		 *
		 * @param objectPostProcessor   the object postprocessor to add
		 */
		function addObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void;

		/**
		 * Removes the specified <code>IObjectPostProcessor</code> from the current object factory.
		 *
		 * @param objectPostProcessor   the object postprocessor to add
		 */
		function removeObjectPostProcessor(objectPostProcessor:IObjectPostProcessor):void;
		
		/**
		 * Retrieves the object processors of the specified <code>Class</code>.
		 * @param objectPostProcessorClass The specified <code>Class</code>.
		 */
		function getObjectPostProcessors(objectPostProcessorClass:Class):Array;

		/**
		 * Returns the number of object post processors.
		 */
		function get numObjectPostProcessors():int;

		/**
		 * Determines if an object is a IFactoryObject implementation.
		 *
		 * @param objectName  The name of the object that should be tested
		 *
		 * @return true if the corresponding object is an IFactoryObject implementation
		 */
		function isFactoryObject(objectName:String):Boolean;

		/**
		 * Registers a custom property editor. This method will only have effect if the
		 * typeConverter is an implementation of IPropertyEditorRegistry.
		 *
		 * @param requiredType    the type of the property
		 * @param propertyEditor   the property editor to register
		 *
		 * @see #typeConverter typeConverter
		 * @see org.springextensions.actionscript.objects.IPropertyEditorRegistry IPropertyEditorRegistry
		 */
		function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void;

	}
}
