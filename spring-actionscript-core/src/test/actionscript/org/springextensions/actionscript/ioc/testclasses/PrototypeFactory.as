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
package org.springextensions.actionscript.ioc.testclasses {

  /**
   * This simple test class represents a stripped-down version of a configurable-factory
   * I am using in one of my applications. I inject the fully-qualified class name through
   * a context, and then at runtime the factory will build objects of this type.
   *
   * Recently, this factory broke - this simple factory is provided as a way to make sure
   * that we don't clobber classes that get injected as string values.
   *
   * <p>
   * <b>Author:</b> Ryand Gardner<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class PrototypeFactory {

    private var _classToConstruct:Class;

    public function PrototypeFactory() {
      // no constructor
    }

    public function set classNameToConstruct(clazz:Class):void {
      this._classToConstruct = clazz as Class;
    }

    public function get classNameToConstruct():Class {
      return this._classToConstruct;
    }
  }
}
