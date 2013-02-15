package org.springextensions.actionscript.ioc.factory.config.testclasses {

	import flash.events.Event;

	public class AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayParameterAndWithNameEqualToEvent extends AbstractAnnotatedEventHandler {
		
		public function AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayParameterAndWithNameEqualToEvent() {
		}
		
		[EventHandler]
		public function reverseArray(array:Array):void {
			addInvocation();
		}
	}
}