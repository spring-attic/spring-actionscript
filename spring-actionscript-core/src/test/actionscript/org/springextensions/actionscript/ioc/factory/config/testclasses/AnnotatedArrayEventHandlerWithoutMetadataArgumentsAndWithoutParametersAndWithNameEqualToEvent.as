package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEvent extends AbstractAnnotatedEventHandler {
		
		public function AnnotatedArrayEventHandlerWithoutMetadataArgumentsAndWithoutParametersAndWithNameEqualToEvent() {
		}
		
		[EventHandler]
		public function reverseArray():void {
			addInvocation();
		}
	}
}