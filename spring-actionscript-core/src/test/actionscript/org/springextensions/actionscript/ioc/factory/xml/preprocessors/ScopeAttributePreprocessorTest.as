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

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class ScopeAttributePreprocessorTest extends TestCase {

    public function ScopeAttributePreprocessorTest(methodName:String=null) {
      super(methodName);
    }

    public function testPreprocess_shouldAddScopeAttributeAsSingletonIfSingletonAttributeIsTrue():void {
      var p:ScopeAttributePreprocessor = new ScopeAttributePreprocessor();
      var xml:XML =  <objects>
                <object class="Object" singleton="true"/>
              </objects>;
      xml = p.preprocess(xml);
      var node:XML = xml.children()[0];
      assertTrue(node.@scope == "singleton");
      assertTrue(node.@singleton == undefined);
    }

    public function testPreprocess_shouldAddScopeAttributeAsPrototypeIfSingletonAttributeIsFalse():void {
      var p:ScopeAttributePreprocessor = new ScopeAttributePreprocessor();
      var xml:XML =  <objects>
                <object class="Object" singleton="false"/>
              </objects>;
      xml = p.preprocess(xml);
      var node:XML = xml.children()[0];
      assertTrue(node.@scope == "prototype");
      assertTrue(node.@singleton == undefined);
    }

    public function testPreprocess_shouldAddScopeAttributeAsSingletonIfSingletonAttributeIsNotSpecified():void {
      var p:ScopeAttributePreprocessor = new ScopeAttributePreprocessor();
      var xml:XML =  <objects>
                <object class="Object"/>
              </objects>;
      xml = p.preprocess(xml);
      var node:XML = xml.children()[0];
      assertTrue(node.@scope == "singleton");
      assertTrue(node.@singleton == undefined);
    }

  }
}
