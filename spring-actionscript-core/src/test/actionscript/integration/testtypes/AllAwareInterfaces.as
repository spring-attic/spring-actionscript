/*
* Copyright 2007-2012 the original author or authors.
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
package integration.testtypes {

	import flash.system.ApplicationDomain;

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.lang.IApplicationDomainAware;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.IObjectFactoryAware;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistry;
	import org.springextensions.actionscript.ioc.objectdefinition.IObjectDefinitionRegistryAware;

	/**
	 *
	 * @author rolandzwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AllAwareInterfaces implements IEventBusAware, IApplicationContextAware, IApplicationDomainAware, IObjectFactoryAware, IObjectDefinitionRegistryAware {
		private var _eventBus:IEventBus;
		private var _applicationContext:IApplicationContext;
		private var _applicationDomain:ApplicationDomain;
		private var _objectFactory:IObjectFactory;
		private var _objectDefinitionRegistry:IObjectDefinitionRegistry;

		/**
		 * Creates a new <code>AllAwareInterfaces</code> instance.
		 */
		public function AllAwareInterfaces() {
			super();
		}

		public function get eventBus():IEventBus {
			return _eventBus;
		}

		public function set eventBus(value:IEventBus):void {
			_eventBus = value;
		}

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		public function get objectFactory():IObjectFactory {
			return _objectFactory;
		}

		public function set objectFactory(value:IObjectFactory):void {
			_objectFactory = value;
		}

		public function get objectDefinitionRegistry():IObjectDefinitionRegistry {
			return _objectDefinitionRegistry;
		}

		public function set objectDefinitionRegistry(value:IObjectDefinitionRegistry):void {
			_objectDefinitionRegistry = value;
		}
	}
}
