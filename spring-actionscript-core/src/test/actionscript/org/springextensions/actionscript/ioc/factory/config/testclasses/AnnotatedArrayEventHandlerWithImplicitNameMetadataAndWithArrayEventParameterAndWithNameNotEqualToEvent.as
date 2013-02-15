package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithImplicitNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent() {
		}

		[EventHandler("reverseArray")]
		public function someMethod(event:ArrayEvent):void {
			addInvocation();
		}
	}
}