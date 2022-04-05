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
package org.springextensions.actionscript.util {

	/**
	 * <code>MultilineString</code> allows to access all lines of a string separately.
	 *
	 * <p>To not have to deal with different forms of line breaks (Windows/Apple/Unix)
	 * <code>MultilineString</code> automatically standardizes them to the <code>\n</code> character.
	 * So the passed-in <code>String</code> will always get standardized.</p>
	 *
	 * <p>If you need to access the original <code>String</code> you can use
	 * <code>getOriginalString</code>.</p>
	 *
	 * @author Martin Heidegger
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class MultilineString {

		/** Character code for the WINDOWS line break. */
		public static const WIN_BREAK:String = String.fromCharCode(13) + String.fromCharCode(10);

		/** Character code for the APPLE line break. */
		public static const MAC_BREAK:String = String.fromCharCode(13);
		/** Character used internally for line breaks. */
		public static const NEWLINE_CHAR:String = "\n";

		/** Original content without standardized line breaks. */
		private var _original:String;

		/** Separation of all lines for the string. */
		private var _lines:Array;

		/**
		 * Constructs a new MultilineString.
		 */
		public function MultilineString(string:String) {
			super();
			initMultiString(string);
		}

		protected function initMultiString(string:String):void {
			_original = string;
			_lines = string.split(WIN_BREAK).join(NEWLINE_CHAR).split(MAC_BREAK).join(NEWLINE_CHAR).split(NEWLINE_CHAR);
		}


		/**
		 * Returns the original used string (without line break standarisation).
		 *
		 * @return the original used string
		 */
		public function get originalString():String {
			return _original;
		}

		/**
		 * Returns a specific line within the <code>MultilineString</code>.
		 *
		 * <p>It will return <code>undefined</code> if the line does not exist.</p>
		 *
		 * <p>The line does not contain the line break.</p>
		 *
		 * <p>The counting of lines startes with <code>0</code>.</p>
		 *
		 * @param line number of the line to get the content of
		 * @return content of the line
		 */
		public function getLine(line:uint):String {
			return _lines[line];
		}

		/**
		 * Returns the content as array that contains each line.
		 *
		 * @return content split into lines
		 */
		public function get lines():Array {
			return _lines.concat();
		}

		/**
		 * Returns the amount of lines in the content.
		 *
		 * @return amount of lines within the content
		 */
		public function get numLines():uint {
			return _lines.length;
		}

	}
}
