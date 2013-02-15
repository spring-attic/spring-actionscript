package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithNameMetadataAndWithoutParametersAndWithNameNotEqualToEvent() {
		}

		[EventHandler(name="reverseArray")]
		public function someMethod():void {
			addInvocation();
		}
	}
}