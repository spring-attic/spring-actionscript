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
package org.springextensions.actionscript.ioc.factory.config.flex {

	import mx.utils.URLUtil;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.PropertyPlaceholderConfigurer;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * Flex specific extension of the PropertyPlaceholderConfigurer that resolves predefined application properties
	 * found in the Flex Application class. These properties can be used as regular property placeholders in
	 * an application context or a properties file. e.g. ${application.url}
	 *
	 * <p>The following properties are supported:
	 * <ul>
	 * <li>application.frameRate</li>
	 * <li>application.historyManagementEnabled</li>
	 * <li>application.pageTitle</li>
	 * <li>application.resetHistory</li>
	 * <li>application.scriptRecursionLimit</li>
	 * <li>application.scriptTimeLimit</li>
	 * <li>application.url</li>
	 * <li>application.url.protocol</li>
	 * <li>application.url.host</li>
	 * <li>application.url.port</li>
	 * <li>application.usePreloader</li>
	 * <li>application.viewSourceURL</li>
	 * </ul></p>
	 *
	 * @author Christophe Herreman
	 * @docref container-documentation.html#flex_application_settings
	 */
	public class FlexPropertyPlaceholderConfigurer extends PropertyPlaceholderConfigurer {

		/**
		 * Property names as they are defined in the application.
		 */
		public static const FRAME_RATE:String = "frameRate";

		public static const HISTORY_MANAGEMENT_ENABLED:String = "historyManagementEnabled";

		public static const PAGE_TITLE:String = "pageTitle";

		public static const RESET_HISTORY:String = "resetHistory";

		public static const SCRIPT_RECURSION_LIMIT:String = "scriptRecursionLimit";

		public static const SCRIPT_TIME_LIMIT:String = "scriptTimeLimit";

		public static const URL:String = "url";

		public static const USE_PRELOADER:String = "usePreloader";

		public static const VIEW_SOURCE_URL:String = "viewSourceURL";

		public static const PARAMETERS:String = "parameters";

		/**
		 * Property names as they are defined in the application context's properties file.
		 * Some are deducted from other properties (*)
		 */
		public static const APP_FRAME_RATE:String = APP + FRAME_RATE;

		public static const APP_HISTORY_MANAGEMENT_ENABLED:String = APP + HISTORY_MANAGEMENT_ENABLED;

		public static const APP_PAGE_TITLE:String = APP + PAGE_TITLE;

		public static const APP_RESET_HISTORY:String = APP + RESET_HISTORY;

		public static const APP_SCRIPT_RECURSION_LIMIT:String = APP + SCRIPT_RECURSION_LIMIT;

		public static const APP_SCRIPT_TIME_LIMIT:String = APP + SCRIPT_TIME_LIMIT;

		public static const APP_URL:String = APP + URL;

		public static const APP_URL_PROTOCOL:String = APP + URL + ".protocol"; // (*)

		public static const APP_URL_HOST:String = APP + URL + ".host"; // (*)

		public static const APP_URL_PORT:String = APP + URL + ".port"; // (*)

		public static const APP_USE_PRELOADER:String = APP + USE_PRELOADER;

		public static const APP_VIEW_SOURCE_URL:String = APP + VIEW_SOURCE_URL;

		public static const APP_PARAMETERS:String = APP + PARAMETERS;

		/** General prefix for application properties in a properties file. */
		private static const APP:String = "application.";

		/** The regular expression used to search for application properties. */
		private static const PROPERTY_REGEXP:RegExp = /\$\{application[^}]+\}/g;

		private static const LOGGER:ILogger = LoggerFactory.getClassLogger(FlexPropertyPlaceholderConfigurer);

		private var _initialized:Boolean = false;

		/** Stores the application properties */
		private var _appProperties:Properties = new Properties();

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function FlexPropertyPlaceholderConfigurer() {
			super();
		}

		// --------------------------------------------------------------------
		//
		// Overridden Methods
		//
		// --------------------------------------------------------------------

		override public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			// get all properties found in the application
			if (!_initialized) {
				initProperties();
				_initialized = true;
			}

			super.postProcessObjectFactory(objectFactory);
		}

		override protected function mergeProperties(properties:Properties):Properties {
			properties.merge(_appProperties);
			return properties;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Gets all application properties and stores them locally.
		 */
		private function initProperties():void {
			try {
				var app:Object = ApplicationUtils.application;

				_appProperties.setProperty(APP_FRAME_RATE, app[FRAME_RATE]);
				_appProperties.setProperty(APP_HISTORY_MANAGEMENT_ENABLED, app[HISTORY_MANAGEMENT_ENABLED]);
				_appProperties.setProperty(APP_PAGE_TITLE, app[PAGE_TITLE]);
				_appProperties.setProperty(APP_RESET_HISTORY, app[RESET_HISTORY]);
				_appProperties.setProperty(APP_SCRIPT_RECURSION_LIMIT, app[SCRIPT_RECURSION_LIMIT]);
				_appProperties.setProperty(APP_SCRIPT_TIME_LIMIT, app[SCRIPT_TIME_LIMIT]);
				_appProperties.setProperty(APP_USE_PRELOADER, app[USE_PRELOADER]);
				_appProperties.setProperty(APP_VIEW_SOURCE_URL, app[VIEW_SOURCE_URL]);

				if (app.hasOwnProperty(APP_PARAMETERS)) {
					_appProperties.setProperty(APP_PARAMETERS, app[APP_PARAMETERS]);
					//Add parameters as application properties
					if (app[APP_PARAMETERS] != null) {
						for each (var name:String in app[APP_PARAMETERS]) {
							_appProperties.setProperty(APP + name, app[APP_PARAMETERS][name]);
						}
					}
				} else {
					_appProperties.setProperty(APP_PARAMETERS, null);
				}

				var url:String = app[URL];
				_appProperties.setProperty(APP_URL, url);
				_appProperties.setProperty(APP_URL_PROTOCOL, URLUtil.getProtocol(url));
				_appProperties.setProperty(APP_URL_HOST, URLUtil.getServerName(url));
				_appProperties.setProperty(APP_URL_PORT, URLUtil.getPort(url).toString());
			} catch (e:Error) {
				LOGGER.debug("Could not create properties from application for the following reason: {0}", e.message);
			}
		}
	}
}