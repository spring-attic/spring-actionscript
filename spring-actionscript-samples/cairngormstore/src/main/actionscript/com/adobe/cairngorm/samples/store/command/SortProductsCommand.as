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
package com.adobe.cairngorm.samples.store.command
{
  import com.adobe.cairngorm.commands.ICommand;
  import com.adobe.cairngorm.control.CairngormEvent;
  import com.adobe.cairngorm.samples.store.model.ShopModelLocator;
  import mx.collections.Sort;
  import mx.collections.SortField;
  import com.adobe.cairngorm.samples.store.event.SortProductsEvent;

  /**
   * @version $Revision: $
   */
  public class SortProductsCommand implements ICommand
  {
    public function SortProductsCommand()
    {
    }

    public function execute( event : CairngormEvent ) : void
    {
      var sortEvent : SortProductsEvent = SortProductsEvent( event );

      var sortBy : String = sortEvent.sortBy;
      var model : ShopModelLocator = ShopModelLocator.getInstance();

      var sort : Sort = new Sort();

      if ( sortBy == "price" )
      {
        sort.fields = [ new SortField( sortBy, false, false, true ) ];
      }
      else
      {
        sort.fields = [ new SortField( sortBy, true ) ];
      }

      model.products.sort = sort;
      model.products.refresh();

      model.selectedItem = model.products[ 0 ];
    }
  }
}
