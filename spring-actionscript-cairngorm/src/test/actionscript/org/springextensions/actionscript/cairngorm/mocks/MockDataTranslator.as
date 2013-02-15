package org.springextensions.actionscript.cairngorm.mocks
{
	import org.springextensions.actionscript.cairngorm.business.IDataTranslator;

	public class MockDataTranslator implements IDataTranslator {
		
		public function MockDataTranslator() {
		}
		
		public var translationResult:Object;

		public function translate(data:*):* {
			return translationResult;
		}
		
	}
}