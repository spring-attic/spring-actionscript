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
package org.springextensions.actionscript.eventbus.process {

	import flash.events.IEventDispatcher;

	import org.as3commons.lang.SoftReference;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.metadata.IMetadataDestroyer;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class RouteEventsMetaDataDestroyer extends AbstractEventBusMetadataProcessor implements IMetadataDestroyer {

		private static var logger:ILogger = getClassLogger(RouteEventsMetaDataDestroyer);

		/**
		 * Creates a new <code>RouteEventsMetaDataDestroyer</code> instance.
		 */
		public function RouteEventsMetaDataDestroyer() {
			super();
			metadataNames[metadataNames.length] = RouteEventsMetaDataProcessor.ROUTE_EVENTS_METADATA;
		}

		override public function process(target:Object, metadataName:String, params:Array=null):* {
			logger.debug("Removing {0} from eventbus", [target]);
			eventBusUserRegistry.removeEventListeners(IEventDispatcher(target));
		}

	}
}
