/*
* Copyright 2007-2012 the original author or authors.
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
package org.springextensions.actionscript.eventbus.impl {

	import org.as3commons.eventbus.IEventBus;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.eventbus.EventBusShareKind;
	import org.springextensions.actionscript.eventbus.EventBusShareSettings;
	import org.springextensions.actionscript.eventbus.IEventBusShareManager;

	/**
	 *
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class DefaultEventBusShareManager implements IEventBusShareManager {

		private static const LOGGER:ILogger = getClassLogger(DefaultEventBusShareManager);

		/**
		 * Creates a new <code>DefaultEventBusShareManager</code> instance.
		 */
		public function DefaultEventBusShareManager() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function addChildContextEventBusListener(childContext:IApplicationContext, parentEventBus:IEventBus, settings:EventBusShareSettings):void {
			if ((settings.shareKind === EventBusShareKind.ASSIGN_PARENT_EVENTBUS) && (childContext is IEventBusAware)) {
				LOGGER.debug("Assigning parent eventbus to child context");
				(childContext as IEventBusAware).eventBus = parentEventBus;
			} else if ((childContext is IEventBusAware) && (IEventBusAware(childContext).eventBus is IEventBusListener)) {
				var childEventBus:IEventBus = IEventBusAware(childContext).eventBus;
				if (parentEventBus === childEventBus) {
					return;
				}
				switch (settings.shareKind) {
					case EventBusShareKind.BOTH_WAYS:
						LOGGER.debug("Context eventbuses will listen both ways");
						linkEventBuses(parentEventBus, childEventBus, settings);
						linkEventBuses(childEventBus, parentEventBus, settings);
						break;
					case EventBusShareKind.PARENT_LISTENS_TO_CHILD:
						LOGGER.debug("Parent context eventbus will listen to the child's eventbus");
						linkEventBuses(childEventBus, parentEventBus, settings);
						break;
					case EventBusShareKind.CHILD_LISTENS_TO_PARENT:
						LOGGER.debug("Child context eventbus will listen to the parent's eventbus");
						linkEventBuses(parentEventBus, childEventBus, settings);
						break;
				}
			}
		}

		private function linkEventBuses(dispatcher:IEventBus, listener:IEventBus, settings:EventBusShareSettings):void {
			if (listener is IEventBusListener) {
				if (settings.shareRegularEvents) {
					LOGGER.debug("Adding regular event listener {0} to eventbus {1}", [listener, dispatcher]);
					dispatcher.addListener(listener as IEventBusListener);
				}
				for each (var topic:Object in settings.sharedTopics) {
					LOGGER.debug("Adding topic event listener {0} to eventbus {1} for topic {2}", [listener, dispatcher, topic]);
					dispatcher.addListener(listener as IEventBusListener, false, topic);
				}
			}
		}

	}
}
