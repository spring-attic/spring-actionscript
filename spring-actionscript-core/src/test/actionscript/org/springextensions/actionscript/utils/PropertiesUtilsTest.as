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

  import flexunit.framework.TestCase;

  import org.springextensions.actionscript.collections.Properties;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class PropertiesUtilsTest extends TestCase {

    public function PropertiesUtilsTest(methodName:String=null) {
      super(methodName);
    }

    public function testGetProperty():void {
      var p1:Properties = new Properties();
      p1.setProperty("a", "value a");
      p1.setProperty("b", "value b");

      var p2:Properties = new Properties();
      p2.setProperty("c", "value c");
      p2.setProperty("d", "value d");

      var result:String = PropertiesUtils.getProperty([p1, p2], "a");
      assertEquals("value a", result);

      result = PropertiesUtils.getProperty([p1, p2], "d");
      assertEquals("value d", result);

      result = PropertiesUtils.getProperty([p1, p2], "e");
      assertNull(result);

      result = PropertiesUtils.getProperty([p1, p2], "");
      assertNull(result);

      result = PropertiesUtils.getProperty([p1, p2], null);
      assertNull(result);
    }

  }
}
