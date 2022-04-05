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
package org.springextensions.actionscript.eventbus {

	/**
	 * Describes in what way two eventbuses will be shared.
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class EventBusShareSettings {

		/**
		 * Describes the directions in which two eventbuses listen to eachother.
		 * @default EventBusShareKind.ASSIGN_PARENT_EVENTBUS
		 */
		public var shareKind:EventBusShareKind;

		/**
		 * If <code>true</code>, events that are dispatched without a topic will be shared.
		 * @default true
		 */
		public var shareRegularEvents:Boolean = true;

		/**
		 * An optional <code>Array</code> of topic objects whose events will be shared between te eventbuses.
		 * @default null
		 */
		public var sharedTopics:Vector.<Object>;

		/**
		 * Creates a new <code>EventBusShareSettings</code> instance.
		 * @param shareRegular If <code>true</code>, events that are dispatched without a topic will be shared. Default is <code>true</code>.
		 * @param kind Describes the directions in which two eventbuses listen to eachother. Default is <code>EventBusShareKind.ASSIGN_PARENT_EVENTBUS</code>.
		 * @param topics An optional <code>Array</code> of topic objects whose events will be shared between te eventbuses. Default is <code>null</code>.
		 */
		public function EventBusShareSettings(shareRegular:Boolean=true, kind:EventBusShareKind=null, topics:Vector.<Object>=null) {
			super();
			shareRegularEvents = shareRegular;
			shareKind = kind ||= EventBusShareKind.ASSIGN_PARENT_EVENTBUS;
			sharedTopics = topics;
		}

		public function toString():String {
			return "EventBusShareSettings{shareKind:" + shareKind + ", shareRegularEvents:" + shareRegularEvents + ", sharedTopics:[" + sharedTopics + "]}";
		}

	}
}
