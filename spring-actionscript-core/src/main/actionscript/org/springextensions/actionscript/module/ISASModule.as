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
package org.springextensions.actionscript.module {
	
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;

	/**
	 * Describes a <code>Module</code> that makes use of a <code>FlexXMLApplicationContext</code> instance
	 * and an optional parent context.
	 * @author Roland Zwaga
	 */
	public interface ISASModule extends IApplicationContextAware {
		/**
		 * The main <code>FlexXMLApplicationContext</code> for the current <code>ISASModule</code> instance.
		 * The <code>IApplicationContext</code> instance that is assigned to the <code>IApplicationContextAware.applicationContext</code>
		 * property can act as the parent context for this instance.
		 */
		function get moduleApplicationContext():FlexXMLApplicationContext;
		/**
		 * @private
		 */
		function set moduleApplicationContext(value:FlexXMLApplicationContext):void;
	}
}