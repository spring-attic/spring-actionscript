package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent() {
		}

		[EventHandler("reverseArray")]
		public function someMethod():void {
			addInvocation();
		}
	}
}