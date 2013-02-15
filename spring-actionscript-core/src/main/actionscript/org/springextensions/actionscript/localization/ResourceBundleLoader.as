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
package org.springextensions.actionscript.localization {

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;

	import mx.resources.IResourceBundle;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.collections.Properties;

	/**
	 * Use a <code>ResourceBundleLoader</code> to load an external resource bundle defined as a properties file.
	 * <p>When the resource bundle properties are loaded, a new <code>ResourceBundle</code> is created and registered with
	 * the <code>ResourceManager</code>.</p>
	 * @author Christophe Herreman
	 */
	public class ResourceBundleLoader extends EventDispatcher {

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(ResourceBundleLoader);

		private var _url:String;
		private var _name:String;
		private var _locale:String;
		private var _properties:Properties;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ResourceBundleLoader object.
		 *
		 * @param url the location of the resource bundle to load
		 * @param name the name of the resource bundle
		 * @param locale the locale of the resource bundle
		 */
		public function ResourceBundleLoader(url:String, name:String, locale:String) {
			super(this);
			_url = url;
			_name = name;
			_locale = locale;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Loads the external resource bundle and registers a new ResourceBundle in the ResourceManager.
		 */
		public function load():void {
			_properties = new Properties();
			_properties.addEventListener(Event.COMPLETE, load_completeHandler);
			_properties.addEventListener(IOErrorEvent.IO_ERROR, load_ioErrorHandler);

			LOGGER.debug("Loading resources for bundle '{0}' and locale '{1}' from location '{2}'", _name, _locale, _url);
			_properties.load(_url);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Load "complete" handler.
		 */
		private function load_completeHandler(event:Event):void {
			LOGGER.debug("Loaded resources for bundle '{0}' and locale '{1}' from location '{2}'", _name, _locale, _url);

			// create a new resource bundle and add it to the resource manager
			var resourceBundle:IResourceBundle = new ResourceBundle(_locale, _name);
			var properties:Object = _properties.content;
			var i:int = 0;

			for (var key:String in properties) {
				resourceBundle.content[key] = properties[key];
				i++;
			}

			ResourceManager.getInstance().addResourceBundle(resourceBundle);
			LOGGER.debug("Added '{0}' resources to bundle '{1}' for locale '{2}'", i, _name, _locale);

			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Load "error" handler.
		 */
		private function load_ioErrorHandler(event:Event):void {
			var message:String = "Could not load resources for bundle '" + _name + "' and locale '" + _locale + "' from location '" + _url + "'";

			LOGGER.error(message);

			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, message));
		}
	}
}