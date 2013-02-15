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
package org.springextensions.actionscript.stage {

	import flash.utils.getQualifiedClassName;

	import mx.core.UIComponent;

	import org.springextensions.actionscript.utils.ObjectUtils;

	/**
	 * Default <code>IObjectResolver</code> used for flex stage wiring.
	 *
	 * <p>
	 * Deny all flash.*, mx.*, spark.* and _* (skins, etc) classes and
	 * classes not inheriting from UIComponent.
	 * </p>
	 *
	 * <p>
	 * <b>Author:</b> Martino Piccinato<br/>
	 * <b>Version:</b> $Revision:$, $Date:$, $Author:$<br/>
	 * <b>Since:</b> 0.8
	 * </p>
	 *
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.context.support.FlexXMLApplicationContext
	 * @sampleref stagewiring
	 * @docref container-documentation.html#how_to_determine_which_stage_components_are_eligeble_for_configuration
	 */
	public class FlexStageDefaultObjectSelector implements IObjectSelector {
		private static const SPARK_PREFIX:String = "^spark.*";
		private static const FLASH_PREFIX:String = "^flash.*";
		private static const MX_PREFIX:String = "^mx.*";
		private static const UNDERSCORE:String = "_";

		/**
		 * Creates a new <code>FlexStageDefaultObjectSelector</code> instance.
		 */
		public function FlexStageDefaultObjectSelector() {
			super();
		}

		public function approve(object:Object):Boolean {
			var className:String;
			try {
				className = getQualifiedClassName(object);
			} catch (e:*) {
				return false;
			}

			if (className.search(SPARK_PREFIX) > -1 || className.search(FLASH_PREFIX) > -1 || className.search(MX_PREFIX) > -1 || className.indexOf(UNDERSCORE) > -1) {
				return false;
			}

			return (object is UIComponent);
		}

	}
}