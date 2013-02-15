/*
 * Copyright 2007-2011 the original author or authors.
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
package org.springextensions.actionscript.context.support {

  import org.as3commons.lang.Assert;
  import org.springextensions.actionscript.context.IApplicationContext;
  import org.springextensions.actionscript.context.IApplicationContextAware;
  import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;

  /**
   * <code>IObjectPostProcessor</code> implementation that checks for objects that implement the <code>IApplicationContextAware</code>
   * interface and injects them with the provided <code>IApplicationContext</code> instance.
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   * @inheritDoc
   */
  public class ApplicationContextAwareProcessor implements IObjectPostProcessor {

    private var _applicationContext:IApplicationContext;

    /**
     * Creates a new <code>ApplicationContextAwareProcessor</code> instance.
     * @param applicationContext The <code>IApplicationContext</code> instance that will be injected.
     */
    public function ApplicationContextAwareProcessor(applicationContext:IApplicationContext) {
    	Assert.notNull(applicationContext,"applicationContext argument must not be null");
		_applicationContext = applicationContext;
    }

    /**
     * <p>If the specified object implements the <code>IApplicationContextAware</code> interface
     * the <code>IApplicationContext</code> instance is injected.</p>
     * @inheritDoc
     */
    public function postProcessBeforeInitialization(object:*, objectName:String):* {
		var applicationContextAware:IApplicationContextAware = (object as IApplicationContextAware);
		if ((applicationContextAware != null) && (applicationContextAware.applicationContext == null)){
			applicationContextAware.applicationContext = _applicationContext;
		}
		return object;
    }

    /**
     * @inheritDoc
     */
    public function postProcessAfterInitialization(object:*, objectName:String):* {
		return object;
    }
  }
}
