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
package org.springextensions.actionscript.logging {

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;

	import mx.core.mx_internal;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.LineFormattedTarget;

	use namespace mx_internal;

	/**
	 * Provides a logger that writes messages to the SOS console.
	 *
	 * <p>In order to use this logger, add an instance to the <code>Log</code> as a target as follows:</p>
	 *
	 * <p><code>var sosTarget:SOSTarget = new SOSTarget();
	 * Log.addTarget(sosTarget);</code></p>
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 *
	 * @see http://sos.powerflasher.de
	 */
	public class SOSTarget extends LineFormattedTarget {

		public var foldMessages:Boolean = true;
		public var debugColor:Number = DEBUG_COLOR;
		public var infoColor:Number = INFO_COLOR;
		public var warningColor:Number = WARNING_COLOR;
		public var errorColor:Number = ERROR_COLOR;
		public var fatalColor:Number = FATAL_COLOR;

		private static var DEBUG_COLOR:Number = 0xFFFFFF;
		private static var INFO_COLOR:Number = 0xD9D9FF;
		private static var WARNING_COLOR:Number = 0xFFFFCE;
		private static var ERROR_COLOR:Number = 0xFFBBBB;
		private static var FATAL_COLOR:Number = 0xCC99CC;

		private static var LEVEL_STRING_MAP:Object = {
			2:"DEBUG",
			4:"INFO",
			6:"WARN",
			8:"ERROR",
			1000:"FATAL"
		};

		private var _socket:XMLSocket;
		private var _messageCache:Array;
		private var _host:String;
		private var _port:uint;

		/**
		 * Creates a new <code>SOSTarget</code> instance.
		 *
		 * @param host A fully qualified DNS domain name or an IP address in the form aaa.bbb.ccc.ddd. You can also specify null to connect to the host server on which the SWF file resides. If the SWF file issuing this call is running in a web browser, host must be in the same domain as the SWF file.
		 * @param port The TCP port number on the host used to establish a connection. The port number must be 1024 or greater, unless a policy file is being used.
		 */
		public function SOSTarget(host:String = "localhost", port:uint = 4445) {
			super();
			_socket = new XMLSocket();
			_host = host;
			_port = port;
			_messageCache = [];
			init();
		}

		/**
		 *
		 */
		override mx_internal function internalLog(message:String):void {
			if (_socket.connected) {
				_socket.send(createMessage(getLogLevelFromMessage(message), message));
			}
			else {
				_messageCache.push(message);
			}
		}

		/**
		 *
		 */
		private function init():void {
			includeCategory = true;
			includeDate = true;
			includeLevel = true;
			includeTime = true;

			// listen for socket events
			//_socket.addEventListener(XMLSocketEvent.CLOSE, onXMLSocketClose);
			_socket.addEventListener(Event.CONNECT, XMLSocketConnect_handler);
			//_socket.addEventListener(XMLSocketEvent.DATA, onXMLSocketData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, XMLSocketIOError_handler);
			//_socket.addEventListener(XMLSocketEvent.SECURITY_ERROR, onXMLSocketSecurityError);

			// connect the socket
			_socket.connect(_host, _port);
		}

		/*public function onXMLSocketClose(event:Event):void {
		 trace("onXMLSocketClose()");
		 }*/

		public function XMLSocketConnect_handler(event:Event):void {
			// set output colors
			_socket.send("<setKey><name>" + LEVEL_STRING_MAP[LogEventLevel.DEBUG] + "</name><color>" + debugColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LEVEL_STRING_MAP[LogEventLevel.INFO] + "</name><color>" + infoColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LEVEL_STRING_MAP[LogEventLevel.WARN] + "</name><color>" + warningColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LEVEL_STRING_MAP[LogEventLevel.ERROR] + "</name><color>" + errorColor + "</color></setKey>");
			_socket.send("<setKey><name>" + LEVEL_STRING_MAP[LogEventLevel.FATAL] + "</name><color>" + fatalColor + "</color></setKey>");

			// send all messages that have been logged when the socket was not
			// yet connected
			while (_messageCache.length > 0) {
				internalLog(_messageCache.shift());
			}
		}

		/*public function onXMLSocketData(event:Event):void {
		 trace("onXMLSocketData()");
		 }*/

		public function XMLSocketIOError_handler(event:IOErrorEvent):void {
			trace("onXMLSocketIOError()");
			// TODO
			//dispatchEvent(event);
		}

		/*public function onXMLSocketSecurityError(event:Event):void {
		 trace("onXMLSocketSecurityError()");
		 }*/

		private function getLogLevelFromMessage(message:String):int {
			var result:int = LogEventLevel.ALL;

			if (message.indexOf("[DEBUG]") > -1) {
				result = LogEventLevel.DEBUG;
			}
			else if (message.indexOf("[INFO]") > -1) {
				result = LogEventLevel.INFO;
			}
			else if (message.indexOf("[WARN]") > -1) {
				result = LogEventLevel.WARN;
			}
			else if (message.indexOf("[ERROR]") > -1) {
				result = LogEventLevel.ERROR;
			}
			else if (message.indexOf("[FATAL]") > -1) {
				result = LogEventLevel.FATAL;
			}
			return result;
		}

		private function createMessage(level:int, message:String):String {
			var containsNewLine:Boolean = (message.indexOf("\n") != -1);
			var result:String;

			if (containsNewLine && foldMessages) {
				var levelIndex:int = message.indexOf("]");
				var title:String = (levelIndex == -1) ? "Folded Message" : message.substr(0, levelIndex + 1);

				if (levelIndex != -1) {
					message = message.substring(levelIndex + 1 + fieldSeparator.length, message.length);
				}

				result = "<showFoldMessage key='" + LEVEL_STRING_MAP[level] + "'>"
						+ "<title>" + title + "</title>"
						+ "<message><![CDATA[" + message + "]]></message>"
						+ "</showFoldMessage>";
			} else {
				result = "<showMessage key=\"" + LEVEL_STRING_MAP[level] + "\"><![CDATA[" + message + "]]></showMessage>\n";
			}

			return result;
		}
	}
}
