package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEventPlusHandler extends AbstractAnnotatedEventHandler {
		
		public function AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEventPlusHandler() {
		}
		
		[EventHandler]
		public function reverseArrayHandler():void {
			addInvocation();
		}
	}
}