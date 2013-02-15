package org.springextensions.actionscript.context.metadata.testclasses {

	[Component]
	public class AnnotatedComponentWithPropertiesWithExplicitValues {

		public function AnnotatedComponentWithPropertiesWithExplicitValues() {
		}

		[Property(value="ThisValue")]
		public var someProperty:String;

		[Property(value="10")]
		public var someOtherProperty:uint;
	}
}