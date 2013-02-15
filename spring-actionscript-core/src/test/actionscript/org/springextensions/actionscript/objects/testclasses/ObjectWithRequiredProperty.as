package org.springextensions.actionscript.objects.testclasses
{
	public class ObjectWithRequiredProperty
	{
		public function ObjectWithRequiredProperty()
		{
			super();
		}
		
		[Required]
		public var required:Boolean;
		
		public var notRequired:Boolean;

	}
}