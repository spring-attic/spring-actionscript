package org.springextensions.actionscript.ioc.factory.config.testclasses {
	
	import flash.events.Event;

	public class AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithEventParameterAndWithNameNotEqualToEvent() {
		}

		[EventHandler("reverseArray")]
		public function someMethod(event:Event):void {
			addInvocation();
		}
	}
}