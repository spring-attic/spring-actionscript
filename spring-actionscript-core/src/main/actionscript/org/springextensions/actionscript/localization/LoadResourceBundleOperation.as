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
package org.springextensions.actionscript.localization {

	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.AbstractOperation;

	/**
	 * Asynchronous operation that loads a resource bundle, based on the info provided in a ResourceBundleInfo
	 * object.
	 *
	 * <p>This class is used internally by the FlexXMLApplicationObject to queue resource bundle loading.</p>
	 *
	 * @author Christophe Herreman
	 */
	public class LoadResourceBundleOperation extends AbstractOperation {

		// --------------------------------------------------------------------
		//
		// Private Fields
		//
		// --------------------------------------------------------------------

		private var _info:ResourceBundleInfo;
		private var _loader:ResourceBundleLoader;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>LoadResourceBundleOperation</code> instance.
		 * @param info the resource bundle info
		 */
		public function LoadResourceBundleOperation(info:ResourceBundleInfo) {
			Assert.notNull(info,"info argument must not be null");
			super();
			init(info);
		}
		
		/**
		 * Creates a <code>ResourceBundleLoader</code> object, adds the appropriate event handlers
		 * and invokes the <code>ResourceBundleLoader.load()</code> method.
		 * @param info the resource bundle info
		 */
		protected function init(info:ResourceBundleInfo):void {
			_info = info;
			_loader = new ResourceBundleLoader(info.url, info.name, info.locale);
			_loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			_loader.addEventListener(ErrorEvent.ERROR, loader_errorHandler);
			_loader.load();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function loader_completeHandler(event:Event):void {
			removeEventListeners();
			result = _info;
			dispatchCompleteEvent();
		}

		private function loader_errorHandler(event:ErrorEvent):void {
			removeEventListeners();
			error = event.text;
			dispatchErrorEvent();
		}
		
		private function removeEventListeners():void {
			if (_loader != null) {
				_loader.removeEventListener(Event.COMPLETE, loader_completeHandler);
				_loader.removeEventListener(ErrorEvent.ERROR, loader_errorHandler);
				_loader = null;
			}
		}
	}
}