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
package org.springextensions.actionscript.utils {

  import flash.system.ApplicationDomain;
  
  import flexunit.framework.TestCase;
  
  import mx.logging.LogEventLevel;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class TypeConverterTest extends TestCase {

		public function TypeConverterTest(methodName:String = null) {
			super(methodName);
		}

    public function testExecuteWithClass():void {
      var value:Class = TypeConverter.execute("flexunit.framework.TestCase",ApplicationDomain.currentDomain);
      assertEquals(TestCase, value);
    }

    public function testExecuteWithConstant():void {
      var value:int = TypeConverter.execute("mx.logging.LogEventLevel.DEBUG",ApplicationDomain.currentDomain);
      assertEquals(LogEventLevel.DEBUG, value);
    }

    public function testExecuteWithString():void {
      var s:String = "This is a string";
      var result:String = TypeConverter.execute(s,ApplicationDomain.currentDomain);
      assertEquals(s, result);
    }

  }
}
