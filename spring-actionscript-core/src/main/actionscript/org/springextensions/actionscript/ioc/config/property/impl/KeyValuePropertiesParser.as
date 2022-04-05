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
package org.springextensions.actionscript.ioc.config.property.impl {

	import flash.errors.IllegalOperationError;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesParser;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.util.MultilineString;

	/**
	 * <p><code>KeyValuePropertiesParser</code> parses a properties source string into a <code>IPropertiesProvider</code>
	 * instance.</p>
	 *
	 * <p>The source string contains simple key-value pairs. Multiple pairs are
	 * separated by line terminators (\n or \r or \r\n). Keys are separated from
	 * values with the characters '=', ':' or a white space character.</p>
	 *
	 * <p>Comments are also supported. Just add a '#' or '!' character at the
	 * beginning of your comment-line.</p>
	 *
	 * <p>If you want to use any of the special characters in your key or value you
	 * must escape it with a back-slash character '\'.</p>
	 *
	 * <p>The key contains all of the characters in a line starting from the first
	 * non-white space character up to, but not including, the first unescaped
	 * key-value-separator.</p>
	 *
	 * <p>The value contains all of the characters in a line starting from the first
	 * non-white space character after the key-value-separator up to the end of the
	 * line. You may of course also escape the line terminator and create a value
	 * across multiple lines.</p>
	 *
	 * @see org.springextensions.actionscript.collections.Properties Properties
	 *
	 * @author Martin Heidegger
	 * @author Simon Wacker
	 * @author Christophe Herreman
	 * @version 1.0
	 */
	public class KeyValuePropertiesParser implements IPropertiesParser {

		private static const HASH_CHARCODE:uint = 35; //= "#";
		private static const EXCLAMATION_MARK_CHARCODE:uint = 33; //= "!";
		private static const DOUBLE_BACKWARD_SLASH:String = '\\';
		private static const NEWLINE_CHAR:String = "\n";
		private static const NEWLINE_REGEX:RegExp = /\\n/gm;
		private static const SINGLE_QUOTE_CHARCODE:uint = 39; // = "'";
		private static const COLON_CHARCODE:uint = 58; //:
		private static const EQUALS_CHARCODE:uint = 61; //=
		private static const TAB_CHARCODE:uint = 9;
		private static const logger:ILogger = getClassLogger(KeyValuePropertiesParser);

		/**
		 * Constructs a new <code>PropertiesParser</code> instance.
		 */
		public function KeyValuePropertiesParser() {
			super();
		}

		/**
		 * Parses the given <code>source</code> and creates a <code>Properties</code> instance from it.
		 *
		 * @param source the source to parse
		 * @return the properties defined by the given <code>source</code>
		 */
		public function parseProperties(source:*, provider:IPropertiesProvider):void {
			logger.debug("Starting to parse properties sources:");
			var lines:MultilineString = new MultilineString(String(source));
			var numLines:Number = lines.numLines;
			var key:String;
			var value:String;
			var formerKey:String;
			var formerValue:String;
			var useNextLine:Boolean = false;

			for (var i:int = 0; i < numLines; i++) {
				var line:String = lines.getLine(i);
				logger.debug("Parsing line: {0}", [line]);
				// Trim the line
				line = StringUtils.trim(line);

				// Ignore Comments and empty lines
				if (isPropertyLine(line)) {
					// Line break processing
					if (useNextLine) {
						key = formerKey;
						value = formerValue + line;
						useNextLine = false;
					} else {
						var sep:int = getSeparation(line);
						key = StringUtils.rightTrim(line.substr(0, sep));
						value = line.substring(sep + 1);
						formerKey = key;
						formerValue = value;
					}
					// Trim the content
					value = StringUtils.leftTrim(value);

					// Allow normal lines
					var end:String = value.substring(value.length - 1);
					if (end == DOUBLE_BACKWARD_SLASH) {
						formerValue = value = value.substr(0, value.length - 1);
						useNextLine = true;
					} else {
						// restore newlines since these were escaped when loaded
						value = value.replace(NEWLINE_REGEX, NEWLINE_CHAR);
						provider.setProperty(key, value);
					}
				} else {
					logger.debug("Ignoring commented line.");
				}
			}
		}

		public function isPropertyLine(line:String):Boolean {
			return (line.charCodeAt(0) != HASH_CHARCODE && line.charCodeAt(0) != EXCLAMATION_MARK_CHARCODE && line.length != 0);
		}

		/**
		 * Returns the position at which key and value are separated.
		 *
		 * @param line the line that contains the key-value pair
		 * @return the position at which key and value are separated
		 */
		protected function getSeparation(line:String):int {
			var len:int = line.length;

			for (var i:int = 0; i < len; i++) {
				var char:uint = line.charCodeAt(i);

				if (char == SINGLE_QUOTE_CHARCODE) {
					i++;
				} else {
					if (char == COLON_CHARCODE || char == EQUALS_CHARCODE || char == TAB_CHARCODE) {
						logger.debug("Seperator '{0}' found at position {1}", [String.fromCharCode(char), i]);
						break;
					}
				}
			}
			return ((i == len) ? line.length : i);
		}

	}

}
