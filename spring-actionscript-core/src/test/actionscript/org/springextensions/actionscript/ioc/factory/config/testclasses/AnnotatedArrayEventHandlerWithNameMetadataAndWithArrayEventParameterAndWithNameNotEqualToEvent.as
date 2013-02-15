package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent extends AbstractAnnotatedEventHandler {

		public function AnnotatedArrayEventHandlerWithNameMetadataAndWithArrayEventParameterAndWithNameNotEqualToEvent() {
		}

		[EventHandler(name="reverseArray")]
		public function someMethod(event:ArrayEvent):void {
			addInvocation();
		}
	}
}