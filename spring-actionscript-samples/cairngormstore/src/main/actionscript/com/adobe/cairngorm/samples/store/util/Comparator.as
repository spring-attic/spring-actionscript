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
package com.adobe.cairngorm.samples.store.util
{
  /**
   * @version  $Revision: $
   */

  /**
   * The Comparator class can filter objects based on two different kinds of filtering. Filtering on a:
   * <ul>
   *  <li>numerical range</li>
   * <li>selection of properties that can be compared over the '==' operator.</li>
   * </ul>
   * All filter objects need to implement the Comparable interface,
   * which forces objects to implement a getIdentifier method. The getIdentifier method shall
   * provide a unique identifier to each filter object.
   *
   * @description  initialise
   * The following code is an excerpt of Cairngormstore's use of the Comparator class. The Cairngormstore
   * filters objects are Value Objects (type ProductVO) on a numerical range based on a the price property of each
   * Value Object. Products are represented in a TileList component and will fade out if filtered.
   * <p/>
   * In the initialise method of Cairngormstore's ModelLocator we create a Comparator instance
   * and store it to ModelLocator.
   * <p>
   * <code>
   * ModelLocator.productComparator = new Comparator();
   * </code>
   * </p>
   * In the setValue method of the custom cell renderer class ProductThumbnail.mxml we register every
   * Value Object (ProductVO) with it's visual representation, which we want to manipulate
   * (in our case: fade out / fade in).
   * <p>
   * <code>
   * ModelLocator.productComparator.addComparable( this.image, product );
   * </code>
   * </p>
   * The HSlider component in FilterControls.mxml calls the onSliderChange method of
   * its View Helper class FilterControlsViewHelper.as when the slider is modified. The View Helper
   * class executes a Command class that tells our Comparator instance in ModelLocator
   * to filter all registered ProductVO's if their price property is outside a specified range.
   * The range is the current
   * minimum and maximum positions of the HSlider compoment.
   * We use the applyAlphaEffect method to apply a visual fade effect to our registered image components
   * that represent our ProductVO's.
   * <p>
   * <code>
   *   ModelLocator.productComparator.addFilterRangeProperty( "price",
   *                            event.target.values[0],
   *                            event.target.values[1] );
   *  ModelLocator.productComparator.filter();
   *  ModelLocator.productComparator.applyAlphaEffect();
   * </code>
   * </p>
   * The following is another example to use the selection filtering feature of Comparator. Based on the state
   * of CheckBox components (category1 - category5), we create an Array of values with the property
   * we want to keep. In the example
   * below we use numbers that represent categories. Every Value Object has a 'category' property. We
   * call the addFilterSeletionProperty and pass the property we want to compare, and the Array of
   * selections that holds the selected (unfiltered) values. We access all unfiltered products with
   * getUnfilteredComparables and assign those products to a productsDataProvider property of ModelLocator.
   * An arbitrary number of components could be bound to the productDataProvider of ModelLocator and
   * would therefore change it's visual representation when products were filtered or unfiltered.
   * <p>
   * <code>
   *  public function filterCategory() : void
   *  {
   *      var selections : Array = new Array();
   *      if( view.category1.selected == true )
   *      {
   *        selections.push(1);
   *      }
   *       if( view.category2.selected == true )
   *      {
   *        selections.push(2);
   *      }
   *      if( view.category3.selected == true )
   *      {
   *        selections.push(3);
   *      }
   *      if( view.category4.selected == true )
   *      {
   *        selections.push(4);
   *      }
   *      if( view.category5.selected == true )
   *      {
   *        selections.push(5);
   *      }
   *
   *    ModelLocator.productComparator.addFilterSelectionProperty( "category", selections );
   *    ModelLocator.productComparator.filter();
   *
   *    var products : Array = ModelLocator.productComparator.getUnfilteredComparables();
   *    ModelLocator.productDataProvider = products;
   *  }
   * </code>
   * </p>
   * @see Comparable
   */
  import mx.effects.Fade;
  import mx.core.UIComponent;
  import flash.utils.Dictionary;

  public class Comparator
  {
    public function Comparator()
    {
      comparatorContents = new Dictionary();
      filterProperties = new Object();
    }

    /**
     * Registers a filter object with its visual representation.
     *
     * @description
     * The visual representation can be stored i.e. if you want to apply a
     * default effect via the applyAlphaEffect method of Comparator or can be null if
     * you use Comparator as in the second example of this class documentation.
     *
     * @param sprite The visual representation can be a component.
     * It must inherit from UIComponent. (Note: all Flex components inherit from UIComponent)
     *
     * @param comparable see class documentation.
     */
    public function addComparable( sprite : UIComponent, comparable : Comparable ) : void
    {
      var key : String = comparable.identifier;
      /*
      re-register a comparable object if the visual representation (sprite) has changed.
      i.e. a TileList component swaps between sprites at runtime for better performance.
      A cell renderer's setValue method could call this method.
      */
      if( ! comparatorContents[ key ] || comparatorContents[ key ].sprite != sprite )
      {
        comparatorContents[ key ] = new Object();
        comparatorContents[ key ].comparable = comparable;
        comparatorContents[ key ].sprite = sprite;
        comparatorContents[ key ].isFiltered = false;
        comparatorContents[ key ].hasChanged = false;
      }
    }

    /**
     * Removes a registered filter object.
     *
     * @param comparable see class documentation.
     */
    public function deleteComparable( comparable : Comparable ) : void
    {
      var key : String = comparable.identifier;
      delete comparatorContents[ key ];
    }

    /**
     * Registers a property of a filter object with its minimun and maximum values
     * that represent a numerical range.
     *
     * @description
     * see class documentation for an example.
     *
     * @param filterProperty The property to compare.
     * @param min represents the minimum value of a range.
     * @param min represents the maximum value of a range.
     */
    public function addFilterRangeProperty( filterProperty : String,  min : Number, max : Number ) : void
    {
      filterProperties[ filterProperty ] = new Object();
      filterProperties[ filterProperty ].min = min;
      filterProperties[ filterProperty ].max = max;
    }

    /**
     * Registers a property of a filter object with its selections
     * that represent a selection.
     *
     * @description
     * see class documentation for an example.
     *
     * @param filterProperty The property to compare.
     * @param selections represents the selected (unfiltered) values of the filter property.
     */
    public function addFilterSelectionProperty( filterProperty : String, selections : Array ) : void
    {
      filterProperties[ filterProperty ] = new Object();
      filterProperties[ filterProperty ].selections = selections;
    }

    /**
     * Removes a registered filter property.
     *
     * @param comparable see class documentation.
     */
    public function deleteFilterProperty( filterProperty : String ) : void
    {
      delete filterProperties[ filterProperty ];
    }

    /**
     * The actual filtering process happens here.
     * @description
     * see class documentation for an example.
     */
    public function filter() : void
    {
      for ( var key : String in comparatorContents )
      {
        var comparatorObject : Object = comparatorContents[ key ];
        var comparable : Comparable = comparatorObject.comparable;
        var isFiltered : Boolean = false;

        for ( var filterProperty : String in filterProperties )
        {
          var filterPropertiesObject : Object = filterProperties[ filterProperty ];
          var selections : Array = filterPropertiesObject.selections;
          var min : Number = filterPropertiesObject.min;
          var max : Number = filterPropertiesObject.max;

          if( selections != null )
          {
            if( !hasValue( selections, comparable[ filterProperty ] ) )
            {
              isFiltered = true;
            }
          }
          else
          {
            if( isOutOfRange( comparable[ filterProperty ], min, max ) )
            {
              isFiltered = true;
            }
          }

          if( isFiltered != comparatorObject.isFiltered )
          {
            comparatorObject.hasChanged = true;
            comparatorObject.isFiltered = isFiltered;
            break;
          }
        }
      }
    }

    /**
     * A default implementation of a fade in / out of registered visual representations of filter objects.
     * @description
     * see class documentation for an example.
     */
    public function applyAlphaEffect() : void
    {
      for ( var key : String in comparatorContents )
      {
        var comparatorObject : Object = comparatorContents[ key ];
        var sprite : UIComponent = comparatorObject.sprite;

        if( comparatorObject.hasChanged )
        {
          comparatorObject.hasChanged = false;

          if( comparatorObject.isFiltered )
          {
            hide( sprite );
          }
          else
          {
            show( sprite );
          }
        }
      }
    }

    /**
     * Tells if a specific filter object is filtered.
     * @returns <code>true</code> if filtered, <code>false</code> if not filtered.
     */
    public function isFiltered( comparable : Comparable ) : Boolean
    {
      var key : String = comparable.identifier;
      return comparatorContents[ key ].isFiltered;
    }

    /**
     * Retrieves all unfiltered filter objects.
     * @description
     * see second example of class documentation for an example.
     */
    public function getUnfilteredComparables() : Array
    {
      var comparable : Array = new Array();
      for ( var key : String in comparatorContents )
      {
        var comparatorObject : Object = comparatorContents[ key ];
        if( !comparatorObject.isFiltered )
        {
          comparable.push( comparatorObject.comparable );
        }
      }
      return comparable;
    }

    /**
     * Retrieves all filtered filter objects.
     */
    public function getFilteredComparables() : Array
    {
      var comparable : Array = new Array();
      for ( var key : String in comparatorContents )
      {
        var comparatorObject : Object = comparatorContents[ key ];
        if( comparatorObject.isFiltered )
        {
          comparable.push( comparatorObject.comparable );
        }
      }
      return comparable;
    }

    private function hide( sprite : UIComponent ) : void
    {
      var e : Fade = new Fade( sprite );
      e.alphaFrom = 1;
      e.alphaTo = 0.25;
      e.duration = 300;
      e.play();
    }

    private function show( sprite : UIComponent ) : void
    {
      var e : Fade = new Fade( sprite );
      e.alphaFrom = 0.25;
      e.alphaTo = 1;
      e.duration = 300;
      e.play();
    }

    private function hasValue( selections : Array, comparableValue : Object ) : Boolean
    {
      var i : Number = selections.length;
      while( i-- )
      {
        if( selections[ i ] == comparableValue )
        {
          return true;
        }
      }
      return false;
    }

    private function isOutOfRange( comparableValue : Number, min : Number, max : Number ) : Boolean
    {
      if ( comparableValue < min )
      {
        return true;
      }
      if( comparableValue > max )
      {
        return true;
      }
      return false;
    }

    /**
     * Access to all information of a filter object that are compared.
     * @description The comparatorContents property gives access to a hash map, keyed
     * by the unique identifiers of the filter objects. The key returns an object with
     * the following properties.
     * <p>
     * <ul>
     * <li>comparable (Comparator) - The actual filter object (could be a Value Object).</li>
     * <li>sprite (UIComponent) - The visual representation of the filter object of comparable. Could be a Flex component.</li>
     * <li>isFiltered (Boolean) - A flag if the comparable if filtered.</li>
     * <li>hasChanged (Boolean) - A flag if the comparable's filtered state has changed
     * since the last call to the filter method. Used by applyAlphaEffect().</li>
     * </ul>
     * </p>
     */
    public var comparatorContents : Dictionary;

    /**
     * Access to all information of filter properties that are compared.
     * @description The filterProperties property gives access to a hash map, keyed
     * by filter properties of the filter objects. The key returns an object with
     * the following properties. If the property is compared by range, then the object
     * returns the following properties:
     * <p>
     * <ul>
     * <li>min (Number) - see addFilterRangeProperty().</li>
     * <li>max (Number) - see addFilterRangeProperty().</li>
     * </ul>
     * </p>
     * If the property is compared by selections, the object contains a single property.
     * <p>
     * <ul>
     * <li>selections (Array) - see addFilterSelectionProperty().</li>
     * </ul>
     * </p>
     */
    public var filterProperties : Object;
  }
}
