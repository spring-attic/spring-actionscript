package org.springextensions.actionscript.cairngorm.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	
	import flexunit.framework.TestCase;
	

	public class CommandFactoryTest extends TestCase{
		
		public function CommandFactoryTest() {
		}
		
		public function testCanCreate():void {
			var f:CommandFactory = new CommandFactory();
			var b:Boolean = f.canCreate(AbstractResponderCommand);
			assertEquals(b,true);
			b = f.canCreate(TestCase);
			assertEquals(b,false);
		}

		public function testCreateCommand():void {
			var f:CommandFactory = new CommandFactory();
			var c:ICommand = f.createCommand(AbstractResponderCommand);
			assertNotNull("command must not be null",c);
			c = null;
			try
			{
				c = f.createCommand(TestCase);
			}
			catch(e:Error){
				assertNull("command must be null",c);
			}
		}

	}
}