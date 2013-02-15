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
package org.springextensions.actionscript.puremvc.patterns.command {
  import org.springextensions.actionscript.puremvc.interfaces.IIocCommand;
  import org.springextensions.actionscript.puremvc.interfaces.IIocFacade;
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.observer.Notifier;

  /**
   * This class exists to provide a macro command that can have its subcommands injected into it.
   * <p>
   * The MacroCommand in PureMVC is not open for extension in this way, which requires us to make this
   * clone of it to use it in an IoC way.
   * </p>
   *
   * <p>
   * <b>Author:</b> Ryan Gardner<br/>
   * <b>Version:</b> $Revision: 17 $, $Date: 2008-11-01 20:07:07 +0100 (za, 01 nov 2008) $, $Author: dmurat $<br/>
   * <b>Since:</b> 0.6
   * </p>
   */
  public class IocManagedMacroCommand extends Notifier implements IIocCommand {
    private var m_subCommands:Array;
    private var m_configName:String;

    public function getConfigName():String {
      return m_configName;
    }

    public function setConfigName(p_configName:String):void {
      m_configName = p_configName;
    }

    public function IocManagedMacroCommand() {
      super();

      m_subCommands = new Array();
      initializeMacroCommand();
    }

    protected function get iocFacade():IIocFacade {
      return facade as IIocFacade;
    }

    protected function initializeMacroCommand():void {
    }

    protected function addSubCommand(commandInstance:IIocCommand):void {
      m_subCommands.push(commandInstance);
    }

    public final function execute(p_note:INotification):void {
      while (m_subCommands.length > 0) {
        var commandInstance:IIocCommand = m_subCommands.shift();
        commandInstance.execute(p_note);
      }
    }
  }
}
