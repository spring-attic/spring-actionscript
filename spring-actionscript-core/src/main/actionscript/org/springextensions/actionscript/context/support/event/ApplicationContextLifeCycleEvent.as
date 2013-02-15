package org.springextensions.actionscript.context.support.event {
	import flash.events.Event;

	public class ApplicationContextLifeCycleEvent extends Event {

		/**
		 *
		 */
		public static const SINGLETONS_INSTANTIATED:String = "singletonsInstantiated";
		/**
		 *
		 */
		public static const XML_PARSED:String = "xmlParsed";
		/**
		 *
		 */
		public static const FACTORY_POSTPROCESSORS_EXECUTED:String = "factoryPostProcessorsExecuted";
		/**
		 *
		 */
		public static const RESOURCES_LOADED:String = "resourcesLoaded";

		public function ApplicationContextLifeCycleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}