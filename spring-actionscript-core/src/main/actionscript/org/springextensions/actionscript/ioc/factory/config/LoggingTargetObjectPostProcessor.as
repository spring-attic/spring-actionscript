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

  import mx.logging.ILoggingTarget;
  import mx.logging.Log;

  /**
   * Object post processor for ILoggingTarget implementations that will add all ILoggingTarget objects found in the
   * application context to the Log via "addTarget".
   *
   * This post processor is added to the FlexXMLApplicationContext by default and is hence Flex specific.
   *
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 21 $, $Date: 2008-11-01 22:58:42 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class LoggingTargetObjectPostProcessor implements IObjectPostProcessor {

    /**
     * Creates a new LoggingTargetObjectPostProcessor.
     */
    public function LoggingTargetObjectPostProcessor() {
    }

    /**
	 * No before initialization is performed
 	 * @inheritDoc
     */
    public function postProcessBeforeInitialization(object:*, objectName:String):* {
      return null;
    }

    /**
     * If the specified object implements the <code>ILoggingTarget</code> interface
     * the object is added as a logging target.
     * @inheritDoc
     */
    public function postProcessAfterInitialization(object:*, objectName:String):* {
      if (object is ILoggingTarget) {
        Log.addTarget(ILoggingTarget(object));
      }
    }
  }
}
