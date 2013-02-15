/*

   Copyright (c) 2006. Adobe Systems Incorporated.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of Adobe Systems Incorporated nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

   @ignore
 */
package com.adobe.cairngorm.samples.store.command {

	import com.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.samples.store.event.ValidateCreditCardEvent;
	import com.adobe.cairngorm.samples.store.model.ShopModelLocator;
	import com.adobe.cairngorm.samples.store.view.checkout.PaymentInformationModel;

	import mx.collections.ArrayCollection;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;

	/**
	 * @version $Revision: $
	 */
	public class ValidateOrderCommand extends SequenceCommand {

		public function ValidateOrderCommand() {
		}

		public override function execute(event:CairngormEvent):void {
			var model:ShopModelLocator = ShopModelLocator.getInstance();

			if (model.shoppingCart.getElements().length == 0) {
				ShopModelLocator.getInstance().cartEmpty = true;
			} else {
				if (validateCheckOutForm()) {
					executeNextCommand();
				} else {
					ShopModelLocator.getInstance().formIncomplete = true;
				}
			}
		}

		public override function executeNextCommand():void {
			// Create the "next" event.
			var cardDetails:PaymentInformationModel = ShopModelLocator.getInstance().paymentInfo;

			var cardEvent:ValidateCreditCardEvent = new ValidateCreditCardEvent();
			cardEvent.cardholderName = cardDetails.cardHolder;
			cardEvent.cardNumber = cardDetails.cardNumber;

			// Dispatch the event.
			nextEvent = cardEvent;

			super.executeNextCommand();

			// Clear the event.
			nextEvent = null;
		}

		public function validateCheckOutForm():Boolean {
			var generalInfoValid:Boolean = validate(ShopModelLocator.getInstance().generalInfoValidators);

			var paymentInfoValid:Boolean = validate(ShopModelLocator.getInstance().paymentValidators);

			return generalInfoValid && paymentInfoValid;
		}

		private function validate(validators:ArrayCollection):Boolean {
			var valid:Boolean = true;

			for (var i:uint = 0; i < validators.length; i++) {
				var validator:Validator = Validator(validators[i]);
				var validationResult:ValidationResultEvent = validator.validate();

				if (validationResult.type == ValidationResultEvent.INVALID) {
					valid = false;

						// We don't break so all the fields can validate.
				}
			}

			return valid;
		}
	}
}
