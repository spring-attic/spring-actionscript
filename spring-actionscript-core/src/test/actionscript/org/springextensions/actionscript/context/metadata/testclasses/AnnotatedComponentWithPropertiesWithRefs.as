package org.springextensions.actionscript.context.metadata.testclasses {

	[Component]
	public class AnnotatedComponentWithPropertiesWithRefs {

		public function AnnotatedComponentWithPropertiesWithRefs() {
		}

		[Property(ref="objectName1")]
		public var someProperty:String;

		[Property(ref="objectName2")]
		public var someOtherProperty:uint;
	}
}