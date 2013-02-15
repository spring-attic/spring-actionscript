package org.springextensions.actionscript.cairngorm.mocks
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class MockCairngormEvent extends CairngormEvent {
		
		public static const EVENT_ID:String = "mockName";
		
		public function MockCairngormEvent(bubbles:Boolean=false, cancelable:Boolean=false) {
			super(EVENT_ID, bubbles, cancelable);
		}
		
	}
}