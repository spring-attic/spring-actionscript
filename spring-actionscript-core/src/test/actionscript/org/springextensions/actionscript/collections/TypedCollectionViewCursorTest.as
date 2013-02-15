/*
 * Copyright 2007-2008 the original author or authors.
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

  import flexunit.framework.TestCase;
  import mx.collections.IViewCursor;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class TypedCollectionViewCursorTest extends TestCase {

    private var _collection:TypedCollection;
    private var _cursor:IViewCursor;

    public function TypedCollectionViewCursorTest(methodName:String = null) {
      super(methodName);
    }

    override public function setUp():void {
      _collection = new TypedCollection(String);
      _collection.addItem("string1");
      _collection.addItem("string2");
      _cursor = _collection.createCursor();
    }

    public function testInsertWithCorrectType():void {
      _cursor.insert("test");
    }

    public function testInsertWithWrongType():void {
      try {
        _cursor.insert(23);
        fail("Expecting error when inserting a numeric value in a String collection");
      }
      catch(e:Error) {}
    }

  }
}
