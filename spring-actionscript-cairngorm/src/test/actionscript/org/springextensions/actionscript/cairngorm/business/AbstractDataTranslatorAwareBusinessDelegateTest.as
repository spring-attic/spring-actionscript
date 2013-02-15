package org.springextensions.actionscript.cairngorm.business
{
	import flexunit.framework.TestCase;
	
	import org.springextensions.actionscript.cairngorm.mocks.MockDataTranslator;
	import org.springextensions.actionscript.cairngorm.mocks.MockDataTranslatorAwareBusinessDelegateResponder;

	public class AbstractDataTranslatorAwareBusinessDelegateTest extends TestCase {
		
		public function AbstractDataTranslatorAwareBusinessDelegateTest(methodName:String=null) {
			super(methodName);
		}
		
		public function testConstructor():void {
			
			var mdt:MockDataTranslator = new MockDataTranslator();
			
			var dbd:AbstractDataTranslatorAwareBusinessDelegate = new AbstractDataTranslatorAwareBusinessDelegate(null,null,mdt); 
			
			assertEquals(dbd.dataTranslator,mdt);
		}
		
		public function testResultWithoutDataTranslator():void {
			var r:MockDataTranslatorAwareBusinessDelegateResponder = new MockDataTranslatorAwareBusinessDelegateResponder();
			var dbd:AbstractDataTranslatorAwareBusinessDelegate = new AbstractDataTranslatorAwareBusinessDelegate();
			dbd.responder = r; 
			
			var mockResult:Object = {};
			
			dbd.result(mockResult);
			
			assertEquals(r.resultObject,mockResult);
		}

		public function testResultWithDataTranslator():void {
			var dt:MockDataTranslator = new MockDataTranslator();
			var r:MockDataTranslatorAwareBusinessDelegateResponder = new MockDataTranslatorAwareBusinessDelegateResponder();
			var dbd:AbstractDataTranslatorAwareBusinessDelegate = new AbstractDataTranslatorAwareBusinessDelegate(null,null,dt);
			
			assertEquals(dbd.dataTranslator,dt);
			
			dbd.responder = r; 
			
			var mockResult:Object = {};
			var mockTranslatedResult:Object = {};
			dt.translationResult = mockTranslatedResult;
			
			dbd.result(mockResult);
			
			assertEquals(r.resultObject,mockTranslatedResult);
		}

	}
}