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
package org.springextensions.actionscript.context {
	import flash.display.DisplayObject;

	import org.as3commons.stageprocessing.IStageObjectProcessorRegistryAware;
	import org.springextensions.actionscript.context.config.IConfigurationPackage;
	import org.springextensions.actionscript.ioc.config.IObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IApplicationContext extends IObjectFactory, IStageObjectProcessorRegistryAware {
		/**
		 * Returns a <code>Vector</code> of <code>IApplicationContexts</code> that have been registered as a child of the current <code>IApplicationContext</code>.
		 */
		function get childContexts():Vector.<IApplicationContext>;

		/**
		 * Returns all the <code>IObjectDefinitionsProviders</code> that have been added to the current <code>IApplicationContext</code>.
		 */
		function get definitionProviders():Vector.<IObjectDefinitionsProvider>;

		/**
		 * Returns all the <code>IObjectFactoryPostProcessors</code> that have been added to the current <code>IApplicationContext</code>.
		 */
		function get objectFactoryPostProcessors():Vector.<IObjectFactoryPostProcessor>;

		/**
		 *
		 */
		function get applicationContextInitializer():IApplicationContextInitializer;

		/**
		 * @private
		 */
		function set applicationContextInitializer(value:IApplicationContextInitializer):void;

		/**
		 *
		 */
		function get ignoredRootViews():Vector.<DisplayObject>;

		/**
		 *
		 */
		function get rootViews():Vector.<DisplayObject>;

		/**
		 * @param childContext the childContext.
		 * @param settings determines what data the parent context will share with te specified child context.
		 * @return the current <code>IApplicationContext</code>.
		 */
		function addChildContext(childContext:IApplicationContext, settings:ContextShareSettings = null):IApplicationContext;

		/**
		 *
		 * @param provider
		 */
		function addDefinitionProvider(provider:IObjectDefinitionsProvider):IApplicationContext;

		/**
		 *
		 * @param rootView
		 */
		function addIgnoredRootView(rootView:DisplayObject):void;

		/**
		 *
		 * @param objectFactoryPostProcessor
		 */
		function addObjectFactoryPostProcessor(objectFactoryPostProcessor:IObjectFactoryPostProcessor):IApplicationContext;

		/**
		 *
		 * @param rootView
		 */
		function addRootView(rootView:DisplayObject):void;

		/**
		 *
		 * @param configurationPackage
		 */
		function configure(configurationPackage:IConfigurationPackage):IApplicationContext;

		/**
		 *
		 */
		function load():void;

		/**
		 *
		 * @param childContext
		 * @return
		 */
		function removeChildContext(childContext:IApplicationContext):IApplicationContext;

		/**
		 *
		 * @param rootView
		 */
		function removeIgnoredRootView(rootView:DisplayObject):void;

		/**
		 *
		 * @param rootView
		 */
		function removeRootView(rootView:DisplayObject):void;
	}
}
