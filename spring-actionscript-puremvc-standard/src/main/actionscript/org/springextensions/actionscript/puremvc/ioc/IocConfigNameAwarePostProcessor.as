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
package org.springextensions.actionscript.puremvc.ioc {
  import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;
  import org.springextensions.actionscript.puremvc.interfaces.IIocConfigNameAware;

  /**
   * Object post processor which injects configuration name in all <code>IIocConfigNameAware</code> instances available
   * in container.
   * <p>
   * This post processor is used by default in IocFacade implementation. If this is not desired, one can override
   * <code>IocFacade.getObjectPostProcessors()</code> method.
   * </p>
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   *
   * @see org.springextensions.actionscript.puremvc.interfaces.IIocConfigNameAware
   * @see org.springextensions.actionscript.puremvc.patterns.facade.IocFacade#getObjectPostProcessors()
   */
  public class IocConfigNameAwarePostProcessor implements IObjectPostProcessor {
    public function IocConfigNameAwarePostProcessor() {
    }

    public function postProcessBeforeInitialization(p_object:*, p_objectName:String):* {
      if (p_object is IIocConfigNameAware) {
        (p_object as IIocConfigNameAware).setConfigName(p_objectName);
      }

      return p_object;
    }

    public function postProcessAfterInitialization(p_object:*, p_objectName:String):* {
      return p_object;
    }
  }
}

