package org.springextensions.actionscript.ioc.factory.config.testclasses {
	
	import flash.events.Event;

	public class AnnotatedArrayEventHandlerWithNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent() {
		}

		[EventHandler(name="reverseArray")]
		public function someMethod(event:Event):void {
			addInvocation();
		}
	}
}