package org.springextensions.actionscript.cairngorm.business
{
	import flexunit.framework.TestCase;

	public class CairngormServiceLocatorTest extends TestCase {
		
		public function CairngormServiceLocatorTest(methodName:String=null)	{
			super(methodName);
		}
		
		public function testTwoInstancesNotAllowed():void {
			try
			{
				var cairngormServiceLocator:CairngormServiceLocator = new CairngormServiceLocator();
				var cairngormServiceLocator2:CairngormServiceLocator = new CairngormServiceLocator();
				fail("Two different instances of CairngormServiceLocator are not allowed");
			}
			catch(e:Error){
			}
		}
		
	}
}