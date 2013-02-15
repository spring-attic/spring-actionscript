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
	 * Thrown by the a <code>Parse</code> instance when a closing tag isn't found.
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 * @see org.springextensions.actionscript.utils.Parse Parse#Parse() Parse.Parse()
	 */
	public class ParseError extends Error {
		
		private var _errorOffset:int;
		
		public function ParseError(message:String="", errorOffset:int=0) {
			super(message);
			_errorOffset = errorOffset;
		}
		
		public function getErrorOffset():int {
			return _errorOffset;
		}
		
		public function getMessage():String {
			return this.message;
		}
	}
}
