/*
 * Copyright 2007-2010 the original author or authors.
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

  /**
   * Defines an object that contains key/value pairs. It cannot contain duplicate keys
   * and each key can only contain one correspoding value.
   * <p>
   * <b>Authors:</b> Christophe Herreman, Damir Murat<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public interface IMap {

    /**
     * Removes all key/value pairs from the map.
     */
    function clear():void;

    /**
     * Returns the number of key/value pairs in the map.
     *
     * @return the number of key/value pairs in the map
     */
    function get size():uint;

    /**
     * Returns an array of all values in the map. If no values exist in
     * the map, then an empty Array instance will be returned.
     *
     * @return an array of all values in the map
     */
    function get values():Array;

    /**
     * Adds an object to the map and associates it with the specified key.
     */
    function put(key:Object, value:Object):void;

    /**
     * Returns the value in the map associated with the specified key.
     */
    function get(key:Object):*;

    /**
     * Removes the mapping for this key from this map if it is present.
     *
     * Returns the value to which the map previously associated the key,
     * or null if the map contained no mapping for this key.
     * (A null return can also indicate that the map previously associated
     * null with the specified key if the implementation supports null
     * values.) The map will not contain a mapping for the specified key
     * once the call returns.
     *
     * @param key the key whose mapping is to be removed from the map
     * @return previous value associated with specified key, or null if
     * there was no mapping for key
     */
    function remove(key:Object):*;
  }
}
