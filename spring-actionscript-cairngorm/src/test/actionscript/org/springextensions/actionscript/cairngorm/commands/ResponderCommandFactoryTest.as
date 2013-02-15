package org.springextensions.actionscript.cairngorm.commands
{
	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.cairngorm.business.BusinessDelegateFactory;
	import org.springextensions.actionscript.cairngorm.mocks.MockDelegate;

	public class ResponderCommandFactoryTest extends TestCase {
		
		public function ResponderCommandFactoryTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testCanCreate():void {
			var rcf:ResponderCommandFactory = new ResponderCommandFactory();
			var bdf:BusinessDelegateFactory = new BusinessDelegateFactory();
			bdf.delegateClass = MockDelegate;
			
			rcf.addBusinessDelegateFactory(bdf,[AbstractResponderCommand]);
			
			var b:Boolean = rcf.canCreate(AbstractResponderCommand);
			assertEquals(b,true);
			
			b = rcf.canCreate(TestCase);
			assertEquals(b,false);
		}
		
		public function testCreateCommand():void {
			var rcf:ResponderCommandFactory = new ResponderCommandFactory();
			var bdf:BusinessDelegateFactory = new BusinessDelegateFactory();
			bdf.delegateClass = MockDelegate;
			
			rcf.addBusinessDelegateFactory(bdf,[AbstractResponderCommand]);
			
			var c:AbstractResponderCommand = rcf.createCommand(AbstractResponderCommand) as AbstractResponderCommand;
			assertNotNull("command must not be null",c);
			assertNotNull("command's business delegate must not be null",c.businessDelegate);
			assertEquals((c.businessDelegate is MockDelegate), true);
		}
		
	}
}