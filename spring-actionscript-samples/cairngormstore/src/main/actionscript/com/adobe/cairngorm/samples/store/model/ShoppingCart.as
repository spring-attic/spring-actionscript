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
package com.adobe.cairngorm.samples.store.model
{
  import mx.collections.ArrayCollection;
  import mx.events.CollectionEvent;

  import com.adobe.cairngorm.samples.store.vo.ProductVO;

  /**
   * @version  $Revision: $
   */

  /**
   * Represents the shopping cart of a Cairngormstore customer.
   * @description
   * A collection of ShoppingCartElement objects that represent the current shopping cart of a user.
   * @see ShoppingCartElement
   * @see com.adobe.cairngorm.samples.store.vo.ProductVO
   */
  [Bindable]
  public class ShoppingCart
  {
    /**
     * Adds one or many products of same kind to the current shopping cart.
     *
     * @description
     * a product is represented as a Value Object, ProductVO. The quantity specifies the
     * the amount of products to add. If a product already exists, addElement() increases
     * the quantity of an existing element instead creating a new element.
     *
     * @param element Value Object ProductVO that represents a product.
     *
     * @param quantity (optional) Number of products to add. If not specified or invalid, quantity is 1.
     */
    public function addElement( element : ProductVO, quantity : Number = 1 ) : void
    {
      if( quantity <= 0 )
      {
        quantity = 1;
      }

      /*
      instead adding a new element to the shopping cart, just increase the quantity of an existing element.
      This functionality does not exist in the original Macromedia FlexStore.
      */
      for( var i : uint = 0; i < elements.length; i++ )
      {
        var shoppingCartElement : ShoppingCartElement = elements[ i ];

        if( shoppingCartElement.element.id == element.id )
        {
          shoppingCartElement.quantity += quantity;
          shoppingCartElement.totalProductPrice = shoppingCartElement.price * shoppingCartElement.quantity;
          totalProductPrice += shoppingCartElement.price * quantity;

          elements.dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE ) );

          return;
        }
      }

      addNewElementToCart( element, quantity );
    }

    /**
     * Deletes one or many elements of same kind of the current shopping cart.
     *
     * @param element Value Object ProductVO that represents a product.
     */
    public function deleteElement( element : ProductVO ) : Boolean
    {
      var deleted : Boolean = false;

      var i : int;
      for( i = 0; i < elements.length; i++ )
      {
        var shoppingCartElement : ShoppingCartElement = elements[ i ];
        if(shoppingCartElement.element.id === element.id)
        {
          totalProductPrice -= shoppingCartElement.totalProductPrice;
          elements.removeItemAt( i );
          deleted = true;
          break;
        }
      }
      return deleted;
    }

    public function getElements() : ArrayCollection
    {
      return elements;
    }

    /**
     * Adds a new type of element to the shopping cart.
     *
     * @param element Value Object ProductVO that represents a product.
     *
     * @param quantity (optional) Number of products to add. If not specified or invalid, quantity is 1.
     */
    private function addNewElementToCart( element : ProductVO, quantity : Number ):void
    {
      var shoppingCartElement : ShoppingCartElement = new ShoppingCartElement( element );
      shoppingCartElement.quantity = quantity;
      shoppingCartElement.name = element.name;
      shoppingCartElement.price = element.price;
      shoppingCartElement.totalProductPrice = element.price * quantity;
      elements.addItem( shoppingCartElement );
      totalProductPrice += shoppingCartElement.totalProductPrice;
    }

    /**
     * A collection of ShoppingCartElement objects that represent the content of the shopping cart.
     * @see ShoppingCartElement
     */
    public var elements : ArrayCollection = new ArrayCollection();

    /**
     * The sum of each ProductVO's price property muliplied by its quantity property.
     */
    public var totalProductPrice : Number = 0;

     /**
      * The shippingCost.
      */
    public var shippingCost : Number = 0;
  }
}
