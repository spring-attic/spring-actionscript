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
package org.springextensions.actionscript.metadata.processor {

	import org.as3commons.metadata.process.impl.AbstractMetadataProcessor;
	import org.springextensions.actionscript.metadata.ISpringMetadaProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class AbstractSpringMetadataProcessor extends AbstractMetadataProcessor implements ISpringMetadaProcessor {

		private var _processBeforeInitialization:Boolean = false;

		/**
		 * Creates a new <code>AbstractSpringMetadataProcessor</code> instance.
		 */
		public function AbstractSpringMetadataProcessor() {
			super();
		}

		public function get processBeforeInitialization():Boolean {
			return _processBeforeInitialization;
		}

		public function set processBeforeInitialization(value:Boolean):void {
			_processBeforeInitialization = value;
		}
	}
}
