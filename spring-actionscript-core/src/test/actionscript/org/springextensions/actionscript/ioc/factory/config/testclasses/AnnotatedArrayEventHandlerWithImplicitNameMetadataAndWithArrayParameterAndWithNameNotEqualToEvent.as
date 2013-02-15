package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayParameterAndWithNameNotEqualToEvent() {
		}

		[EventHandler("reverseArray")]
		public function someMethod(array:Array):void {
			addInvocation();
		}
	}
}