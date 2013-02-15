package com.adobe.cairngorm.samples.store.business {

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	import org.springextensions.actionscript.cairngorm.IResponderAware;
	import org.as3commons.lang.Assert;

	/**
	 *  This class is a base class for all business delegate mockups
	 *  extend this class to get asynchronous respond.
	 *  You must call the super(responder) in your business delegate constructor
	 *  You can set the latency time by call this.Latency=<milliseconds>
	 *  To activate your mockup you will need to change the relevant command and
	 *  call the xxxDelegateMock.
	 */
	public class BaseBusinessDelegateMock implements IResponderAware {

		public function BaseBusinessDelegateMock() {
		}

		public function get responder():IResponder {
			return _responder;
		}

		public function set responder(value:IResponder):void {
			Assert.notNull("Responder cannot be null.");
			_responder = value;
		}

		protected function setResults(results:Object):void {
			this.results = results;
			if (latency > 0) {
				this.timer = new Timer(latency);
				timer.addEventListener("timer", invokeResponder);
				timer.start();
			} else {
				invokeResponder(null);
			}
		}

		protected function set Latency(time:Number):void {
			this.latency = time;
		}

		private function invokeResponder(evt:TimerEvent):void {
			try {
				if (evt != null)
					timer.stop();
				var ev:ResultEvent = new ResultEvent("MockUp", false, true, results);
				_responder.result(ev);
			} catch (er:Error) {
				_responder.fault(new FaultEvent("MockUp"));
			}
		}

		private var _responder:IResponder;

		//using a timer to simulate the latency during the client-server roundtrip
		private var timer:Timer;

		//the latency value can be set by the specific Business Delegates
		private var latency:Number = 0; //the default value is no latency

		//holding the results in a global is a little awkward...
		private var results:Object;
	}
}
