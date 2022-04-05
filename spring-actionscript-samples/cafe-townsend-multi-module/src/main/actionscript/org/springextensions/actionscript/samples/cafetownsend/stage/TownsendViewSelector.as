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
package org.springextensions.actionscript.samples.cafetownsend.stage {

	import org.as3commons.stageprocessing.IObjectSelector;
	import org.springextensions.actionscript.samples.cafetownsend.ITownsendView;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class TownsendViewSelector implements IObjectSelector {
		/**
		 * Creates a new <code>TownsendViewSelector</code> instance.
		 */
		public function TownsendViewSelector() {
			super();
		}

		public function approve(object:Object):Boolean {
			return (object is ITownsendView);
		}
	}
}
