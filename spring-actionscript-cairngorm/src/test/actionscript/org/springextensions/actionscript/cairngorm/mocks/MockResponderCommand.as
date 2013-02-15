package org.springextensions.actionscript.cairngorm.mocks
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import org.springextensions.actionscript.cairngorm.commands.AbstractResponderCommand;

	public class MockResponderCommand extends AbstractResponderCommand {
		
		public function MockResponderCommand() {
			super();
		}
		
		public var resultValue:Boolean = false; 
		
		override public function execute(event:CairngormEvent):void {
			resultValue = true;
		}

		
	}
}