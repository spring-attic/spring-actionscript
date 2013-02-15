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
package org.springextensions.actionscript.puremvc.interfaces {
  /**
   * Defines setter and getter for a configuration name for ioc puremvc constructs. This enables ioc facade and its
   * containing prana container, to inject configuration names (values of id property) in ioc puremvc elements like
   * <code>IIocProxy</code>, <code>IIocMediator</code> and <code>IIocFacade</code>.
   * <p>
   * Setter method from this interface is intended to be used internally from ioc facade. It should not be used by
   * clients.
   * </p>
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public interface IIocConfigNameAware {
    /**
     * This function should not be used by clients. It is invoked internally by ioc facade when appropriate.
     */
    function setConfigName(p_proxyConfigName:String):void;

    function getConfigName():String;
  }
}
