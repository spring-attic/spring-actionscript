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
  public class MapTest extends TestCase {

    public function MapTest(methodName:String = null) {
      super(methodName);
    }

    public function testGet():void {
      var key1:Object = {};
      var key2:Object = {};
      var map:IMap = new Map();
      map[key1] = "a";
      map[key2] = "b";
      assertEquals("a", map.get(key1));
      assertEquals("b", map.get(key2));
    }

    public function testGetProperty():void {
      var key1:Object = {};
      var key2:Object = {};
      var map:IMap = new Map();
      map[key1] = "a";
      map[key2] = "b";
      assertEquals("a", map[key1]);
      assertEquals("b", map[key2]);
    }

    public function testPut():void {
      var map:IMap = new Map();
      map.put({}, "a");
      assertEquals(1, map.size);
      map.put({}, "b");
      assertEquals(2, map.size);
    }

    public function testSetProperty():void {
      var map:Map = new Map();
      map["a"] = "a";
      assertEquals(1, map.size);
      map["b"] = "b";
      assertEquals(2, map.size);
    }

    public function testDeleteProperty():void {
      var key:Object = {a:"b"};
      var value:String = "value";
      var map:IMap = new Map();
      map[key] = value;
      delete map[key];
      assertNull(map[key]);
    }

    public function testRemove():void {
      var key:Object = {a:"b"};
      var value:String = "a value";
      var map:IMap = new Map();
      map.put(key, value);
      var removedValue:String = map.remove(key);
      assertEquals(value, removedValue);
      assertNull(map[key]);
    }

    public function testClear():void {
      var map:IMap = new Map();
      map.put("a", 1);
      map.clear();
      assertEquals(0, map.size);
    }

  }
}