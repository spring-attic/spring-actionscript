package org.springextensions.actionscript.ioc.factory.config.testclasses {

	import flash.events.Event;

	public class AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithEventParameterAndWithNameEqualToEvent extends AbstractAnnotatedEventHandler {
		
		public function AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithEventParameterAndWithNameEqualToEvent() {
		}
		
		[EventHandler]
		public function reverseArray(event:Event):void {
			addInvocation();
		}
	}
}