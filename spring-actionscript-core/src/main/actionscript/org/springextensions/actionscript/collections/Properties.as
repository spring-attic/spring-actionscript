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
package org.springextensions.actionscript.collections {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.as3commons.lang.ObjectUtils;

	/**
	 * Dispatched when an error occured while loading the external property file.
	* @eventType flash.events.IOErrorEvent.IO_ERROR 
	*/
	[Event(name="ioError",type="flash.events.IOErrorEvent")]

	/**
	 * Dispatched when the external properties file has been loaded and the contents have been parsed.
	* @eventType flash.events.Event.COMPLETE
	*/
	[Event(name="complete",type="flash.events.Event")]

	/**
	 * The <code>Properties</code> class represents a collection of properties
	 * in the form of key-value pairs. All keys and values are of type
	 * <code>String</code>
	 *
	 * <p>
	 * <b>Author:</b> Christophe Herreman<br/>
	 * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
	 * <b>Since:</b> 0.1
	 * </p>
	 */
	public class Properties extends EventDispatcher {

		private var _loader:URLLoader;

		private var _properties:Object;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>Properties</code> object.
		 */
		public function Properties() {
			super(this);
			_properties = {};
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		/**
		 * The content of the Properties instance as an object.
		 * @return an object containing the content of the properties
		 */
		public function get content():Object {
			return _properties;
		}

		/**
		 * Returns an array with the keys of all properties. If no properties
		 * were found, an empty array is returned.
		 *
		 * @return an array with all keys
		 */
		public function get propertyNames():Array {
			return ObjectUtils.getKeys(_properties);
		}

		public function get length():uint {
			return ObjectUtils.getNumProperties(_properties);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Gets the value of property that corresponds to the given <code>key</code>.
		 * If no property was found, <code>null</code> is returned.
		 *
		 * @param key the name of the property to get
		 * @returns the value of the property with the given key, or null if none was found
		 */
		public function getProperty(key:String):String {
			return _properties[key];
		}

		/**
		 * Adds all content of the given properties object to this Properties.
		 */
		public function merge(properties:Properties, overrideProperty:Boolean = false):void {
			if (!properties) {
				return;
			}
			
			for (var key:String in properties.content) {
				if (!_properties[key] || (_properties[key] && overrideProperty)) {
					_properties[key] = properties.content[key];
				}
			}
		}
		
		/**
		 * Loads a collection of properties from an external file.
		 * Each property must be on a new line and in the form <em>key</em>=
		 * <em>value</em>.
		 * All keys and values are trimmed. Blank lines that do not contain
		 * properties are ignored. When the loading (and parsing) is done, a
		 * Event.COMPLETE event is dispatched.
		 * @param url the url of the properties file
		 * @param loader optional <code>URLLoader</code> instance to be used for the actual loading of the property file
		 * @param preventCache If true a random string is added to the specified URL to prevent the browser from caching the file
		 */
		public function load(url:String, loader:URLLoader = null, preventCache:Boolean = true):void {
			_loader = (loader) ? loader : new URLLoader();
			_loader.addEventListener(Event.COMPLETE, LoaderComplete_handler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, IOError_handler);

			// add a pseudo random number to avoid caching
			if (preventCache) {
				url = formatURL(url,preventCache);
			}
			var request:URLRequest = new URLRequest(url);
			_loader.load(request);
		}
		
		/**
		 * Adds a random number to the url, checks if a '?' character is already part of the string
		 * than suffixes a '&amp;' character
		 * @param url The url that will be processed
		 * @param preventCache
		 * @return The formatted URL
		 */
		public function formatURL(url:String, preventCache:Boolean):String {
			if (preventCache){
				var parameterAppendChar:String = (url.indexOf('?') < 0) ? "?" : "&";
				url += (parameterAppendChar + Math.round(Math.random() * 1000000));
			}
			return url;
		}
		
		/**
		 * Sets a property. If the property with the given key already exists,
		 * it will be replaced by the new value.
		 *
		 * @param key the key of the property to set
		 * @param value the value of the property to set
		 */
		public function setProperty(key:String, value:String):void {
			_properties[key] = value;
		}
		
		/**
		 * Redispatches the <code>IOErrorEvent</code> event.
		 * @param event the <code>IOErrorEvent</code> instance received from the internal <code>URLLoader</code>.
		 */
		protected function IOError_handler(event:IOErrorEvent):void {
			cleanupLoader();
			dispatchEvent(event);
		}
		
		/**
		 * Parses the received properties file and dispatches an <code>Event.COMPLETE</code> event.
		 * @see org.springextensions.actionscript.collections.PropertiesParser PropertiesParser
		 */
		protected function LoaderComplete_handler(event:Event):void {
			var parser:PropertiesParser = new PropertiesParser();
			var parsedProperties:Properties = parser.parseProperties(String(_loader.data));
			var keys:Array = parsedProperties.propertyNames;
			
			for each (var key:String in keys) {
				setProperty(key, parsedProperties.getProperty(key));
			}
			
			cleanupLoader();			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * If the <code>_loader</code> variable is not null the <code>onLoaderComplete</code>
		 * and <code>onIOError</code> event handlers are removed and the variable is set to null;
		 */
		protected function cleanupLoader():void {
			if (_loader) {
				if (_loader.willTrigger(Event.COMPLETE)) {
					_loader.removeEventListener(Event.COMPLETE, LoaderComplete_handler);
				}
				if (_loader.willTrigger(IOErrorEvent.IO_ERROR)) {
					_loader.removeEventListener(IOErrorEvent.IO_ERROR, IOError_handler);
				}
				_loader = null;
			}
		}
	}
}
