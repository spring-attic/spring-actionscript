package org.springextensions.actionscript.context.metadata.testclasses {

	[Constructor(args="ref=objectName1")]
	[Component]
	public class AnnotatedComponentWithConstructor {

		public function AnnotatedComponentWithConstructor(obj:Object) {
			super();
		}

	}
}