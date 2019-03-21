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
package org.springextensions.actionscript.object.propertyeditor {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.IApplicationDomainAware;

	/**
	 * Converts class names to class objects.
	 *
	 * @author Christophe Herreman
	 * @productionversion SpringActionscript 2.0
	 */
	public class ClassPropertyEditor extends AbstractPropertyEditor implements IApplicationDomainAware {

		/**
		 * Creates a new <code>ClassPropertyEditor</code> instance
		 *
		 */
		public function ClassPropertyEditor() {
			super(this);
		}

		private var _applicationDomain:ApplicationDomain;

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * @private
		 */
		override public function set text(value:String):void {
			this.value = ClassUtils.forName(value, _applicationDomain);
		}
	}
}
