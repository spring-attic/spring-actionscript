package org.springextensions.actionscript.wire
{
	import flexunit.framework.TestCase;
	
	import mx.modules.Module;
	
	import org.springextensions.actionscript.objects.testclasses.DisplayContact;
	import org.springextensions.actionscript.stage.selectors.TypeBasedObjectSelector;

	public class TypeBasedObjectSelectorTest extends TestCase
	{
		public function TypeBasedObjectSelectorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testApproveClass():void {
			var selector:TypeBasedObjectSelector = new TypeBasedObjectSelector(
														[Module]);
			var module:Module = new Module();
			var contact:DisplayContact = new DisplayContact();
			assertTrue(selector.approve(module));
			assertFalse(selector.approve(contact));
		}
		
		public function testDenyClass():void {
			var selector:TypeBasedObjectSelector = new TypeBasedObjectSelector([Module],false);
			var module:Module = new Module();
			var contact:DisplayContact = new DisplayContact();
			assertTrue(selector.approve(contact));
			assertFalse(selector.approve(module));
		}
		
	}
}