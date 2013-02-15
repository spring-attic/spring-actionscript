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
  import org.springextensions.actionscript.context.support.XMLApplicationContext;
  import org.springextensions.actionscript.puremvc.patterns.facade.IocFacade;
  import org.puremvc.as3.interfaces.IController;

  /**
   * Sample <code>IIocFacade</code> implementation used in tests.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class MockIocFacade extends IocFacade {
    public function MockIocFacade(p_configSource:Object = null) {
      super(p_configSource);
    }

    public function getController():IController {
      return controller;
    }

    public function getXmlApplicationContext():XMLApplicationContext {
      return m_applicationContext;
    }

    override protected function initializeController():void {
      controller = MockIocController.getInstance(m_applicationContext);
    }

    public static function destroy():void {
      MockIocController.destory();
      instance = null;
    }

    public static function getInstance():MockIocFacade {
      return instance as MockIocFacade;
    }
  }
}
