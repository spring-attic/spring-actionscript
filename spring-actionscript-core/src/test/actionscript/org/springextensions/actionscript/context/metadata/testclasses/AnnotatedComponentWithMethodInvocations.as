package org.springextensions.actionscript.context.metadata.testclasses {

	[Component]
	public class AnnotatedComponentWithMethodInvocations {

		public function AnnotatedComponentWithMethodInvocations() {
			super();
		}

		[Invoke(args="ref=objectName1, value=10")]
		public function someFunction(obj:Object, count:int):void {

		}

		[Invoke(args="ref=objectName2")]
		public function someOtherFunction(obj:Object):void {

		}
	}
}