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
package org.springextensions.actionscript.puremvc.patterns {
  import flash.events.Event;
  import flash.utils.Dictionary;

  import flexunit.framework.TestCase;

  import org.as3commons.lang.IllegalStateError;
  import org.springextensions.actionscript.puremvc.interfaces.IIocFacade;
  import org.springextensions.actionscript.puremvc.patterns.facade.IocFacade;
  import org.springextensions.actionscript.puremvc.testclasses.SampleIocCommand;
  import org.springextensions.actionscript.puremvc.testclasses.SampleIocMediator;
  import org.springextensions.actionscript.puremvc.testclasses.SampleIocProxy;
  import org.springextensions.actionscript.puremvc.testclasses.MockIocController;
  import org.springextensions.actionscript.puremvc.testclasses.MockIocFacade;
  import org.puremvc.as3.interfaces.IMediator;
  import org.puremvc.as3.interfaces.IProxy;

  /**
   * Tests for <code>IocFacade</code> class without supplied configuration files.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class IocFacadeWithoutConfigTest extends TestCase {
    private static const SAMPLE_PROXY_NAME:String = "sampleProxyName";
    private static const SAMPLE_MEDIATOR_NAME:String = "sampleMediatorName";
    private static const NOTIFICATION:String = "notification";
    private static const MAPPED_COMMAND_NAME:String = "mappedCommandName";
    private static const MAPPED_COMMAND_TARGET:String = "mappedCommandTarget";

    public function testConstructor():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();
      assertNotNull(iocFacade);

      MockIocFacade.destroy();
    }

    public function testRegisterProxy():void {
      // Destroy first to prevent errors when other tests fail with exceptions without completing fully.
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();
      var sampleProxy:IProxy = new SampleIocProxy(SAMPLE_PROXY_NAME);

      // First run
      iocFacade.registerProxy(sampleProxy);
      assertNotNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      iocFacade.registerProxy(sampleProxy);
      assertNotNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      // Cleanup, although this is not necessary if all other methods will use same statement on its start.
      MockIocFacade.destroy();
    }

    public function testRemoveProxy():void {
      MockIocFacade.destroy();

      var proxyOne:IProxy;
      var proxyTwo:IProxy;

      var iocFacade:IIocFacade = new MockIocFacade();

      proxyOne = new SampleIocProxy(SAMPLE_PROXY_NAME, null);
      iocFacade.registerProxy(proxyOne);
      proxyTwo = iocFacade.retrieveProxy(SAMPLE_PROXY_NAME);
      assertNotNull(proxyTwo);
      assertEquals(proxyOne, proxyTwo);

      proxyOne = iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNotNull(proxyOne);
      assertEquals(proxyOne, proxyTwo);
      assertNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      MockIocFacade.destroy();
    }

    public function testRegisterMediator():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();

      var sampleMediator:IMediator = new SampleIocMediator(SAMPLE_MEDIATOR_NAME);

      // First run
      iocFacade.registerMediator(sampleMediator);
      assertNotNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      iocFacade.registerMediator(sampleMediator);
      assertNotNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      MockIocFacade.destroy();
    }

    public function testRemoveMediator():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();

      var mediatorOne:IMediator = new SampleIocMediator(SAMPLE_MEDIATOR_NAME, null);
      var mediatorTwo:IMediator;

      iocFacade.registerMediator(mediatorOne);
      mediatorTwo = iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME);
      assertNotNull(mediatorTwo);
      assertEquals(mediatorOne, mediatorTwo);
      assertEquals(mediatorTwo.getMediatorName(), SAMPLE_MEDIATOR_NAME);

      mediatorOne = iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNotNull(mediatorOne);
      assertEquals(mediatorOne.getMediatorName(), SAMPLE_MEDIATOR_NAME);
      assertEquals(mediatorOne, mediatorTwo);
      assertNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      MockIocFacade.destroy();
    }

    public function testRegisterCommand():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();

      // First run
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      MockIocFacade.destroy();
    }

    /**
     * Test initialization of IoC container after initial facade's creation without configuration, and then tries to
     * initialize IoC container again which must fail.
     */
    public function testInitializeIocContainer():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();

      iocFacade.addEventListener(Event.COMPLETE, addAsync(onTestReconfigureComplete, 1000));
      (iocFacade as IocFacade).initializeIocContainer("puremvc-applicationContext.xml");
    }

    public function onTestReconfigureComplete(p_event:Event):void {
      var iocFacade:IIocFacade = MockIocFacade.getInstance();
      iocFacade.removeEventListener(Event.COMPLETE, onTestReconfigureComplete);

      // Once intialized, ioc container can't be initialized again.
      try {
        (iocFacade as IocFacade).initializeIocContainer("puremvc-applicationContext.xml");
        fail();
      }
      catch (error:IllegalStateError) {
        assertTrue(true);
      }

      MockIocFacade.destroy();
    }

    public function testControllerCommandNamesMapConfiguration_AfterExplicitInitialization():void {
      MockIocFacade.destroy();

      var configSource:XML =
        <objects>
          <object id="sampleProxyConfigName" class="org.springextensions.actionscript.puremvc.testclasses.SampleIocProxy"/>
          <object id="sampleMediatorConfigName" class="org.springextensions.actionscript.puremvc.testclasses.SampleIocMediator"/>
          <object id="sampleCommandConfigName" class="org.springextensions.actionscript.puremvc.testclasses.SampleIocCommand"/>

          <!-- proxy names map (magic name object) -->
          <object id="proxyNamesMap" class="flash.utils.Dictionary">
            <property name="mappedProxyName" value="mappedProxyTarget"/>
          </object>

          <!-- mediator names map (magic name object) -->
          <object id="mediatorNamesMap" class="flash.utils.Dictionary">
            <property name="mappedMediatorName" value="mappedMediatorTarget"/>
          </object>

          <!-- command names map (magic name object) -->
          <object id="commandNamesMap" class="flash.utils.Dictionary">
            <property name="mappedCommandName" value="mappedCommandTarget"/>
          </object>

          <object id="mappedProxyTarget" class="org.springextensions.actionscript.puremvc.testclasses.SampleIocProxy"/>
          <object id="mappedMediatorTarget" class="org.springextensions.actionscript.puremvc.testclasses.SampleIocMediator"/>
          <object id="mappedCommandTarget" class="org.springextensions.actionscript.puremvc.testclasses.SampleIocCommand"/>
        </objects>;

      var testingIocFacade:MockIocFacade = new MockIocFacade();
      testingIocFacade.addConfigSource(configSource);
      testingIocFacade.addEventListener(
          Event.COMPLETE, addAsync(onTestControllerCommandNamesMapConfiguration_AfterExplicitInitialization, 1000));
      testingIocFacade.initializeIocContainer();
    }

    public function onTestControllerCommandNamesMapConfiguration_AfterExplicitInitialization(p_event:Event):void {
      var testingIocFacade:MockIocFacade = MockIocFacade.getInstance();
      var iocController:MockIocController = testingIocFacade.getController() as MockIocController;
      var commandNamesMap:Dictionary = iocController.getCommandNamesMap();

      assertTrue(commandNamesMap.hasOwnProperty(MAPPED_COMMAND_NAME));
      assertEquals(commandNamesMap[MAPPED_COMMAND_NAME], MAPPED_COMMAND_TARGET);
    }

    public function testRegisterProxy_AfterExplicitInitialization():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();
      var sampleProxy:IProxy = new SampleIocProxy(SAMPLE_PROXY_NAME);

      // First run
      iocFacade.registerProxy(sampleProxy);
      assertNotNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      // Now initialize IoC container and execute tests again. Currently registered proxy should stay registered.
      iocFacade.addEventListener(
          Event.COMPLETE, addAsync(onTestRegisterProxy_AfterExplicitInitializationComplete, 1000));
      (iocFacade as IocFacade).initializeIocContainer("puremvc-applicationContext.xml");
    }

    public function onTestRegisterProxy_AfterExplicitInitializationComplete(event:Event):void {
      var iocFacade:IIocFacade = MockIocFacade.getInstance();
      iocFacade.removeEventListener(Event.COMPLETE, onTestRegisterProxy_AfterExplicitInitializationComplete);

      var sampleProxyOne:IProxy = iocFacade.retrieveProxy(SAMPLE_PROXY_NAME);
      assertNotNull(sampleProxyOne);

      var sampleProxyTwo:IProxy = iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNotNull(sampleProxyTwo);
      assertEquals(sampleProxyOne, sampleProxyTwo);
      assertNull(iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      MockIocFacade.destroy();
    }

    public function testRegisterMediator_AfterExplicitInitialization():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();
      var sampleMediator:IMediator = new SampleIocMediator(SAMPLE_MEDIATOR_NAME);

      // First run
      iocFacade.registerMediator(sampleMediator);
      assertNotNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      // Now initialize IoC container and execute tests again. Currently registered mediator should stay registered.
      iocFacade.addEventListener(
          Event.COMPLETE, addAsync(onTestRegisterMediator_AfterExplicitInitializationComplete, 1000));
      (iocFacade as IocFacade).initializeIocContainer("puremvc-applicationContext.xml");
    }

    public function onTestRegisterMediator_AfterExplicitInitializationComplete(event:Event):void {
      var iocFacade:IIocFacade = MockIocFacade.getInstance();
      iocFacade.removeEventListener(Event.COMPLETE, onTestRegisterMediator_AfterExplicitInitializationComplete);

      var sampleMediatorOne:IMediator = iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME);
      assertNotNull(sampleMediatorOne);

      var sampleMediatorTwo:IMediator = iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNotNull(sampleMediatorTwo);
      assertEquals(sampleMediatorOne, sampleMediatorTwo);
      assertNull(iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      MockIocFacade.destroy();
    }

    public function testRegisterCommand_AfterExplicitInitialization():void {
      MockIocFacade.destroy();

      var iocFacade:IIocFacade = new MockIocFacade();

      // First run
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      // Now initialize IoC container and execute tests again. Currently registered command should stay registered.
      iocFacade.addEventListener(
          Event.COMPLETE, addAsync(onTestRegisterCommand_AfterExplicitInitializationComplete, 1000));
      (iocFacade as IocFacade).initializeIocContainer("puremvc-applicationContext.xml");
    }

    public function onTestRegisterCommand_AfterExplicitInitializationComplete(event:Event):void {
      var iocFacade:IIocFacade = MockIocFacade.getInstance();
      iocFacade.removeEventListener(Event.COMPLETE, onTestRegisterCommand_AfterExplicitInitializationComplete);

      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      MockIocFacade.destroy();
    }
  }
}
