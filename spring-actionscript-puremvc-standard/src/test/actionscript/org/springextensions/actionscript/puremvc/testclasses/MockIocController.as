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
package org.springextensions.actionscript.puremvc.testclasses {
  import flash.utils.Dictionary;

  import org.springextensions.actionscript.context.support.XMLApplicationContext;
  import org.springextensions.actionscript.ioc.factory.support.AbstractObjectFactory;
  import org.springextensions.actionscript.puremvc.core.controller.IocController;
  import org.springextensions.actionscript.puremvc.interfaces.IIocController;

  /**
   * Sample <code>IIocController</code> implementation used in tests.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class MockIocController extends IocController {
    public function MockIocController(p_iocFactory:AbstractObjectFactory) {
      super(p_iocFactory);
    }

    public static function getInstance(p_iocFactory:AbstractObjectFactory):IIocController {
      if (m_instance == null) {
        m_instance = new MockIocController(p_iocFactory);
      }

      return m_instance;
    }

    public static function destory():void {
      m_instance = null;
    }

    public function getCommandMap():Array {
      return m_commandMap;
    }

    public function getIocCommandMap():Array {
      return m_iocCommandMap;
    }

    public function getCommandNamesMap():Dictionary {
      return m_commandNamesMap;
    }
  }
}
