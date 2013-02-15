package org.springextensions.actionscript.ioc.factory.config.testclasses {

	public class AbstractAnnotatedEventHandler implements IAnnotatedEventHandler {

		private var _numInvocations:uint;

		public function AbstractAnnotatedEventHandler() {
		}

		public function get numInvocations():uint {
			return _numInvocations;
		}

		protected function addInvocation():void {
			_numInvocations++;
		}
	}
}