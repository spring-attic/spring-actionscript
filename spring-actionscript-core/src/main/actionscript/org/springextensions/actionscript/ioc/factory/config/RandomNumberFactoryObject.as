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
package org.springextensions.actionscript.ioc.factory.config {

  import org.springextensions.actionscript.ioc.factory.IFactoryObject;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class RandomNumberFactoryObject implements IFactoryObject {

    /**
     * Constructs a new RandomNumberFactoryObject instance
     */
    public function RandomNumberFactoryObject() {
      // nothing
    }

    /**
     * Generates a random number using <code>Math.random()</code> and returns the result
     * @inheritDoc
     */
    public function getObject():* {
      return Math.random();
    }

    /**
     * @inheritDoc
     */
    public function getObjectType():Class {
      return Number;
    }

    /**
     * @inheritDoc
     */
    public function get isSingleton():Boolean {
      return false;
    }
  }
}
