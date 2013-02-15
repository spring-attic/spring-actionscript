package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent() {
		}

		[EventHandler(name="reverseArray")]
		public function someMethod(array:Array):void {
			addInvocation();
		}
	}
}