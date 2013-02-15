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

	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.samples.store.business.IProductDelegate;
	import com.adobe.cairngorm.samples.store.model.ShopModelLocator;

	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;

	import org.as3commons.lang.Assert;

	/**
	 * @version  $Revision: $
	 */
	public class GetProductsCommand implements ICommand, IResponder {

		private var _delegate:IProductDelegate;

		public function GetProductsCommand(delegate:IProductDelegate) {
			Assert.notNull(delegate, "The product delegate must not be null");
			_delegate = delegate;
		}

		public function execute(event:CairngormEvent):void {
			if (ShopModelLocator.getInstance().products == null) {
				_delegate.responder = this;
				_delegate.getProducts();
			} else {
				Alert.show("Products already retrieved!");
				return;
			}
		}

		public function result(event:Object):void {
			// since amfphp returns an array of productVo's we need to pass it
			// as the source of an arraycollection
			var products:ICollectionView = ((event.result is Array) ? new ArrayCollection(event.result) : ICollectionView(event.result));
			var model:ShopModelLocator = ShopModelLocator.getInstance();

			// sort the data
			var sort:Sort = new Sort();
			sort.fields = [new SortField("name", true)];
			products.sort = sort;
			products.refresh();

			// set the products on the model
			model.selectedItem = products[0];
			model.products = products;
			model.workflowState = ShopModelLocator.VIEWING_PRODUCTS_IN_THUMBNAILS;
		}

		public function fault(event:Object):void {
			var faultEvent:FaultEvent = FaultEvent(event);
			Alert.show("Products could not be retrieved!");
		}
	}
}
