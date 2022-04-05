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
package org.springextensions.actionscript.eventbus.impl {


	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class ClassEntry {

		private var _clazz:Class;
		private var _topic:Object;

		/**
		 * Creates a new <code>ClassEntry</code> instance.
		 * @param clazz
		 * @param topic
		 */
		public function ClassEntry(clazz:Class, topic:Object=null) {
			super();
			_clazz = clazz;
			_topic = topic;
		}

		/**
		 *
		 */
		public function get clazz():Class {
			return _clazz;
		}

		/**
		 *
		 */
		public function get topic():Object {
			return _topic;
		}

	}
}
