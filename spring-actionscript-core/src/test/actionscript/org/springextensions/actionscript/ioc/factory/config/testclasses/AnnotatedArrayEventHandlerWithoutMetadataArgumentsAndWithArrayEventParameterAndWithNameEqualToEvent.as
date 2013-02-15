package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayEventParameterAndWithNameEqualToEvent extends AbstractAnnotatedEventHandler {
		
		public function AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithArrayEventParameterAndWithNameEqualToEvent() {
		}
		
		[EventHandler]
		public function reverseArray(event:ArrayEvent):void {
			addInvocation();
		}
	}
}