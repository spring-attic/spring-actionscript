/*
 * Copyright 2007-2008 the original author or authors.
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
package org.springextensions.actionscript.stage.mocks {
	import org.springextensions.actionscript.stage.AbstractStageProcessor;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	public class MockStageProcessor extends AbstractStageProcessor {

		private var _counter:int = 0;
		
		public function get counter():int {
			return _counter;
		}

		public function MockStageProcessor() {
			super(this);
			this.objectSelector = new MockApprovingSelector();
			document = ApplicationUtils.application;
		}

		override public function process(object:Object):Object {
			_counter++;
			return object;
		}

	}
}
