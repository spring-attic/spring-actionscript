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
package com.adobe.cairngorm.samples.store.control {

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.FrontController;
	import com.adobe.cairngorm.samples.store.command.AddProductToShoppingCartCommand;
	import com.adobe.cairngorm.samples.store.command.CompletePurchaseCommand;
	import com.adobe.cairngorm.samples.store.command.DeleteProductFromShoppingCartCommand;
	import com.adobe.cairngorm.samples.store.command.FilterProductsCommand;
	import com.adobe.cairngorm.samples.store.command.GetProductsCommand;
	import com.adobe.cairngorm.samples.store.command.SortProductsCommand;
	import com.adobe.cairngorm.samples.store.command.ValidateCreditCardCommand;
	import com.adobe.cairngorm.samples.store.command.ValidateOrderCommand;
	import com.adobe.cairngorm.samples.store.event.FilterProductsEvent;
	import com.adobe.cairngorm.samples.store.event.GetProductsEvent;
	import com.adobe.cairngorm.samples.store.event.PurchaseCompleteEvent;
	import com.adobe.cairngorm.samples.store.event.SortProductsEvent;
	import com.adobe.cairngorm.samples.store.event.UpdateShoppingCartEvent;
	import com.adobe.cairngorm.samples.store.event.ValidateCreditCardEvent;
	import com.adobe.cairngorm.samples.store.event.ValidateOrderEvent;

	import flash.utils.Dictionary;

	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;

	/**
	 * The main controller.
	 *
	 * <p>This controller is and application context aware Cairngorm front controller
	 * that will inject business delegates into the commands that it creates, specifically
	 * made for this example project.
	 *
	 * <p>Note: since this class application context aware, it must be managed by the Spring container.
	 *
	 * @version  $Revision: $
	 */
	public class ShopController extends FrontController implements IApplicationContextAware {

		private var _appContext:IApplicationContext;

		private var _commandArguments:Dictionary = new Dictionary();

		/**
		 * Creates a new ShopController
		 */
		public function ShopController() {
			_commandArguments[GetProductsCommand] = "productDelegate";
			_commandArguments[ValidateCreditCardCommand] = "creditCardDelegate";

			initialiseCommands();
		}

		public function set applicationContext(value:IApplicationContext):void {
			_appContext = value;
		}

        public function get applicationContext():IApplicationContext {
            return _appContext;
        }

		public function initialiseCommands():void {
			addCommand(GetProductsEvent.EVENT_GET_PRODUCTS, GetProductsCommand);
			addCommand(UpdateShoppingCartEvent.EVENT_ADD_PRODUCT_TO_SHOPPING_CART, AddProductToShoppingCartCommand);
			addCommand(UpdateShoppingCartEvent.EVENT_DELETE_PRODUCT_FROM_SHOPPING_CART, DeleteProductFromShoppingCartCommand);
			addCommand(FilterProductsEvent.EVENT_FILTER_PRODUCTS, FilterProductsCommand);
			addCommand(SortProductsEvent.EVENT_SORT_PRODUCTS, SortProductsCommand);
			addCommand(ValidateOrderEvent.EVENT_VALIDATE_ORDER, ValidateOrderCommand);
			addCommand(ValidateCreditCardEvent.EVENT_VALIDATE_CREDIT_CARD, ValidateCreditCardCommand);
			addCommand(PurchaseCompleteEvent.EVENT_COMPLETE_PURCHASE, CompletePurchaseCommand);
		}

		/**
		 * Custom implementation of executeCommand that will inject the constructor arguments into the command objects
		 * by looking them up in the application context.
		 */
		override protected function executeCommand(event:CairngormEvent):void {
			var cmdClass:Class = getCommand(event.type);
			var cmd:ICommand;

			// do we need to inject a constructor argument?
			var ctorArg:String = _commandArguments[cmdClass];

			if (ctorArg) {
				var arg:* = _appContext.getObject(ctorArg);
				cmd = new cmdClass(arg);
			} else {
				cmd = new cmdClass();
			}

			cmd.execute(event);
		}
	}
}
