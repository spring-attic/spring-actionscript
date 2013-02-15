/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.utils {

	/**
	 * @author Christophe Herreman
	 */
	public class Property {
		
		public var host:*;
		public var chain:Array;
		
		public function Property(host:*, ... chain) {
			this.host = host;
			this.chain = chain;
		}
		
		/**
		 * Returns the value of the property.
		 */
		public function getValue():* {
			var result:* = host[chain[0]];
			for (var i:int = 1; i<chain.length; i++) {
				if ("" == chain[i]) {
					break;
				}
				result = result[chain[i]];
			}
			return result;
		}
	}
}
