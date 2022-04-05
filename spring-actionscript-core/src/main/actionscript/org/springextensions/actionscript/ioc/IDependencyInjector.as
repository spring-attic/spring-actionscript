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
package org.springextensions.actionscript.ioc {
	import flash.events.IEventDispatcher;

	import org.springextensions.actionscript.ioc.autowire.IAutowireProcessor;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IReferenceResolver;
	import org.springextensions.actionscript.ioc.factory.process.IObjectPostProcessor;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinition;

	/**
	 * Defines the most basic service used to implement dependency injection.
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IDependencyInjector extends IEventDispatcher {
		/**
		 *
		 * @param instance
		 * @param objectDefinition
		 * @param objectName
		 * @param objectPostProcessors
		 * @param referenceResolvers
		 */
		function wire(instance:*, objectFactory:IObjectFactory, objectDefinition:IObjectDefinition=null, objectName:String=null):Object;
		/**
		 *
		 * @param objectDefinition
		 * @param instance
		 * @param objectFactory
		 */
		function executeMethodInvocations(objectDefinition:IObjectDefinition, instance:*, objectFactory:IObjectFactory):void;
		/**
		 *
		 * @param instance
		 * @param objectDefinition
		 */
		function initializeInstance(instance:*, objectDefinition:IObjectDefinition=null):void;
		/**
		 *
		 * @param instance
		 * @param objectDefinition
		 * @param objectName
		 * @param objectFactory
		 */
		function injectProperties(instance:*, objectDefinition:IObjectDefinition, objectName:String, objectFactory:IObjectFactory):void;
	}
}
