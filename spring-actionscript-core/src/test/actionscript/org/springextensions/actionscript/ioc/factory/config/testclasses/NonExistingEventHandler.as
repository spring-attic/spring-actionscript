package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class NonExistingEventHandler extends AbstractAnnotatedEventHandler {
		
		public function NonExistingEventHandler() {
		}
		
		[EventHandler]
		public function thisEventDoesNotExist():void {
			addInvocation();
		}
	}
}