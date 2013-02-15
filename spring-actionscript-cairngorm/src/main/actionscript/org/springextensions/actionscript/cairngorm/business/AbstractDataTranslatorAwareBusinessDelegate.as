package org.springextensions.actionscript.cairngorm.business
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	/**
	 * Abstract implementation of a business delegate that can be assigned an <code>IDataTranslator</code> instance
	 * to do some initial data conversion before the delegate's result is sent back to it's initial responder.
	 * <p>Subclasses should use the <code>addResponderToToken()</code> method to intercept service calls<p>.
	 * @example
	 * <listing version="3.0">
	 * public function getProducts():void {
	 *   var token:AsyncToken = service.getProducts();
	 *   addResponderToToken(token);
	 * }
	 * </listing> 
	 * @author Roland Zwaga
	 * @see org.springextensions.actionscript.cairngorm.business.IDataTranslator
	 * @docref extensions-documentation.html#the_idatatranslator_interface
	 */
	public class AbstractDataTranslatorAwareBusinessDelegate extends AbstractBusinessDelegate implements IDataTranslatorAware, IResponder {

		private var _dataTranslator:IDataTranslator;
		/**
		 * @private
		 */
		public function get dataTranslator():IDataTranslator {
			return _dataTranslator;
		}
		/**
		 * @inheritDoc 
		 */
		public function set dataTranslator(value:IDataTranslator):void {
			_dataTranslator = value;
		}
		
		/**
		 * @param dataTranslator an <code>IDataTranslator</code> instance that will be used to convert the delegate's result
  		 * @inheritDoc
		 */
		public function AbstractDataTranslatorAwareBusinessDelegate(service:*=null, responder:IResponder=null, dataTranslator:IDataTranslator=null) {
			super(service, responder);
			this.dataTranslator = dataTranslator;
		}
		
		/**
		 * <p>Sends the result of the <code>IDataTranslator</code>'s translate() method back to the delegate's initial responder</p>
		 * @see org.springextensions.actionscript.cairngorm.business.IDataTranslator#translate() IDataTranslator.translate()
  		 * @inheritDoc
		 */
		public function result(data:Object):void {
			var result:* = data;
			if (_dataTranslator != null) {
				if (data is ResultEvent){
					var resultEvent:ResultEvent = (data as ResultEvent);
					result = new ResultEvent(ResultEvent.RESULT,resultEvent.bubbles,resultEvent.cancelable,_dataTranslator.translate(resultEvent.result),resultEvent.token,resultEvent.message);
				}
				else {
					result =_dataTranslator.translate(data);
				}
			}
			responder.result(result);
		}
		
		/**
		 * <p>Immediately returns the fault object back to the delegate's initial responder.</p> 
		 * @inheritDoc
		 */
		public function fault(info:Object):void	{
			responder.fault(info);
		}
		
		/**
		 * If an <code>IDataTranslator</code> instance has been assigned to the current delegate than the current delegate will be
		 * added as a responder to the specified <code>AsyncToken</code>. That way the delegate can intercept the service response
		 * and have its <code>IDataTranslator</code> instance convert it, befire it sends the result back to the delegate's initial responder.
		 * @param token The specified <code>AsyncToken</code> instance.
		 */
		protected function addResponderToToken(token : AsyncToken):void	{
			if (_dataTranslator != null) {
				token.addResponder(this);
			}
			else {
				token.addResponder(responder);
			}
		}
	}
}