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
/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.springextensions.actionscript.puremvc.core.controller {
  import flash.utils.Dictionary;

  import org.springextensions.actionscript.ioc.ObjectDefinitionNotFoundError;
  import org.springextensions.actionscript.ioc.factory.support.AbstractObjectFactory;
  import org.springextensions.actionscript.puremvc.interfaces.IIocController;
  import org.springextensions.actionscript.puremvc.interfaces.IocConstants;
  import org.puremvc.as3.core.View;
  import org.puremvc.as3.interfaces.ICommand;
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.interfaces.IView;
  import org.puremvc.as3.patterns.observer.Observer;

  /**
   * Description wannabe.
   *
   * <p>
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.4
   * </p>
   */
  public class IocController implements IIocController {
    protected static const SINGLETON_MSG:String = "Controller Singleton already constructed!";
    protected static var m_instance:IIocController;

    protected var m_view:IView;
    protected var m_commandMap:Array;
    protected var m_iocCommandMap:Array;
    protected var m_iocFactory:AbstractObjectFactory;
    protected var m_commandNamesMap:Dictionary;

    public static function getInstance(p_iocFactory:AbstractObjectFactory):IIocController {
      if (m_instance == null) {
        m_instance = new IocController(p_iocFactory);
      }

      return m_instance;
    }

    public function IocController(p_iocFactory:AbstractObjectFactory) {
      super();

      if (m_instance != null) {
        throw Error(SINGLETON_MSG);
      }
      m_instance = this;
      m_commandMap = new Array();
      m_iocCommandMap = new Array();

      initializeController();
      initializeIocContainer(p_iocFactory);
    }

    public function initializeIocContainer(p_iocFactory:AbstractObjectFactory):void {
      m_iocFactory = p_iocFactory;

      try {
        m_commandNamesMap = m_iocFactory.getObject(IocConstants.COMMAND_NAMES_MAP);
      }
      catch (error:ObjectDefinitionNotFoundError) {
        m_commandNamesMap = new Dictionary();
      }
    }

    protected function initializeController():void {
      m_view = View.getInstance();
    }

    public function executeCommand(p_note:INotification):void {
      var commandClassRef:Class = m_commandMap[p_note.getName()];

      if (commandClassRef != null) {
        var commandInstance:ICommand = new commandClassRef();
        commandInstance.execute(p_note);

        return;
      }

      var commandName:String = m_iocCommandMap[p_note.getName()];
      if (commandName != null) {
        var iocCommandInstance:ICommand;
        var commandTargetName:String = m_commandNamesMap[commandName];

        if (commandTargetName != null) {
          iocCommandInstance = m_iocFactory.getObject(commandTargetName);
        }
        else {
          iocCommandInstance = m_iocFactory.getObject(commandName);
        }

        iocCommandInstance.execute(p_note);

        return;
      }
    }

    public function registerCommand(p_notificationName:String, p_commandClassRef:Class):void {
      var isAlreadyRegistered:Boolean = false;

      // First clear ioc command if it is registered for specified notification name.
      if (m_iocCommandMap[p_notificationName] != null) {
        m_iocFactory.clearObjectFromInternalCache(m_iocCommandMap[p_notificationName]);
        m_iocCommandMap[p_notificationName] = null;
        isAlreadyRegistered = true;
      }

      if (m_commandMap[p_notificationName] == null && !isAlreadyRegistered) {
        m_view.registerObserver(p_notificationName, new Observer(executeCommand, this));
      }

      m_commandMap[p_notificationName] = p_commandClassRef;
    }

    public function registerCommandByConfigName(p_notificationName:String, p_commandName:String):void {
      var isAlreadyRegistered:Boolean = false;

      // First clear "normal" command if it is registered for specified notification name.
      if (m_commandMap[p_notificationName] != null) {
        m_commandMap[p_notificationName] = null;
        isAlreadyRegistered = true;
      }

      if (m_iocCommandMap[p_commandName] == null && !isAlreadyRegistered) {
        m_view.registerObserver(p_notificationName, new Observer(executeCommand, this));
      }

      m_iocCommandMap[p_notificationName] = p_commandName;
    }

    public function removeCommand(p_notificationName:String):void {
      var commandTargetName:String;
      var commandName:String;

      if (m_commandMap[p_notificationName] != null) {
        m_commandMap[p_notificationName] = null;
      }

      if (m_iocCommandMap[p_notificationName] != null) {
        commandTargetName = m_commandNamesMap[p_notificationName];

        if (commandTargetName != null) {
          m_iocFactory.clearObjectFromInternalCache(commandTargetName);
        }
        else {
          commandName = m_iocCommandMap[p_notificationName];
          m_iocFactory.clearObjectFromInternalCache(commandName);
        }

        m_iocCommandMap[p_notificationName] = null;
      }

      m_view.removeObserver(p_notificationName, this);
    }

    public function hasCommand(p_notificationName:String):Boolean {
      var retval:Boolean = false;
      if (m_commandMap[p_notificationName] != null || m_iocCommandMap[p_notificationName] != null) {
        retval = true;
      }

      return retval;
    }
  }
}
