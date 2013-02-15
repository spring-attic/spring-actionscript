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
package org.springextensions.actionscript.ioc.factory.config.flex {

	import mx.utils.URLUtil;

	import org.as3commons.lang.ObjectUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.springextensions.actionscript.collections.Properties;
	import org.springextensions.actionscript.ioc.IObjectDefinition;
	import org.springextensions.actionscript.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.springextensions.actionscript.ioc.factory.config.IObjectFactoryPostProcessor;
	import org.springextensions.actionscript.utils.ApplicationUtils;

	/**
	 * Resolves predefined application properties found in the Flex Application class. These properties can be used
	 * as regular property placeholders in an application context or a properties file. e.g. ${application.url}
	 *
	 * <p>This is an object factory post processor that can only be used with the FlexXMLApplicationContext. In order
	 * to use it in your app, include it as an object in your application context:</p>
	 * @example
	 * <p>&lt;object class="org.springextensions.actionscript.ioc.factory.config.flex.ApplicationPropertiesResolver"/&gt;</p>
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
	 * </ul>
	 * </p>
	 * @author Christophe Herreman
	 * @docref container-documentation.html#flex_application_settings
	 */
	public class ApplicationPropertiesResolver implements IObjectFactoryPostProcessor {

		private var _initialized:Boolean;

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

		public static const STAGE:String = "stage";

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

		public static const APP_STAGE:String = APP + STAGE;

		/** General prefix for application properties in a properties file. */
		private static const APP:String = "application.";

		/** The regular expression used to search for application properties. */
		private static const PROPERTY_REGEXP:RegExp = /\$\{application[^}]+\}/g;

		private static const LOGGER:ILogger = getLogger(ApplicationPropertiesResolver);

		/** Stores the application properties */
		private var _properties:Properties = new Properties();

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ApplicationPropertiesResolver
		 */
		public function ApplicationPropertiesResolver() {
			_initialized = false;
		}

		// --------------------------------------------------------------------
		//
		// IObjectFactoryPostProcessor implementation
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void {
			LOGGER.debug("Starting resolve of application properties.");

			// get all properties found in the application
			if (!_initialized) {
				initProperties();
				_initialized = true;
			}

			// scan each object definition for string values and resolve the possible properties in them
			for each (var objectName:String in objectFactory.objectDefinitionNames) {
				var objectDefinition:IObjectDefinition = objectFactory.getObjectDefinition(objectName);
				resolveConstructorArguments(objectDefinition);
				resolveProperties(objectDefinition);
			}
		}

		/**
		 * Gets all application properties and stores them locally.
		 */
		private function initProperties():void {
			// note: don't type 'app' to an MX or SPARK application since we will handle both types
			var app:Object = ApplicationUtils.application;

			_properties.setProperty(APP_FRAME_RATE, app[FRAME_RATE]);
			_properties.setProperty(APP_HISTORY_MANAGEMENT_ENABLED, safeGetObjProperty(app, HISTORY_MANAGEMENT_ENABLED));
			_properties.setProperty(APP_PAGE_TITLE, app[PAGE_TITLE]);
			_properties.setProperty(APP_RESET_HISTORY, safeGetObjProperty(app, RESET_HISTORY));
			_properties.setProperty(APP_SCRIPT_RECURSION_LIMIT, app[SCRIPT_RECURSION_LIMIT]);
			_properties.setProperty(APP_SCRIPT_TIME_LIMIT, app[SCRIPT_TIME_LIMIT]);
			_properties.setProperty(APP_USE_PRELOADER, safeGetObjProperty(app, USE_PRELOADER));
			_properties.setProperty(APP_VIEW_SOURCE_URL, app[VIEW_SOURCE_URL]);
			_properties.setProperty(APP_PARAMETERS, safeGetObjProperty(app, PARAMETERS));
			_properties.setProperty(APP_STAGE, app[STAGE]);

			// TODO add application.parameters?

			var url:String = app[URL];
			_properties.setProperty(APP_URL, url);
			_properties.setProperty(APP_URL_PROTOCOL, URLUtil.getProtocol(url));
			_properties.setProperty(APP_URL_HOST, URLUtil.getServerName(url));
			_properties.setProperty(APP_URL_PORT, URLUtil.getPort(url).toString());
		}

		/**
		 * Fetch a property value while preventing unknown property access exceptions.
		 *
		 * @param obj Is an object possibly containing a value for propertyName.
		 * @param propertyName Is the name to access the desired value.
		 * @return Returns either the value if the propertyName is valid or null.
		 */
		private function safeGetObjProperty(obj:Object, propertyName:String):* {
			return obj.hasOwnProperty(propertyName) ? obj[propertyName] : null;
		}

		/**
		 * Resolves the constructor arguments of the given object definition.
		 */
		private function resolveConstructorArguments(objectDefinition:IObjectDefinition):void {
			var numConstructorArgs:int = objectDefinition.constructorArguments.length;

			for (var i:int = 0; i < numConstructorArgs; i++) {
				var constructorArg:Object = objectDefinition.constructorArguments[i];

				if (constructorArg is String) {
					objectDefinition.constructorArguments[i] = resolvePropertyValue(String(constructorArg));
				}
			}
		}

		/**
		 * Resolves the properties of the given object definition.
		 */
		private function resolveProperties(objectDefinition:IObjectDefinition):void {
			var properties:Object = objectDefinition.properties;
			var propertyNames:Array = ObjectUtils.getKeys(properties);
			var numProperties:int = propertyNames.length;

			// check each property
			// if it is a string, we try to resolve the properties it may contain
			// note: for some reason a "for in" on the objectDefinition.properties seemed to skip some properties
			// and show other multiple times (???)
			for (var i:int = 0; i < numProperties; i++) {
				var propertyName:String = propertyNames[i];

				if (properties[propertyName] is String) {
					properties[propertyName] = resolvePropertyValue(properties[propertyName]);
				}
			}
		}

		/**
		 * Resolves the property value by replacing all application properties
		 */
		protected function resolvePropertyValue(value:String):String {
			var matches:Array = value.match(PROPERTY_REGEXP);

			for (var i:int = 0; i < matches.length; i++) {
				var property:String = matches[i];
				var key:String = property.substring(2, property.length - 1);
				var newValue:String = _properties.getProperty(key);
				value = value.replace(property, newValue);
			}

			return value;
		}
	}
}
