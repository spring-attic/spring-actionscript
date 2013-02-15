package org.springextensions.actionscript.cairngorm.commands
{
	import flexunit.framework.TestCase;

	public class AbstractResponderCommandTest extends TestCase {
		
		public function AbstractResponderCommandTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testExecuteNotAllowed():void {
			var c:AbstractResponderCommand = new AbstractResponderCommand();
			try
			{
				c.execute(null);
				fail("execute cannot be called in abstract base class");
			}
			catch(e:*){
				
			}
		}
		
		public function testResultNotAllowed():void {
			var c:AbstractResponderCommand = new AbstractResponderCommand();
			try
			{
				c.result(null);
				fail("result cannot be called in abstract base class");
			}
			catch(e:*){
				
			}
		}

		public function testFaultNotAllowed():void {
			var c:AbstractResponderCommand = new AbstractResponderCommand();
			try
			{
				c.fault(null);
				fail("fault cannot be called in abstract base class");
			}
			catch(e:*){
				
			}
		}
	}
}