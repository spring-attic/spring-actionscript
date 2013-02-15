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

  import flexunit.framework.TestCase;

  import org.as3commons.lang.IllegalArgumentError;
  import org.springextensions.actionscript.puremvc.interfaces.IIocMediator;
  import org.springextensions.actionscript.puremvc.interfaces.IIocProxy;
  import org.springextensions.actionscript.puremvc.patterns.facade.IocFacade;
  import org.springextensions.actionscript.puremvc.testclasses.SampleIocCommand;
  import org.springextensions.actionscript.puremvc.testclasses.SampleIocMediator;
  import org.springextensions.actionscript.puremvc.testclasses.SampleIocProxy;
  import org.springextensions.actionscript.puremvc.testclasses.MockIocController;
  import org.springextensions.actionscript.puremvc.testclasses.MockIocFacade;
  import org.puremvc.as3.interfaces.IMediator;
  import org.puremvc.as3.interfaces.IProxy;

  /**
   * Tests for <code>IocFacade</code> class.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 22 $, $Date: 2008-11-01 23:15:06 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class IocFacadeTest extends TestCase {
    private static const SAMPLE_PROXY_NAME:String = "sampleProxyName";
    private static const SAMPLE_PROXY_CONFIG_NAME:String = "sampleProxyConfigName";
    private static const SAMPLE_MEDIATOR_NAME:String = "sampleMediatorName";
    private static const SAMPLE_MEDIATOR_CONFIG_NAME:String = "sampleMediatorConfigName";
    private static const SAMPLE_COMMAND_CONFIG_NAME:String = "sampleCommandConfigName";
    private static const MAPPED_PROXY_NAME:String = "mappedProxyName";
    private static const MAPPED_PROXY_TARGET:String = "mappedProxyTarget";
    private static const MAPPED_MEDIATOR_NAME:String = "mappedMediatorName";
    private static const MAPPED_MEDIATOR_TARGET:String = "mappedMediatorTarget";
    private static const NOTIFICATION:String = "notification";
    private static const MAPPED_COMMAND_NAME:String = "mappedCommandName";

    private static var c_iocFacade:IocFacade;

    private var m_linkageEnforcer:Object = {
      prop1:SampleIocProxy,
      prop2:SampleIocMediator
    };

    public function IocFacadeTest() {
    }

    override public function setUp():void {
    }

    override public function getTestMethodNames():Array {
      var methodNames:Array = super.getTestMethodNames();
      methodNames.unshift("init");
      methodNames.push("destroy");
      return methodNames;
    }

    public function init():void {
      c_iocFacade = new IocFacade("puremvc-applicationContext.xml");
      c_iocFacade.addEventListener(Event.COMPLETE, addAsync(onCompleteInit, 1000));
      c_iocFacade.initializeIocContainer();
    }

    public function onCompleteInit(p_event:Event):void {
      assertNotNull(c_iocFacade);
    }

    public function destroy():void {
      c_iocFacade = null;
    }

    public function testAddConfigSource():void {
      MockIocFacade.destroy();
      var testingIocFacade:MockIocFacade = new MockIocFacade();

      // test adding single location
      testingIocFacade.addConfigSource("singleLocation0.xml");
      assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[0], "singleLocation0.xml");

      // test adding multiple location
      testingIocFacade.addConfigSource(["singleLocation1.xml", "singleLocation2.xml"]);
      assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[0], "singleLocation0.xml");
      assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[1], "singleLocation1.xml");
      assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[2], "singleLocation2.xml");

      // test adding array with non string elements
      try {
        testingIocFacade.addConfigSource(["singleLocation3.xml", 123]);
        fail();
      }
      catch (iae:IllegalArgumentError) {
        assertTrue(true);

        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[0], "singleLocation0.xml");
        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[1], "singleLocation1.xml");
        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[2], "singleLocation2.xml");
        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[3], "singleLocation3.xml");
      }

      // test adding illegal type
      try {
        testingIocFacade.addConfigSource(123);
        fail();
      }
      catch (iae:IllegalArgumentError) {
        assertTrue(true);

        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[0], "singleLocation0.xml");
        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[1], "singleLocation1.xml");
        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[2], "singleLocation2.xml");
        assertEquals(testingIocFacade.getXmlApplicationContext().configLocations[3], "singleLocation3.xml");
      }
    }

    /**
     * When registered in "classic" way, it should also be available for retrieval by config name aware methods.
     * It seams that config name aware retrieval will be superflous once when configuration maps semantics will be
     * changed.
     */
    public function testRegisterProxy():void {
      var sampleProxy:IIocProxy = new SampleIocProxy(SAMPLE_PROXY_NAME);

      // First run
      c_iocFacade.registerProxy(sampleProxy);
      assertNotNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      c_iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      c_iocFacade.registerProxy(sampleProxy);
      assertNotNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));

      c_iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));
    }

    /**
     * Once when registered by config name, proxy should be available for retrieval and removal by standard methods.
     */
    public function testRegisterProxyByConfigName():void {
      // First run
      c_iocFacade.registerProxyByConfigName(SAMPLE_PROXY_CONFIG_NAME);
      assertNotNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_CONFIG_NAME));

      c_iocFacade.removeProxy(SAMPLE_PROXY_CONFIG_NAME);
      assertNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_CONFIG_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      c_iocFacade.registerProxyByConfigName(SAMPLE_PROXY_CONFIG_NAME);
      assertNotNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_CONFIG_NAME));

      c_iocFacade.removeProxy(SAMPLE_PROXY_CONFIG_NAME);
      assertNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_CONFIG_NAME));
    }

    /**
     * Once when registered by config name and with mapping, proxy should be available for retrieval and removal by
     * standard methods.
     */
    public function testRegisterProxyByConfigName_WithMapping():void {
      // First run
      c_iocFacade.registerProxyByConfigName(MAPPED_PROXY_NAME);
      assertNotNull(c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME));
      assertEquals(
          c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME),
          c_iocFacade.container.getObject(MAPPED_PROXY_TARGET));

      c_iocFacade.removeProxy(MAPPED_PROXY_NAME);
      assertNull(c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      c_iocFacade.registerProxyByConfigName(MAPPED_PROXY_NAME);
      assertNotNull(c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME));
      assertEquals(
          c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME),
          c_iocFacade.container.getObject(MAPPED_PROXY_TARGET));

      c_iocFacade.removeProxy(MAPPED_PROXY_NAME);
      assertNull(c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME));
    }

    public function testRemoveProxy_NonIocManaged():void {
      var proxyOne:IProxy;
      var proxyTwo:IProxy;

      proxyOne = new SampleIocProxy(SAMPLE_PROXY_NAME, null);
      c_iocFacade.registerProxy(proxyOne);
      proxyTwo = c_iocFacade.retrieveProxy(SAMPLE_PROXY_NAME);
      assertNotNull(proxyTwo);
      assertEquals(proxyOne, proxyTwo);

      proxyOne = c_iocFacade.removeProxy(SAMPLE_PROXY_NAME);
      assertNotNull(proxyOne);
      assertEquals(proxyOne, proxyTwo);
      assertNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_NAME));
    }

    /**
     * When proxy is removed, it should be cleared from internal container cache, and removed from puremvc's Model.
     */
    public function testRemoveProxy_IocManaged():void {
      var proxyOne:IProxy;
      var proxyTwo:IProxy;

      c_iocFacade.registerProxyByConfigName(SAMPLE_PROXY_CONFIG_NAME);
      proxyOne = c_iocFacade.retrieveProxy(SAMPLE_PROXY_CONFIG_NAME);
      assertNotNull(proxyOne);
      assertEquals((proxyOne as IIocProxy).getConfigName(), SAMPLE_PROXY_CONFIG_NAME);

      proxyTwo = c_iocFacade.removeProxy(SAMPLE_PROXY_CONFIG_NAME);
      assertNotNull(proxyTwo);
      assertEquals((proxyTwo as IIocProxy).getConfigName(), SAMPLE_PROXY_CONFIG_NAME);
      assertEquals(proxyOne, proxyTwo);
      assertNull(c_iocFacade.retrieveProxy(SAMPLE_PROXY_CONFIG_NAME));
    }

    /**
     * When proxy is removed, it should be cleared from internal container cache, and removed from puremvc's Model.
     */
    public function testRemoveProxy_IocManagedWithMapping():void {
      var proxyOne:IProxy;
      var proxyTwo:IProxy;

      c_iocFacade.registerProxyByConfigName(MAPPED_PROXY_NAME);
      proxyOne = c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME);
      assertNotNull(proxyOne);
      assertEquals((proxyOne as IIocProxy).getConfigName(), MAPPED_PROXY_TARGET);

      proxyTwo = c_iocFacade.removeProxy(MAPPED_PROXY_NAME);
      assertNotNull(proxyTwo);
      assertEquals((proxyTwo as IIocProxy).getConfigName(), MAPPED_PROXY_TARGET);
      assertEquals(proxyOne, proxyTwo);
      assertNull(c_iocFacade.retrieveProxy(MAPPED_PROXY_NAME));
    }

    /**
     * When registered in "classic" way, it should also be available for retrieval by config name aware methods.
     * It seams that config name aware retrieval will be superflous once when configuration maps semantics will be
     * changed.
     */
    public function testRegisterMediator():void {
      var sampleMediator:IMediator = new SampleIocMediator(SAMPLE_MEDIATOR_NAME);

      // First run
      c_iocFacade.registerMediator(sampleMediator);
      assertNotNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      c_iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      c_iocFacade.registerMediator(sampleMediator);
      assertNotNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));

      c_iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));
    }

    /**
     * Once when registered by config name, mediator should be available for retrieval and removal by standard methods.
     */
    public function testRegisterMediatorByConfigName():void {
      // First run
      c_iocFacade.registerMediatorByConfigName(SAMPLE_MEDIATOR_CONFIG_NAME);
      assertNotNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_CONFIG_NAME));

      c_iocFacade.removeMediator(SAMPLE_MEDIATOR_CONFIG_NAME);
      assertNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_CONFIG_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      c_iocFacade.registerMediatorByConfigName(SAMPLE_MEDIATOR_CONFIG_NAME);
      assertNotNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_CONFIG_NAME));

      c_iocFacade.removeMediator(SAMPLE_MEDIATOR_CONFIG_NAME);
      assertNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_CONFIG_NAME));
    }

    /**
     * Once when registered by config name and with mapping, mediator should be available for retrieval and removal by
     * standard methods.
     */
    public function testRegisterMediatorByConfigName_WithMapping():void {
      // First run
      c_iocFacade.registerMediatorByConfigName(MAPPED_MEDIATOR_NAME);
      assertNotNull(c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME));
      assertEquals(
          c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME),
          c_iocFacade.container.getObject(MAPPED_MEDIATOR_TARGET));

      c_iocFacade.removeMediator(MAPPED_MEDIATOR_NAME);
      assertNull(c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME));

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      c_iocFacade.registerMediatorByConfigName(MAPPED_MEDIATOR_NAME);
      assertNotNull(c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME));
      assertEquals(
          c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME),
          c_iocFacade.container.getObject(MAPPED_MEDIATOR_TARGET));

      c_iocFacade.removeMediator(MAPPED_MEDIATOR_NAME);
      assertNull(c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME));
    }

    public function testRemoveMediator_NonIocManaged():void {
      var mediatorOne:IMediator = new SampleIocMediator(SAMPLE_MEDIATOR_NAME, null);
      var mediatorTwo:IMediator;

      c_iocFacade.registerMediator(mediatorOne);
      mediatorTwo = c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME);
      assertNotNull(mediatorTwo);
      assertEquals(mediatorOne, mediatorTwo);
      assertEquals(mediatorTwo.getMediatorName(), SAMPLE_MEDIATOR_NAME);

      mediatorOne = c_iocFacade.removeMediator(SAMPLE_MEDIATOR_NAME);
      assertNotNull(mediatorOne);
      assertEquals(mediatorOne.getMediatorName(), SAMPLE_MEDIATOR_NAME);
      assertEquals(mediatorOne, mediatorTwo);
      assertNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_NAME));
    }

    /**
     * When removed by config name, it should be cleared from internal container cache, and removed from puremvc's
     * View.
     */
    public function testRemoveMediator_IocManaged():void {
      var mediatorOne:IMediator;
      var mediatorTwo:IMediator;

      c_iocFacade.registerMediatorByConfigName(SAMPLE_MEDIATOR_CONFIG_NAME);
      mediatorOne = c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_CONFIG_NAME);
      assertNotNull(mediatorOne);
      assertEquals(mediatorOne.getMediatorName(), SAMPLE_MEDIATOR_CONFIG_NAME);
      assertEquals((mediatorOne as IIocMediator).getConfigName(), SAMPLE_MEDIATOR_CONFIG_NAME);

      mediatorTwo = c_iocFacade.removeMediator(SAMPLE_MEDIATOR_CONFIG_NAME);
      assertNotNull(mediatorTwo);
      assertEquals(mediatorTwo.getMediatorName(), SAMPLE_MEDIATOR_CONFIG_NAME);
      assertEquals((mediatorTwo as IIocMediator).getConfigName(), SAMPLE_MEDIATOR_CONFIG_NAME);
      assertEquals(mediatorOne, mediatorTwo);
      assertNull(c_iocFacade.retrieveMediator(SAMPLE_MEDIATOR_CONFIG_NAME));
    }

    /**
     * When removed by config name, it should be cleared from internal container cache, and removed from puremvc's
     * View.
     */
    public function testRemoveMediator_IocManagedWithMapping():void {
      var mediatorOne:IMediator;
      var mediatorTwo:IMediator;

      c_iocFacade.registerMediatorByConfigName(MAPPED_MEDIATOR_NAME);
      mediatorOne = c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME);
      assertNotNull(mediatorOne);
      assertEquals(mediatorOne.getMediatorName(), MAPPED_MEDIATOR_NAME);
      assertEquals((mediatorOne as IIocMediator).getConfigName(), MAPPED_MEDIATOR_TARGET);

      mediatorTwo = c_iocFacade.removeMediator(MAPPED_MEDIATOR_NAME);
      assertNotNull(mediatorTwo);
      assertEquals(mediatorTwo.getMediatorName(), MAPPED_MEDIATOR_NAME);
      assertEquals((mediatorTwo as IIocMediator).getConfigName(), MAPPED_MEDIATOR_TARGET);
      assertEquals(mediatorOne, mediatorTwo);
      assertNull(c_iocFacade.retrieveMediator(MAPPED_MEDIATOR_NAME));
    }

    public function testRegisterCommand():void {
      MockIocFacade.destroy();

      var iocFacade:MockIocFacade =
          new MockIocFacade("puremvc-applicationContext.xml");
      iocFacade.addEventListener(Event.COMPLETE, addAsync(onCompleteInit, 1000));
      iocFacade.initializeIocContainer();

      var commandMap:Array = ((iocFacade as MockIocFacade).getController() as MockIocController).getCommandMap();
      var iocCommandMap:Array =
        ((iocFacade as MockIocFacade).getController() as MockIocController).getIocCommandMap();

      // First run
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      assertNotNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);

      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNotNull(commandMap[NOTIFICATION]);

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNotNull(commandMap[NOTIFICATION]);

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      assertNotNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);

      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNotNull(commandMap[NOTIFICATION]);

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNotNull(commandMap[NOTIFICATION]);

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
    }

    /**
     * Once when registered by config name, command should be available for execution and removal by standard methods.
     */
    public function testRegisterCommandByConfigName():void {
      MockIocFacade.destroy();

      var iocFacade:MockIocFacade =
          new MockIocFacade("puremvc-applicationContext.xml");
      iocFacade.addEventListener(Event.COMPLETE, addAsync(onCompleteInit, 1000));
      iocFacade.initializeIocContainer();

      var commandMap:Array =
          ((iocFacade as MockIocFacade).getController() as MockIocController).getCommandMap();
      var iocCommandMap:Array =
          ((iocFacade as MockIocFacade).getController() as MockIocController).getIocCommandMap();

      // First run
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertEquals(iocCommandMap[NOTIFICATION], SAMPLE_COMMAND_CONFIG_NAME);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertNotNull(commandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertEquals(iocCommandMap[NOTIFICATION], SAMPLE_COMMAND_CONFIG_NAME);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertEquals(iocCommandMap[NOTIFICATION], SAMPLE_COMMAND_CONFIG_NAME);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertNotNull(commandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertEquals(iocCommandMap[NOTIFICATION], SAMPLE_COMMAND_CONFIG_NAME);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
    }

    /**
     * Once when registered by config name and with mapping, command should be available for execution and removal by
     * standard methods.
     */
    public function testRegisterCommandByConfigName_WithMapping():void {
      MockIocFacade.destroy();

      var iocFacade:MockIocFacade =
        new MockIocFacade("puremvc-applicationContext.xml");
      iocFacade.addEventListener(Event.COMPLETE, addAsync(onCompleteInit, 1000));
      iocFacade.initializeIocContainer();

      var commandMap:Array =
          ((iocFacade as MockIocFacade).getController() as MockIocController).getCommandMap();
      var iocCommandMap:Array =
          ((iocFacade as MockIocFacade).getController() as MockIocController).getIocCommandMap();

      // First run
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertNotNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);

      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);

      // Second run
      // Now do this again, to check if there is some side effects. Second run must work exactly as first one.
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.registerCommand(NOTIFICATION, SampleIocCommand);
      assertNotNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(commandMap[NOTIFICATION]);
      assertNull(iocCommandMap[NOTIFICATION]);

      iocFacade.registerCommandByConfigName(NOTIFICATION, SAMPLE_COMMAND_CONFIG_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      iocFacade.registerCommandByConfigName(NOTIFICATION, MAPPED_COMMAND_NAME);
      assertNotNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
      assertTrue(iocFacade.hasCommand(NOTIFICATION));

      iocFacade.removeCommand(NOTIFICATION);
      assertFalse(iocFacade.hasCommand(NOTIFICATION));
      assertNull(iocCommandMap[NOTIFICATION]);
      assertNull(commandMap[NOTIFICATION]);
    }
  }
}
