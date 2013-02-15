package org.springextensions.actionscript.cairngorm.mocks
{
	import mx.rpc.IResponder;
	
	import org.springextensions.actionscript.cairngorm.business.IBusinessDelegate;

	public class MockDelegate implements IBusinessDelegate {
		
		public function MockDelegate() {
		}

		private var _responder:IResponder;
		public function set responder(value:IResponder):void {
			_responder = value;
		}
		public function get responder():IResponder {
			return _responder;
		}
		
		private var _service:*;
		public function set service(value:*):void {
			_service = value;
		}
		public function get service():* {
			return _service;
		}

	}
}