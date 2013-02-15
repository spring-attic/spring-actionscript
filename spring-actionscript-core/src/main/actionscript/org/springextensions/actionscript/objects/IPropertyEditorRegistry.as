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
package org.springextensions.actionscript.objects {

  /**
   * Defines a registry for property editors.
   *
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public interface IPropertyEditorRegistry {

    /**
     * Registers the given property editor for the given type.
     *
     * @param requiredType the type of the property
     * @param propertyEditor the property editor to register
     */
    function registerCustomEditor(requiredType:Class, propertyEditor:IPropertyEditor):void;

    /**
     * Finds a property editor that was registered against the given type.
     *
     * @param requiredType the type of the property
     */
    function findCustomEditor(requiredType:Class):IPropertyEditor;
  }
}
