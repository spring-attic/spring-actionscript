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
package org.springextensions.actionscript.context {

	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;

	/**
	 * Provides methods that will enable an implementing class to be configured by <code>IObjectFactoryPostProcessor</code> instances.
	 *
	 * @author Christophe Herreman
	 */
	public interface IConfigurableApplicationContext extends IApplicationContext {

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The ObjectFactoryPostProcessors defined in this application context.
		 */
		function get objectFactoryPostProcessors():Array;

		/**
		 * Whether ObjectFactoryPostProcessor's defined in the parent contexts should be used or not. The default is
		 * false. Child contexts should set this property to true BEFORE being loaded.
		 */
		function get useParentObjectFactoryPostProcessors():Boolean;
		function set useParentObjectFactoryPostProcessors(value:Boolean):void;

		// --------------------------------------------------------------------
		//
		// Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Adds an <code>IObjectFactoryPostProcessor</code> instance to the current <code>XMLApplicationContext</code>
		 * @param objectFactoryPostProcessor An <code>IObjectFactoryPostProcessor</code> instance which is allowed to read the configuration metadata and potentially change it before the container has actually instantiated any other objects.
		 * @param index An optional index for the objectFactoryPostProcessor list that the specified <code>IObjectFactoryPostProcessor</code> will be inserted at
		 * @see org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor IObjectFactoryPostProcessor
		 */
		function addObjectFactoryPostProcessor(objectFactoryPostProcessor:IObjectFactoryPostProcessor, index:int = -1):void;
	}
}
