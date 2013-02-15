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
  import flash.events.IEventDispatcher;

  import org.springextensions.actionscript.context.IConfigurableApplicationContext;
  import org.puremvc.as3.interfaces.IFacade;

  /**
   * Interface definition for IoC capable (Prana powered) PureMVC facade.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.4
   * </p>
   */
  public interface IIocFacade extends IFacade, IEventDispatcher {
    function get container():IConfigurableApplicationContext;
    function registerProxyByConfigName(p_proxyName:String):void;
    function registerMediatorByConfigName(p_mediatorName:String, p_viewComponent:Object = null):void;
    function registerCommandByConfigName(p_noteName:String, p_configName:String):void;
  }
}
