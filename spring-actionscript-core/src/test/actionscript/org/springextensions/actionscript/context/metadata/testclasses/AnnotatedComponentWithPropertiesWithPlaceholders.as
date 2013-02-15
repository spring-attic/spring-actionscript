package org.springextensions.actionscript.context.metadata.testclasses {

	[Component]
	public class AnnotatedComponentWithPropertiesWithPlaceholders {

		public function AnnotatedComponentWithPropertiesWithPlaceholders() {
		}

		[Property(value="${replaceMe1}")]
		public var someProperty:String;

		[Property(value="${replaceMe2}")]
		public var someOtherProperty:uint;
	}
}