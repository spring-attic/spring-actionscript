package org.springextensions.actionscript.cairngorm.mocks
{
	import org.springextensions.actionscript.cairngorm.AbstractResponder;

	public class MockDataTranslatorAwareBusinessDelegateResponder extends AbstractResponder {
		
		public function MockDataTranslatorAwareBusinessDelegateResponder() {
			super(this);
		}
		
		public var resultObject:*;
		public var faultObject:*;
		
		override public function result(data:Object):void {
			resultObject = data;
		}
		
		override public function fault(info:Object):void {
			faultObject = info;
		}

	}
}