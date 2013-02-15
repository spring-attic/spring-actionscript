/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 package org.springextensions.actionscript.collections {
 	
  import flash.events.EventDispatcher;
  import mx.collections.ArrayCollection;
  import mx.collections.CursorBookmark;
  import mx.collections.ICollectionView;
  import mx.collections.IViewCursor;

	/**
	 * Dispatched when the current <code>MapViewCursor</code> is updated.
	* @eventType mx.events.FlexEvent.CURSOR_UPDATE
	*/
  [Event(name="cursorUpdate", type="mx.events.FlexEvent")]
  /**
   * Map view cursor.
   * <p>
   * <b>Authors:</b> Christophe Herreman, Bert Vandamme<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class MapViewCursor extends EventDispatcher implements IViewCursor {

    /**
     * Creates a new <code>MapViewCursor</code> for the specified <code>IMap</code> instance.
     * @param view the specified <code>IMap</code> instance.
     */
    public function MapViewCursor(view:IMap) {
      super(this);
      _cursor = new ArrayCollection(view.values).createCursor();
    }
    //private var _arrayCollection:ArrayCollection;
    private var _cursor:IViewCursor;

    [Bindable("cursorUpdate")]
    public function get afterLast():Boolean {
      return _cursor.afterLast;
    }

    [Bindable("cursorUpdate")]
    public function get beforeFirst():Boolean {
      return _cursor.beforeFirst;
    }

    [Bindable("cursorUpdate")]
    public function get bookmark():CursorBookmark {
      return _cursor.bookmark;
    }

    [Bindable("cursorUpdate")]
    public function get current():Object {
      return _cursor.current;
    }

    public function findAny(values:Object):Boolean {
      return _cursor.findAny(values);
    }

    public function findFirst(values:Object):Boolean {
      return _cursor.findFirst(values);
    }

    public function findLast(values:Object):Boolean {
      return _cursor.findLast(values);
    }

    public function insert(item:Object):void {
      _cursor.insert(item);
    }

    public function moveNext():Boolean {
      return _cursor.moveNext();
    }

    public function movePrevious():Boolean {
      return _cursor.movePrevious();
    }

    public function remove():Object {
      return _cursor.remove();
    }

    public function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0):void {
      _cursor.seek(bookmark, offset, prefetch);
    }

    public function get view():ICollectionView {
      return _cursor.view;
    }
  }
}
