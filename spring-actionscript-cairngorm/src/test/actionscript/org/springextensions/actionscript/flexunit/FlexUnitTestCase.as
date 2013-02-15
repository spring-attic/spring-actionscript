/*
 * Copyright 2007-2010 the original author or authors.
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
package org.springextensions.actionscript.flexunit {
	
	import flash.utils.Dictionary;
	import flexunit.framework.AssertionFailedError;
	import flexunit.framework.TestCase;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IllegalArgumentError;
	
	/**
	 * Extends the FlexUnit TestCase with extra assertions.
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class FlexUnitTestCase extends TestCase {
		
		private static function failArrayContains(message:String, item:*, array:Array):void {
			try {
				Assert.arrayContains(array, item);
			} catch (e:IllegalArgumentError) {
				failWithUserMessage(message, "the array does not contain the item <" + item + ">");
			}
		}
		
		private static function failDictionaryKeysOfType(message:String, dictionary:Dictionary, type:Class):void {
			try {
				Assert.dictionaryKeysOfType(dictionary, type);
			} catch (e:IllegalArgumentError) {
				failWithUserMessage(message, "not all keys of dictionary are of type <" + type + ">");
			}
		}
		
		// copied from flexunit.framework.TestCase because private
		private static function failWithUserMessage(userMessage:String, failMessage:String):void {
			if (userMessage.length > 0)
				userMessage = userMessage + " - ";
			throw new AssertionFailedError(userMessage + failMessage);
		}
		
		/**
		 * Creates a new <code>FlexUnitTestCase</code> instance.
		 */
		public function FlexUnitTestCase(methodName:String = null) {
			super(methodName);
		}
		
		// --------------------------------------------------------------------
		// assertArrayContains
		// --------------------------------------------------------------------
		public function assertArrayContains(... rest):void {
			if (rest.length == 3)
				failArrayContains(rest[0], rest[1], rest[2]);
			else
				failArrayContains("", rest[0], rest[1]);
		}
		
		// --------------------------------------------------------------------
		// assertDictionaryKeysOfType
		// --------------------------------------------------------------------
		public function assertDictionaryKeysOfType(... rest):void {
			if (rest.length == 3)
				failDictionaryKeysOfType(rest[0], rest[1], rest[2]);
			else
				failDictionaryKeysOfType("", rest[0], rest[1]);
		}
		
		// --------------------------------------------------------------------
		// assertLength
		// --------------------------------------------------------------------
		public function assertLength(... rest):void {
			if (rest.length == 3)
				assertEquals(rest[0], rest[1], rest[2].length);
			else
				assertEquals("", rest[0], rest[1].length);
		}
	}
}
