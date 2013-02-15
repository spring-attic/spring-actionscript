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
package org.springextensions.actionscript.objects {
	
	//import flash.system.ApplicationDomain;
	import flash.system.ApplicationDomain;

 	import flexunit.framework.TestCase;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class SimpleTypeConverterTest extends TestCase {

    private var _converter:ITypeConverter;

    public function SimpleTypeConverterTest(methodName:String=null) {
      super(methodName);
    }

    override public function setUp():void {
      _converter = new SimpleTypeConverter(ApplicationDomain.currentDomain);
    }

    public function testConvertIfNecessary_forBoolean():void {
      assertTrue(_converter.convertIfNecessary("true", Boolean));
      assertTrue(_converter.convertIfNecessary("TRUE", Boolean));
      assertFalse(_converter.convertIfNecessary("false", Boolean));
      assertFalse(_converter.convertIfNecessary("FALSE", Boolean));
    }

    public function testConvertIfNecessary_forNumber():void {
      assertEquals(5, _converter.convertIfNecessary("5", Number));
      assertEquals(5.56, _converter.convertIfNecessary("5.56", Number));
      assertEquals(-13, _converter.convertIfNecessary("-13", Number));
      assertEquals(-13.321, _converter.convertIfNecessary("-13.321", Number));
    }

    public function testConvertIfNecessary_withClass():void {
      assertEquals(TestCase, _converter.convertIfNecessary("flexunit.framework.TestCase", Class));
    }

  }
}
