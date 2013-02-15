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
package {

  import flexunit.framework.Test;
  import flexunit.framework.TestSuite;

  import org.springextensions.actionscript.puremvc.patterns.IocFacadeTest;
  import org.springextensions.actionscript.puremvc.patterns.IocFacadeWithoutConfigTest;

  /**
   * <p>
   * <b>Author:</b> Christophe Herreman<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (Sat, 01 Nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.1
   * </p>
   */
  public class AllTests {
    public static function suite():Test {
      var testSuite:TestSuite = new TestSuite();

      // puremvc.patterns
      testSuite.addTest(new TestSuite(IocFacadeTest));
      testSuite.addTest(new TestSuite(IocFacadeWithoutConfigTest));

      return testSuite;
    }
  }
}
