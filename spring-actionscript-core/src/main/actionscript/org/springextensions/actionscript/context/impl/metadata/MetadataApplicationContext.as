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
package org.springextensions.actionscript.context.impl.metadata {

	import flash.display.DisplayObject;
	import flash.utils.setTimeout;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.impl.DefaultApplicationContext;
	import org.springextensions.actionscript.ioc.config.impl.metadata.MetadataObjectDefinitionsProvider;
	import org.springextensions.actionscript.ioc.factory.IObjectFactory;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class MetadataApplicationContext extends DefaultApplicationContext {
		private var _token:uint;

		/**
		 * Creates a new <code>MetadataApplicationContext</code> instance.
		 */
		public function MetadataApplicationContext(rootViews:Vector.<DisplayObject>, parent:IApplicationContext=null, objFactory:IObjectFactory=null) {
			super(parent, rootViews, objFactory);
			var provider:MetadataObjectDefinitionsProvider = new MetadataObjectDefinitionsProvider();
			addDefinitionProvider(provider);
		}

		override public function load():void {
			if (loaderInfo != null) {
				super.load();
			} else {
				waitForLoader();
			}
		}

		protected function waitForLoader():void {
			var superLoad:Function = super.load;
			_token = setTimeout(function():void {
				if (loaderInfo != null) {
					superLoad();
				} else {
					waitForLoader();
				}
			}, 250);
		}

	}
}
