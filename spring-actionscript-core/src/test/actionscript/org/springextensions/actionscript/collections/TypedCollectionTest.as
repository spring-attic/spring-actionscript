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

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class TypedCollectionTest extends TestCase {

    public function TypedCollectionTest(methodName:String = null) {
      super(methodName);
    }

    public function testNew():void {
      var typedCollection:TypedCollection = new TypedCollection(String);
      assertEquals(0, typedCollection.length);
    }

    public function testAddItem():void {
      var typedCollection:TypedCollection = new TypedCollection(String);
      assertEquals(0, typedCollection.length);
      var s:String = "test";
      typedCollection.addItem(s);
      assertEquals(1, typedCollection.length);
    }


    public function testRemoveItemAt():void {
      var typedCollection:TypedCollection = new TypedCollection(String);
      assertEquals(0, typedCollection.length);
      var s1:String = "string1";
      var s2:String = "string2";
      typedCollection.addItem(s1);
      typedCollection.addItem(s2);
      assertEquals(2, typedCollection.length);
      typedCollection.removeItemAt(typedCollection.length - 1);
      assertEquals(1, typedCollection.length);
      typedCollection.removeItemAt(typedCollection.length - 1);
      assertEquals(0, typedCollection.length);
    }

    public function testRemoveItem():void {
      var typedCollection:TypedCollection = new TypedCollection(String);
      assertEquals(0, typedCollection.length);
      var s1:String = "string1";
      var s2:String = "string2";
      typedCollection.addItem(s1);
      typedCollection.addItem(s2);
      assertEquals(2, typedCollection.length);
      typedCollection.removeItem(s2);
      assertEquals(1, typedCollection.length);
      typedCollection.removeItem(s1);
      assertEquals(0, typedCollection.length);
    }

  }
}
