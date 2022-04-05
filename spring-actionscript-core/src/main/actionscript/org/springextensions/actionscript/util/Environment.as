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

	import flash.display.Stage;
	import flash.system.Security;

	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;

	/**
	 * Contains information about the environment the application is currently running in.
	 * <p>This class should never be instantiated since all methods are static.</p>
	 *
	 * @author Roland Zwaga
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public final class Environment {

		private static const APPLICATION_SANDBOX_TYPE:String = "application";
		private static const MXCORE_FLEX_VERSION:String = "mx.core::FlexVersion";
		private static const CURRENT_VERSION_FIELD_NAME:String = "CURRENT_VERSION";
		private static const MXCORE_APPLICATION:String = "mx.core.Application";
		private static const APPLICATION_FIELD_NAME:String = "Application";
		private static const MXCORE_FLEX_GLOBALS:String = "mx.core.FlexGlobals";
		private static const TOP_LEVEL_APPLICATION:String = "topLevelApplication";
		private static const SYSTEM_MANAGER_FIELD_NAME:String = "systemManager";
		private static const STAGE_FIELD_NAME:String = "stage";

		// --------------------------------------------------------------------
		//
		// Public Static Properties
		//
		// --------------------------------------------------------------------
		private static var _flexVersion:uint = uint.MAX_VALUE;

		/**
		 * Returns whether or not the application is running in an AIR environment.
		 *
		 * @return true if running in AIR; false if not
		 */
		public static function get isAIR():Boolean {
			return (Security.sandboxType == APPLICATION_SANDBOX_TYPE);
		}

		/**
		 * Returns whether or not the application is running in a Flex environment.
		 *
		 * @return true if running in Flex; false if not
		 */
		public static function get isFlex():Boolean {
			return (flexVersion > 0);
		}

		/**
		 * Returns the current flex version that the application is running in. Returns 0 if Flex is not present.
		 */
		public static function get flexVersion():uint {
			if (_flexVersion == uint.MAX_VALUE) {
				try {
					var cls:Class = ClassUtils.forName(MXCORE_FLEX_VERSION);
					_flexVersion = cls[CURRENT_VERSION_FIELD_NAME];
				} catch (e:Error) {
					_flexVersion = 0;
				}
			}
			return _flexVersion;
		}

		/**
		 * Returns the current <code>Application</code>, this can be either an MX Application or a Spark Application,
		 * depending on the current flex version that is running.<br/>
		 * If Flex is not running, null will be returned.
		 */
		public static function getCurrentApplication():Object {
			var fxVersion:uint = flexVersion;
			if (fxVersion > 0) {
				if (_flexVersion < 0x04000000) {
					var applicationClass:Class = ClassUtils.forName(MXCORE_APPLICATION);
					return applicationClass[APPLICATION_FIELD_NAME];
				} else {
					var flexGlobalsClass:Class = ClassUtils.forName(MXCORE_FLEX_GLOBALS);
					return flexGlobalsClass[TOP_LEVEL_APPLICATION];
				}
			}
			return null;
		}

		/**
		 * If Flex is running, the current stage is resolved using the current <code>Application.systemManager.stage</code> property,
		 * otherwise <code>null</code> is returned.
		 */
		public static function getCurrentStage():Stage {
			var app:Object = getCurrentApplication();
			if ((app != null) && (app[SYSTEM_MANAGER_FIELD_NAME] != null)) {
				return app[SYSTEM_MANAGER_FIELD_NAME][STAGE_FIELD_NAME] as Stage;
			}
			return null;
		}


		/**
		 * Returns whether or not the application is running in a Flash environment.
		 *
		 * @return true if running in Flash; false if not
		 */
		public static function get isFlash():Boolean {
			return (!isAIR && !isFlex);
		}
	}
}
