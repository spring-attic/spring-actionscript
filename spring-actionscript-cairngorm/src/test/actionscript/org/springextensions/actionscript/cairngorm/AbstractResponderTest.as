package org.springextensions.actionscript.cairngorm {
	
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;

	public class AbstractResponderTest extends TestCase {
		
		public function testDirectInstantiation():void {
			try {
				var responder:AbstractResponder = new AbstractResponder(null);
				fail("Direct instation of an abstract class should not be possible");
			}
			catch (e:IllegalOperationError) {
			}			
		}
		
	}
}