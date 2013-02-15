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
package org.springextensions.actionscript.cairngorm.control.module {
	
	import com.adobe.cairngorm.control.CairngormEvent;

	/**
	 * Base class for <code>CairngormEvents</code> that are used with the <code>ModuleFrontController</code>,
	 * will create an instance with the constructor argument <code>bubbles</code> set to true. 
	 * @author Roland Zwaga
	 */
	public class SASCairngormModuleEvent extends CairngormEvent {
		
		/**
		 * Creates a new <code>SASCairngormModuleEvent</code> instance.
		 */
		public function SASCairngormModuleEvent(type:String, cancelable:Boolean=false) {
			super(type, true, cancelable);
		}
		
		/**
		 * @throws Error <code>SASCairngormEvent</code> instances should be dispatched with a regular <code>dispatchEvent()</code> call that can bubble through the UI hierarchy.
		 */
		override public function dispatch():Boolean {
			throw Error("SASCairngormModuleEvent instances should not use the dispatch() method, use the regular dispatchEvent(new SASCairngormModuleEvent()) IEventDispatcher method");
		}
		
	}
}