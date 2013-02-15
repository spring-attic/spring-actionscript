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
package org.springextensions.actionscript.puremvc.patterns.facade {

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.utils.Dictionary;
  
  import org.as3commons.lang.Assert;
  import org.as3commons.lang.ClassUtils;
  import org.as3commons.lang.IllegalArgumentError;
  import org.puremvc.as3.interfaces.IMediator;
  import org.puremvc.as3.interfaces.IProxy;
  import org.puremvc.as3.patterns.facade.Facade;
  import org.springextensions.actionscript.context.IConfigurableApplicationContext;
  import org.springextensions.actionscript.context.support.XMLApplicationContext;
  import org.springextensions.actionscript.ioc.ObjectDefinitionNotFoundError;
  import org.springextensions.actionscript.ioc.factory.config.IObjectPostProcessor;
  import org.springextensions.actionscript.puremvc.core.controller.IocController;
  import org.springextensions.actionscript.puremvc.interfaces.IIocController;
  import org.springextensions.actionscript.puremvc.interfaces.IIocFacade;
  import org.springextensions.actionscript.puremvc.interfaces.IIocMediator;
  import org.springextensions.actionscript.puremvc.interfaces.IIocProxy;
  import org.springextensions.actionscript.puremvc.interfaces.IocConstants;
  import org.springextensions.actionscript.puremvc.ioc.IocConfigNameAwarePostProcessor;

  /**
   * Dispatched as a result of a call to the <code>initializeIocContainer()</code> method when all available
   * configuration sources have been parsed.
   *
   * @eventType flash.events.Event.COMPLETE
   * @see #initializeIocContainer()
   */
  [Event(name="complete", type="flash.events.Event")]

  /**
   * IoC capable PureMVC facade which integrates functionalities of Prana and PureMVC frameworks.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.4
   * </p>
   */
  public class IocFacade extends Facade implements IIocFacade, IEventDispatcher {
    protected var m_proxyNamesMap:Dictionary;
    protected var m_mediatorNamesMap:Dictionary;
    protected var m_applicationContext:XMLApplicationContext;
    protected var m_dispatcher:EventDispatcher;
    protected var m_iocContainerInitialized:Boolean = false;

    /**
     * Constructor. Construction of <code>IocFacade</code> instance creates PureMVC compatible facade. After
     * construction this facade is not yet IoC enabled, but it can be used as an ordinary PureMVC facade. To enable IoC
     * features, one must invoke <code>initializeIocContainer()</code> method. Otherwise, all IoC specific methods will
     * throw errors.
     * <p>
     * Between construction and invocation of <code>initializeIocContainer()</code> method, one can use
     * <code>addConfigSource()</code> to define additional configuration sources.
     * </p>
     *
     * @param p_configSource
     *        Optional parameter with configuration source which supports several configuration source types. In one
     *        case, configuration source can be <code>XML</code> instance containing Prana's configuration (i.e. this
     *        can be useful for embedded configurations). Otherwise, configuration source should contain a path (or
     *        paths) to the configuration files. For a single path, <code>String</code> type should be used. For one or
     *        more paths, <code>Array</code> instance with <code>String</code> elements should be used.
     * @throws Error Error Thrown if singleton instance has already been constructed.
     * @see #initializeIocContainer()
     * @see #addConfigSource()
     */
    public function IocFacade(p_configSource:* = null) {
      super();

      m_proxyNamesMap = new Dictionary();
      m_mediatorNamesMap = new Dictionary();
      m_dispatcher = new EventDispatcher(this);

      m_applicationContext = new XMLApplicationContext(null);
      initializeIocFacade();
      addConfigSource(p_configSource);
    }

    /**
     * Adds configuration source to this <code>IocFacade</code> instance. To have an effect, it should be invoked
     * between construction of facade and invocation of <code>initializeIocContainer()</code> method.
     * <p>
     * It supports configuration sources expressed as <code>XML</code> instance which should contain Prana's
     * configuration, or as paths to the configuration files encoded like <code>String</code> or <code>Array</code>
     * with <code>String</code> elements.
     * </p>
     *
     * @param p_configSource Optional parameter with configuration source.
     * @throws org.springextensions.actionscript.errors.IllegalArgumentError Thrown when a supplied array contains non
     *         <code>String</code> elements or when supplied parameter is not of <code>XML</code>, <code>String</code>
     *         or <code>Array</code> type.
     * @see #IocFacade()
     * @see #initializeIocContainer()
     */
    public function addConfigSource(p_configSource:*):void {
      var i:int = 0;

      if (p_configSource != null) {
        if (p_configSource is XML) {
          m_applicationContext.addConfig(p_configSource);
        }
        else if (p_configSource is String) {
          m_applicationContext.addConfigLocation(p_configSource);
        }
        else if (p_configSource is Array) {
          var array:Array = p_configSource as Array;
          for (i = 0; i < array.length; i++) {
            Assert.instanceOf(array[i], String, "All array elements must be String instances.");
            m_applicationContext.addConfigLocation(array[i]);
          }
        }
        else {
          var parametersClass:Class = ClassUtils.forInstance(p_configSource);
          var parametersFgdn:String = ClassUtils.getFullyQualifiedName(parametersClass);
          throw new IllegalArgumentError(
              "Parameter p_configSource has unsupported type '" + parametersFgdn + "'. Supported types are XML, " +
              "String and Array of strings.");
        }
      }
    }

    /**
     * One time initialization of internal IoC container. This method can be used only once. Otherwise, it will throw an
     * error. To enable IoC features of IocFacade this method must be invoked after IocFacade construction.
     * <p>
     * Dispatces <code>flash.events.Event.COMPLETE</code> instance when finishes initialization.
     * </p>
     *
     * @param p_configSource
     *        Optional parameter specifying configuration source. It can be <code>XML</code>, <code>String</code> and
     *        <code>Array</code> with <code>String</code> elements.
     * @throws org.springextensions.actionscript.errors.IllegalStateError Thrown if IoC conatiner is already initialized.
     * @see #IocFacade()
     * @see #addConfigSource()
     */
    public function initializeIocContainer(p_configSource:* = null):void {
      var objectPostProcessorArray:Array = null;
      var i:int = 0;

      Assert.state(!m_iocContainerInitialized, "IoC conatiner is already initialized.");

      addConfigSource(p_configSource);

      objectPostProcessorArray = getObjectPostProcessors();
      for (i = 0; i < objectPostProcessorArray.length; i++) {
        if (objectPostProcessorArray[i] as IObjectPostProcessor) {
          m_applicationContext.addObjectPostProcessor(objectPostProcessorArray[i]);
        }
      }

      m_applicationContext.addEventListener(Event.COMPLETE, onObjectFactoryListenerComplete);

      m_iocContainerInitialized = true;
      m_applicationContext.load();
    }

    /**
     * Enables adding object postprocessors in internal prana container. This implementation adds just
     * <code>IocConfigNameAwarePostProcessor</code>. If this is not desired, one override this method in a subclass.
     *
     * @return Array containing all configured object postprocessors for internal prana container.
     * @see org.springextensions.actionscript.puremvc.ioc.IocConfigNameAwarePostProcessor
     */
    protected function getObjectPostProcessors():Array {
      return new Array(new IocConfigNameAwarePostProcessor());
    }

    protected function onObjectFactoryListenerComplete(p_event:Event):void {
      m_applicationContext.removeEventListener(Event.COMPLETE, onObjectFactoryListenerComplete);

      (controller as IocController).initializeIocContainer(m_applicationContext);

      try {
        m_proxyNamesMap = container.getObject(IocConstants.PROXY_NAMES_MAP);
      }
      catch (error:ObjectDefinitionNotFoundError) {
        // do nothing since proxy names Map doesn't have to be used
      }

      try {
        m_mediatorNamesMap = container.getObject(IocConstants.MEDIATOR_NAMES_MAP);
      }
      catch (error:ObjectDefinitionNotFoundError) {
        // do nothing since mediator names Map doesn't have to be used
      }

      dispatchEvent(new Event(Event.COMPLETE));
    }

    public function get container():IConfigurableApplicationContext {
      return m_applicationContext;
    }

    /**
     * This prevents super constructor from trying to initialize facade to early.
     */
    override protected function initializeFacade():void {
    }

    protected function initializeIocFacade():void {
      initializeModel();
      initializeController();
      initializeView();
    }

    override protected function initializeController():void {
      controller = IocController.getInstance(m_applicationContext);
    }

    public function registerProxyByConfigName(p_proxyName:String):void {
      var proxy:IIocProxy = null;
      var targetConfigName:String = m_proxyNamesMap[p_proxyName];

      // First try to find an object by mapped name
      if (targetConfigName != null) {
        // This will thorw an error if the object definition can't be found
        proxy = container.getObject(targetConfigName);
      }
      // If there is no value for mapped name available, try with supplied name.
      else {
        // This will thorw an error if the object definition can't be found
        proxy = container.getObject(p_proxyName);
      }

      proxy.setProxyName(p_proxyName);
      model.registerProxy(proxy);
    }

    override public function removeProxy(p_proxyName:String):IProxy {
      var proxy:IProxy;

      if (model != null) {
        if (m_applicationContext != null) {
          var targetConfigName:String = m_proxyNamesMap[p_proxyName];
          if (targetConfigName != null) {
            m_applicationContext.clearObjectFromInternalCache(targetConfigName);
          }
          // If there is no value for mapped name available, try with supplied name.
          else {
            m_applicationContext.clearObjectFromInternalCache(p_proxyName);
          }
        }

        proxy = model.removeProxy(p_proxyName);
      }

      return proxy;
    }

    public function registerMediatorByConfigName(p_mediatorName:String, p_viewComponent:Object = null):void {
      var mediator:IIocMediator = null;
      var targetConfigName:String = m_mediatorNamesMap[p_mediatorName];

      if (targetConfigName != null) {
        if (p_viewComponent != null) {
          mediator = container.getObject(targetConfigName, [p_mediatorName, p_viewComponent]);
        }
        else {
          mediator = container.getObject(targetConfigName);
        }
      }
      else {
        if (p_viewComponent != null) {
          mediator = container.getObject(p_mediatorName, [p_mediatorName, p_viewComponent]);
        }
        else {
          mediator = container.getObject(p_mediatorName);
        }
      }

      mediator.setMediatorName(p_mediatorName);
      view.registerMediator(mediator);
    }

    override public function removeMediator(p_mediatorName:String):IMediator {
      var mediator:IMediator;
      if (view != null) {
        if (m_applicationContext != null) {
          var targetConfigName:String = m_mediatorNamesMap[p_mediatorName];

          if (targetConfigName != null) {
            m_applicationContext.clearObjectFromInternalCache(targetConfigName);
          }
          // If there is no value for mapped name available, try with supplied name.
          else {
            m_applicationContext.clearObjectFromInternalCache(p_mediatorName);
          }
        }

        mediator = view.removeMediator(p_mediatorName);
      }

      return mediator;
    }

    public function registerCommandByConfigName(p_noteName:String, p_configName:String):void {
      (controller as IIocController).registerCommandByConfigName(p_noteName, p_configName);
    }

    // IEventDispatcher implementation -- start
    public function addEventListener(
      p_type:String, p_listener:Function, p_useCapture:Boolean = false, p_priority:int = 0,
      p_useWeakReference:Boolean = false):void
    {
      m_dispatcher.addEventListener(p_type, p_listener, p_useCapture, p_priority);
    }

    public function dispatchEvent(p_event:Event):Boolean{
      return m_dispatcher.dispatchEvent(p_event);
    }

    public function hasEventListener(p_type:String):Boolean{
      return m_dispatcher.hasEventListener(p_type);
    }

    public function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean = false):void {
      m_dispatcher.removeEventListener(p_type, p_listener, p_useCapture);
    }

    public function willTrigger(p_type:String):Boolean {
      return m_dispatcher.willTrigger(p_type);
    }
    // IEventDispatcher implementation -- end
  }
}
