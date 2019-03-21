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
package org.springextensions.actionscript.ioc.config.impl.xml.namespacehandler.impl.eventbus.customconfiguration {

	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractInterceptorCustomConfigurator extends AbstractEventBusCustomConfigurator {

		private var _eventName:String;
		private var _eventClass:Class;
		private var _topics:Vector.<String>;
		private var _topicProperties:Vector.<String>;

		/**
		 * Creates a new <code>AbstractInterceptorCustomConfigurator</code> instance.
		 * @param eventBusUserRegistry
		 * @param eventName
		 * @param eventClass
		 * @param topics
		 * @param topicProperties
		 */
		public function AbstractInterceptorCustomConfigurator(eventBusUserRegistry:IEventBusUserRegistry, eventName:String=null, eventClass:Class=null, topics:Vector.<String>=null, topicProperties:Vector.<String>=null) {
			super(eventBusUserRegistry);
			initAbstractInterceptorCustomConfigurator(eventName, eventClass, topics, topicProperties);
		}

		protected function initAbstractInterceptorCustomConfigurator(eventName:String, eventClass:Class, topics:Vector.<String>, topicProperties:Vector.<String>):void {
			_eventName = eventName;
			_eventClass = eventClass;
			_topics = topics;
			_topicProperties = topicProperties;
		}

		/**
		 *
		 */
		public function get eventName():String {
			return _eventName;
		}

		/**
		 *
		 */
		public function get eventClass():Class {
			return _eventClass;
		}

		/**
		 *
		 */
		public function get topics():Vector.<String> {
			return _topics;
		}

		/**
		 *
		 */
		public function get topicProperties():Vector.<String> {
			return _topicProperties;
		}

		public function toString():String {
			return "AbstractInterceptorCustomConfigurator{eventName:\"" + _eventName + "\", eventClass:" + _eventClass + ", topics:[" + _topics + "], topicProperties:[" + _topicProperties + "]}";
		}

	}
}
