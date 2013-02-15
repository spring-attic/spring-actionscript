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
package com.adobe.cairngorm.samples.store.model {

	import com.adobe.cairngorm.model.ModelLocator;
	import com.adobe.cairngorm.samples.store.business.ICreditCardDelegate;
	import com.adobe.cairngorm.samples.store.business.IProductDelegate;
	import com.adobe.cairngorm.samples.store.util.Comparator;
	import com.adobe.cairngorm.samples.store.view.assets.CairngormStoreAssets;
	import com.adobe.cairngorm.samples.store.view.checkout.GeneralInformationModel;
	import com.adobe.cairngorm.samples.store.view.checkout.PaymentInformationModel;
	import com.adobe.cairngorm.samples.store.vo.ProductVO;

	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.formatters.CurrencyFormatter;

	[Bindable]
	public class ShopModelLocator implements ModelLocator {

		private static var modelLocator:ShopModelLocator;

		public static function getInstance():ShopModelLocator {
			if (modelLocator == null) {
				modelLocator = new ShopModelLocator();
			}

			return modelLocator;
		}

		//Constructor should be private but current AS3.0 does not allow it yet (?)...
		public function ShopModelLocator() {
			if (modelLocator != null) {
				throw new Error("Only one ShopModelLocator instance should be instantiated");
			}

			shoppingCart = new ShoppingCart();
			productComparator = new Comparator();
			currencyFormatter = getInitialisedFormatter();
			assets = new CairngormStoreAssets();
		}

		private function getInitialisedFormatter():CurrencyFormatter {
			var formatter:CurrencyFormatter = new CurrencyFormatter();
			formatter.currencySymbol = "$";
			formatter.precision = 2;

			return formatter;
		}

		public var products:ICollectionView;

		public var selectedItem:ProductVO;

		public var shoppingCart:ShoppingCart;

		public var productComparator:Comparator;

		public var currencyFormatter:CurrencyFormatter;

		public var assets:CairngormStoreAssets;

		public var orderConfirmed:Boolean;

		public var creditCardInvalid:Boolean;

		public var cartEmpty:Boolean;

		public var formIncomplete:Boolean;

		public var generalInfo:GeneralInformationModel = new GeneralInformationModel();

		public var paymentInfo:PaymentInformationModel = new PaymentInformationModel();

		public var paymentValidators:ArrayCollection = new ArrayCollection();

		public var generalInfoValidators:ArrayCollection = new ArrayCollection();

		public var workflowState:Number = VIEWING_PRODUCTS_IN_THUMBNAILS;

		public static var VIEWING_PRODUCTS_IN_THUMBNAILS:Number = 0;

		public static var VIEWING_PRODUCTS_IN_GRID:Number = 1;

		public static var VIEWING_CHECKOUT:Number = 2;
	}
}
