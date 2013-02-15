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
  
  import org.springextensions.actionscript.cairngorm.AbstractResponderTest;
  import org.springextensions.actionscript.cairngorm.EventSequenceTest;
  import org.springextensions.actionscript.cairngorm.SequenceEventTest;
  import org.springextensions.actionscript.cairngorm.business.AbstractBusinessDelegateTest;
  import org.springextensions.actionscript.cairngorm.business.AbstractDataTranslatorAwareBusinessDelegateTest;
  import org.springextensions.actionscript.cairngorm.business.BusinessDelegateFactoryTest;
  import org.springextensions.actionscript.cairngorm.business.CairngormServiceLocatorTest;
  import org.springextensions.actionscript.cairngorm.commands.AbstractResponderCommandTest;
  import org.springextensions.actionscript.cairngorm.commands.CommandFactoryTest;
  import org.springextensions.actionscript.cairngorm.commands.ResponderCommandFactoryTest;
  import org.springextensions.actionscript.cairngorm.control.CairngormFrontControllerTest;

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

      // cairngorm
      testSuite.addTest(new TestSuite(AbstractResponderTest));
      testSuite.addTest(new TestSuite(EventSequenceTest));
      testSuite.addTest(new TestSuite(SequenceEventTest));
	  testSuite.addTest(new TestSuite(CairngormFrontControllerTest)); 
	  testSuite.addTest(new TestSuite(CommandFactoryTest));
	  testSuite.addTest(new TestSuite(AbstractResponderCommandTest));
	  testSuite.addTest(new TestSuite(ResponderCommandFactoryTest));
	  testSuite.addTest(new TestSuite(AbstractBusinessDelegateTest));
	  testSuite.addTest(new TestSuite(AbstractDataTranslatorAwareBusinessDelegateTest));
	  testSuite.addTest(new TestSuite(BusinessDelegateFactoryTest));
	  testSuite.addTest(new TestSuite(CairngormServiceLocatorTest));

      return testSuite;
    }

  }
}
