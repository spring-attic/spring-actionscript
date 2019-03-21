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
	import flash.events.IEventDispatcher;

	import org.as3commons.eventbus.IEventBus;
	import org.springextensions.actionscript.eventbus.EventBusShareSettings;
	import org.springextensions.actionscript.ioc.factory.IInstanceCache;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;

	/**
	 * Describes an object responsible for executing the logic that is involved with adding an <code>IApplicationContext</code>
	 * as a child to a parent context.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public interface IChildContextManager extends IEventDispatcher {

		/**
		 *
		 * @param parentContext
		 * @param childContext
		 * @param settings
		 */
		function addChildContext(parentContext:IApplicationContext, childContext:IApplicationContext, settings:ContextShareSettings=null):void;

		/**
		 *
		 * @param parentContext
		 * @param childContext
		 */
		function removeChildContext(parentContext:IApplicationContext, childContext:IApplicationContext):void;
	}
}
