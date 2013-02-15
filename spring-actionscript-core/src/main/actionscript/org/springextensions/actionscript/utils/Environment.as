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
package org.springextensions.actionscript.utils {

	import flash.system.Security;

	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;

	/**
	 * Contains information about the environment the application is currently running in.
	 *
	 * <p>This class should never be instantiated since all methods are static.</p>
	 *
	 * @author Christophe Herreman
	 */
	public class Environment {

		private static const APPLICATION_SANDBOX_TYPE:String = "application";
		private static const MXCORE_FLEX_VERSION:String = "mx.core::FlexVersion";

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function Environment() {
		}

		// --------------------------------------------------------------------
		//
		// Public Static Properties
		//
		// --------------------------------------------------------------------

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
			try {
				ClassUtils.forName(MXCORE_FLEX_VERSION);
			} catch (e:ClassNotFoundError) {
				return false;
			}
			return true;
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