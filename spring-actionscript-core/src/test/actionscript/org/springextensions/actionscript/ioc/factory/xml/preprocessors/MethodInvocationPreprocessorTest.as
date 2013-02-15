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
package org.springextensions.actionscript.ioc.factory.xml.preprocessors {

  import flexunit.framework.TestCase;

  import org.springextensions.actionscript.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class MethodInvocationPreprocessorTest extends TestCase {

    public function MethodInvocationPreprocessorTest(methodName:String=null) {
      super(methodName);
    }

    public function testPreprocess():void {
      var xml:XML =  <objects>
                <object id="myObject">
                  <method-invocation name="myMethod">
                    <arg>
                      <object id="myObject2">
                        <method-invocation name="myMethod2">
                          <arg>
                            <object/>
                          </arg>
                          <arg>
                            <array/>
                          </arg>
                        </method-invocation>
                      </object>
                    </arg>
                    <arg>
                      <array/>
                    </arg>
                  </method-invocation>
                </object>
              </objects>;

      var p:IXMLObjectDefinitionsPreprocessor = new MethodInvocationPreprocessor();
      xml = p.preprocess(xml);

      assertNotNull(xml);

      var nodes:XMLList = xml..object.(attribute("class") == "org.springextensions.actionscript.ioc.factory.MethodInvokingObject");
      assertEquals(2, nodes.length());
    }

  }
}
