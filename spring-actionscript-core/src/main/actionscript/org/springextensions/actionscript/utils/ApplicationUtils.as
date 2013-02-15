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

	import mx.core.Application;
	import mx.core.FlexVersion;

	import org.as3commons.lang.ClassUtils;

	/**
	 * Flex SDK version ignorant utilities for working with Application objects.
	 *
	 * @author Christophe Herreman
	 * @see org.springextensions.actionscript.context.support.mxml.Template#initialized() Template.initialized()
	 * @see org.springextensions.actionscript.context.support.mxml.Template#complete_handler() Template.complete_handler()
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition#initialized() ObjectDefinition.initialized()
	 * @see org.springextensions.actionscript.context.support.mxml.MXMLObjectDefinition#complete_handler() ObjectDefinition.complete_handler()
	 * @see org.springextensions.actionscript.context.support.MXMLApplicationContext#initialized() MXMLApplicationContext.initialized()
	 * @see org.springextensions.actionscript.context.support.MXMLApplicationContext#complete_handler() MXMLApplicationContext.complete_handler()
	 * @see org.springextensions.actionscript.ioc.factory.config.flex.ApplicationPropertiesResolver#initProperties() ApplicationPropertiesResolver.initProperties(
	 */
	public final class ApplicationUtils {

		private static const MXCORE_FLEX_GLOBALS:String = "mx.core.FlexGlobals";
		private static const TOP_LEVEL_APPLICATION:String = "topLevelApplication";
		private static const APPLICATION:String = "application";
		private static var _currentApplication:Object = null;

		/**
		 * The top level application.
		 */
		public static function get application():Object {
			if (_currentApplication == null) {
				if (FlexVersion.CURRENT_VERSION > FlexVersion.VERSION_3_0) {
					var flexGlobalsClass:Class = ClassUtils.forName(MXCORE_FLEX_GLOBALS);

					if (flexGlobalsClass && flexGlobalsClass[TOP_LEVEL_APPLICATION]) {
						_currentApplication = flexGlobalsClass[TOP_LEVEL_APPLICATION];
					}
				} else {
					_currentApplication = Application[APPLICATION];
				}
			}
			return _currentApplication;
		}

		/**
		 * Adds the given object as a child/element of the main application.
		 */
		public static function addChild(child:Object):void {
			if (FlexVersion.CURRENT_VERSION > FlexVersion.VERSION_3_0) {
				application.addElement(child);
			} else {
				application.addChild(child);
			}
		}

		/**
		 * Removes the given child object of the main application.
		 */
		public static function removeChild(child:Object):void {
			if (FlexVersion.CURRENT_VERSION > FlexVersion.VERSION_3_0) {
				application.removeElement(child);
			} else {
				application.removeChild(child);
			}
		}

	}
}