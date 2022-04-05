/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.ioc.factory.process.impl {
	import mx.utils.URLUtil;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.IOrdered;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.ioc.config.property.IPropertiesProvider;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;
	import org.springextensions.actionscript.ioc.factory.process.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.util.Environment;

	/**
	 * Object factory post processor that resolves predefined application properties
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
	 * @productionversion SpringActionscript 2.0
	 */
	public class ApplicationPropertiesObjectFactoryPostProcessor implements IObjectFactoryPostProcessor, IOrdered {

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

		private static const logger:ILogger = getClassLogger(ApplicationPropertiesObjectFactoryPostProcessor);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ApplicationPropertiesObjectFactoryPostProcessor() {
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get order():int {
			return -1;
		}

		public function set order(value:int):void {
			// don't set this; should also be -1
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function postProcessObjectFactory(objectFactory:IObjectFactory):IOperation {
			objectFactory.propertiesProvider.merge(getApplicationProperties());
			return null;
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private static function getApplicationProperties():IPropertiesProvider {
			var result:IPropertiesProvider = new Properties();

			try {
				var app:Object = Environment.getCurrentApplication();

				result.setProperty(APP_FRAME_RATE, app[FRAME_RATE]);
				result.setProperty(APP_HISTORY_MANAGEMENT_ENABLED, app[HISTORY_MANAGEMENT_ENABLED]);
				result.setProperty(APP_PAGE_TITLE, app[PAGE_TITLE]);
				result.setProperty(APP_RESET_HISTORY, app[RESET_HISTORY]);
				result.setProperty(APP_SCRIPT_RECURSION_LIMIT, app[SCRIPT_RECURSION_LIMIT]);
				result.setProperty(APP_SCRIPT_TIME_LIMIT, app[SCRIPT_TIME_LIMIT]);
				result.setProperty(APP_USE_PRELOADER, app[USE_PRELOADER]);
				result.setProperty(APP_VIEW_SOURCE_URL, app[VIEW_SOURCE_URL]);

				if (app.hasOwnProperty(APP_PARAMETERS)) {
					result.setProperty(APP_PARAMETERS, app[APP_PARAMETERS]);
					//Add parameters as application properties
					if (app[APP_PARAMETERS] != null) {
						for each (var name:String in app[APP_PARAMETERS]) {
							result.setProperty(APP + name, app[APP_PARAMETERS][name]);
						}
					}
				} else {
					result.setProperty(APP_PARAMETERS, null);
				}

				var url:String = app[URL];
				result.setProperty(APP_URL, url);
				result.setProperty(APP_URL_PROTOCOL, URLUtil.getProtocol(url));
				result.setProperty(APP_URL_HOST, URLUtil.getServerName(url));
				result.setProperty(APP_URL_PORT, URLUtil.getPort(url).toString());
			} catch (e:Error) {
				logger.error("Could not create properties from application for the following reason: {0}", e.message);
			}

			return result;

		}

	}
}
