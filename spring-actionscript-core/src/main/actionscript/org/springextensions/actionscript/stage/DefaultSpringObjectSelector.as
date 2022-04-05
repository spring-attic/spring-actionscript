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
package org.springextensions.actionscript.stage {

	import flash.utils.getQualifiedClassName;

	import org.as3commons.stageprocessing.IObjectSelector;

	/**
	 * Default <code>IObjectSelector</code> used for Spring Actionscript stage wiring.
	 * Deny all flash.*, mx.*, spark.* and _* (skins, etc) classes.
	 *
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultSpringObjectSelector implements IObjectSelector {
		private static const SPARK_PREFIX:String = "spark.";
		private static const FLASH_PREFIX:String = "flash.";
		private static const MX_PREFIX:String = "mx.";
		private static const UNDERSCORE:String = "_";

		/**
		 * Creates a new <code>FlexStageDefaultObjectSelector</code> instance.
		 */
		public function DefaultSpringObjectSelector() {
			super();
		}

		public function approve(object:Object):Boolean {
			try {
				var className:String = getQualifiedClassName(object);
				return approveClassName(className);
			} catch (e:*) {
			}
			return false;
		}

		internal function approveClassName(className:String):Boolean {
			var prefix:String = className.substring(0, 6);
			if ((prefix == SPARK_PREFIX) || (prefix == FLASH_PREFIX) || (prefix.substring(0, 3) == MX_PREFIX)) {
				return false;
			} else if (className.indexOf(UNDERSCORE) > -1) {
				return false;
			}

			return true;
		}

	}
}
