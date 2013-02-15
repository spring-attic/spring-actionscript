/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.controller {
  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.interfaces.IIocCommand;
  import org.springextensions.actionscript.puremvc.interfaces.IIocMediator;
  import org.springextensions.actionscript.puremvc.interfaces.IIocProxy;
  import org.springextensions.actionscript.puremvc.patterns.command.IocSimpleCommand;

  /**
   * <b>Version:</b> $Revision: 877 $, $Date: 2008-10-12 23:30:14 +0200 (zo, 12 okt 2008) $, $Author: dmurat1 $<br/>
   */
  public class StartupCommand extends IocSimpleCommand {
    private var m_deleteUserCommand:IIocCommand;
    private var m_addRoleResultCommand:IIocCommand;
    private var m_userProxy:IIocProxy;
    private var m_roleProxy:IIocProxy;
    private var m_applicationMediator:IIocMediator;
    private var m_userListMediator:IIocMediator;
    private var m_userFormMediator:IIocMediator;
    private var m_rolePanelMediator:IIocMediator;

    public function set deleteUserCommand(p_deleteUserCommand:IIocCommand):void {
      m_deleteUserCommand = p_deleteUserCommand;
    }

    public function get deleteUserCommand():IIocCommand {
      return m_deleteUserCommand;
    }

    public function set addRoleResultCommand(p_addRoleResultCommand:IIocCommand):void {
      m_addRoleResultCommand = p_addRoleResultCommand;
    }

    public function get addRoleResultCommand():IIocCommand {
      return m_addRoleResultCommand;
    }

    public function set userProxy(p_userProxy:IIocProxy):void {
      m_userProxy = p_userProxy;
    }

    public function get userProxy():IIocProxy {
      return m_userProxy;
    }

    public function set roleProxy(p_roleProxy:IIocProxy):void {
      m_roleProxy = p_roleProxy;
    }

    public function get roleProxy():IIocProxy {
      return m_roleProxy;
    }

    public function set applicationMediator(p_applicationMediator:IIocMediator):void {
      m_applicationMediator = p_applicationMediator;
    }

    public function get applicationMediator():IIocMediator {
      return m_applicationMediator;
    }

    public function set userListMediator(p_userListMediator:IIocMediator):void {
      m_userListMediator = p_userListMediator;
    }

    public function get userListMediator():IIocMediator {
      return m_userListMediator;
    }

    public function set userFormMediator(p_userFormMediator:IIocMediator):void {
      m_userFormMediator = p_userFormMediator;
    }

    public function get userFormMediator():IIocMediator {
      return m_userFormMediator;
    }

    public function set rolePanelMediator(p_rolePanelMediator:IIocMediator):void {
      m_rolePanelMediator = p_rolePanelMediator;
    }

    public function get rolePanelMediator():IIocMediator {
      return m_rolePanelMediator;
    }

    /**
     * Register the Proxies and Mediators. Get the View Components for the Mediators from the app, which passed a
     * reference to itself on the notification.
     */
    override public function execute(p_note:INotification):void {
      iocFacade.registerCommandByConfigName(ApplicationFacade.DELETE_USER, deleteUserCommand.getConfigName());
      iocFacade.registerCommandByConfigName(ApplicationFacade.ADD_ROLE_RESULT, addRoleResultCommand.getConfigName());

      iocFacade.registerProxyByConfigName(userProxy.getConfigName());
      iocFacade.registerProxyByConfigName(roleProxy.getConfigName());

      var app:PranaSampleAnotherArch101Demo = p_note.getBody() as PranaSampleAnotherArch101Demo;

      applicationMediator.setViewComponent(app);
      iocFacade.registerMediatorByConfigName(applicationMediator.getConfigName());

      userListMediator.setViewComponent(app.userList);
      iocFacade.registerMediatorByConfigName(userListMediator.getConfigName());

      userFormMediator.setViewComponent(app.userForm);
      iocFacade.registerMediatorByConfigName(userFormMediator.getConfigName());

      rolePanelMediator.setViewComponent(app.rolePanel);
      iocFacade.registerMediatorByConfigName(rolePanelMediator.getConfigName());

      iocFacade.removeCommand(ApplicationFacade.STARTUP);
    }
  }
}
