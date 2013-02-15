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
package com.adobe.cairngorm.samples.store.event
{
  import com.adobe.cairngorm.control.CairngormEvent;
  import com.adobe.cairngorm.samples.store.vo.ProductVO;
  import flash.events.Event;

  public class UpdateShoppingCartEvent extends CairngormEvent
  {
    public static const EVENT_ADD_PRODUCT_TO_SHOPPING_CART : String = "addProductToShoppingCart";
    public static const EVENT_DELETE_PRODUCT_FROM_SHOPPING_CART : String = "deleteProductFromShoppingCart";

    public var product : ProductVO;
    public var quantity : Number;

    /**
     * Constructor.
     */
    public function UpdateShoppingCartEvent( type : String, bubbles : Boolean = true, cancelable : Boolean = false )
    {
      super( type, bubbles, cancelable );
    }

    /**
     * Override the inherited clone() method, but don't return any state.
     */
    override public function clone() : Event
    {
      return new UpdateShoppingCartEvent( type, bubbles, cancelable );
    }
  }
}
