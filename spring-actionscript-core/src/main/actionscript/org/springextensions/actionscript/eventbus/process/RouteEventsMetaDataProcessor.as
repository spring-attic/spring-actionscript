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
	import flash.utils.Dictionary;

	import org.as3commons.lang.IDisposable;
	import org.as3commons.lang.SoftReference;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.MetadataArgument;
	import org.as3commons.reflect.Type;
	import org.springextensions.actionscript.eventbus.IEventBusUserRegistry;

	/**
	 * <code>IMetadataProcessor</code> implementation that can re-route events from arbitrary objects through
	 * the <code>EventBus.dispatchEvent()</code> method.
	 * <p>To re-route all events that are dispatched by an object add this metadata to a class:<br/>
	 * <pre>
	 * [RouteEvents]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {
	 * //implementation omitted...
	 * }
	 * </pre>
	 * If only certain events need to be re-routed, then add them to the events argument of the [RouteEvents] key:<br/>
	 * <pre>
	 * [RouteEvents(events="eventName1,eventName2")]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {<br/>
	 * //implementation omitted...
	 * }
	 * </pre>
	 * If events should be dispatched using a certain topic, add one or more topic names like this:<br/>
	 * <pre>
	 * [RouteEvents(events="eventName1,eventName2",topics="myTopicName,myTopicName2")]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {<br/>
	 * //implementation omitted...
	 * }
	 * </pre>
	 * When different events are dispatched under different topics, add multiple [RouteEvents] tags:<br/>
	 * <pre>
	 * [RouteEvents(events="eventName1",topics="myTopicName")]
	 * [RouteEvents(events="eventName2",topics="myTopicName2")]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {<br/>
	 * //implementation omitted...
	 * }
	 * </pre>
	 * When the required topic is the value of a property belonging to the event dispatcher, define them like this:<br/>
	 * <pre>
	 * [RouteEvents(events="eventName1",topicProperties="myComplexTopic")]
	 * [Event(name="eventName1",type="...")]
	 * [Event(name="eventName2",type="...")]
	 * [Event(name="eventName3",type="...")]
	 * public class MyClass {<br/>
	 * //implementation omitted...
	 * }
	 * </pre>
	 * </p>
	 * <p>Finally, to use the <code>RouteEventsMetaDataProcessor</code> in an application, add an object definition
	 * to the XML configuration like this:
	 * <pre>
	 * &lt;object id="routeEventsProcessor" class="org.springextensions.actionscript.ioc.factory.config.RouteEventsMetaDataPostProcessor"/&gt;
	 * </pre>
	 * </p>
	 * <p>This way the processor will be automatically registered with the application context.</p>
	 * @author Roland Zwaga
	 * @productionversion SpringActionscript 2.0
	 */
	public class RouteEventsMetaDataProcessor extends AbstractEventBusMetadataProcessor implements IDisposable {

		public static const EVENTS_KEY:String = "events";
		public static const EVENT_METADATA:String = "Event";
		public static const NAME_KEY:String = "name";
		public static const ROUTE_EVENTS_METADATA:String = "RouteEvents";
		public static const TOPICS_KEY:String = "topics";
		public static const TOPIC_PROPERTIES_KEY:String = "topicProperties";
		public static const COMMA:String = ',';
		public static const SPACE_CHAR:String = ' ';
		public static const EMPTY:String = '';

		private static const LOGGER:ILogger = getClassLogger(RouteEventsMetaDataProcessor);

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>RouteEventsMetaDataPostProcessor</code> instance.
		 */
		public function RouteEventsMetaDataProcessor() {
			super();
			metadataNames[metadataNames.length] = ROUTE_EVENTS_METADATA;
		}

		private var _eventBusUserRegistry:IEventBusUserRegistry;
		private var _typesLookup:Dictionary;

		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			if (!isDisposed) {
				super.dispose();
			}
		}

		/**
		 *
		 * @param instance
		 * @param container
		 * @param name
		 * @param objectName
		 */
		override public function process(target:Object, metadataName:String, params:Array=null):* {
			var container:IMetadataContainer = params[0];
			var type:Type = container as Type;
			if ((type != null) && (target is IEventDispatcher)) {
				var metadatas:Array = type.getMetadata(ROUTE_EVENTS_METADATA);
				for each (var metadata:Metadata in metadatas) {
					var eventTypes:Vector.<String>;
					if (metadata.hasArgumentWithKey(EVENTS_KEY)) {
						eventTypes = extractEventTypeNamesFromMetaDataArgument(metadata.getArgument(EVENTS_KEY));
					} else {
						eventTypes = extractEventTypeNamesFromMetaData(type);
					}
					var topics:Array = getTopics(metadata, target);
					var len:uint = topics.length;
					for (var i:int = 0; i < len; ++i) {
						var item:String = topics[i];
						if (!(item is String)) {
							topics[i] = new SoftReference(item);
						}
					}
					eventBusUserRegistry.addEventListeners(IEventDispatcher(target), eventTypes, topics);
				}
			}
		}

		private function extractEventTypeNamesFromMetaData(type:Type):Vector.<String> {
			var events:Array = type.getMetadata(EVENT_METADATA);
			var result:Vector.<String> = new Vector.<String>();
			for each (var metaData:Metadata in events) {
				if (metaData.hasArgumentWithKey(NAME_KEY)) {
					var arg:MetadataArgument = metaData.getArgument(NAME_KEY);
					if (result.indexOf(arg.value) < 0) {
						result[result.length] = arg.value;
						LOGGER.debug("Found [Event] metadata for event: {0}", [arg.value]);
					}
				}
			}
			return result;
		}

		private function extractEventTypeNamesFromMetaDataArgument(metaDataArgument:MetadataArgument):Vector.<String> {
			var arr:Array = metaDataArgument.value.split(SPACE_CHAR).join(EMPTY).split(COMMA);
			var result:Vector.<String> = new Vector.<String>();
			for each (var str:String in arr) {
				LOGGER.debug("Found event type as metadata argument: {0}", [str]);
				result[result.length] = str;
			}
			return result;
		}
	}
}
