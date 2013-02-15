/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.controller {
  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.MediatorNames;
  import org.puremvc.arch_101.unit_03.lab_02.ProxyNames;
  import org.puremvc.arch_101.unit_03.lab_02.view.mediator.ApplicationMediator;
  import org.puremvc.arch_101.unit_03.lab_02.view.mediator.UserFormMediator;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.command.IocSimpleCommand;

  /**
   * Version: $Revision: 748 $, $Date: 2008-06-06 11:06:25 +0200 (vr, 06 jun 2008) $, $Author: dmurat1 $
   */
  public class StartupCommand extends IocSimpleCommand {
    /**
     * Register the Proxies and Mediators.
     *
     * Get the View Components for the Mediators from the app, which passed a reference to itself on the notification.
     */
    override public function execute(p_note:INotification):void {
      iocFacade.registerProxyByConfigName(ProxyNames.USER_PROXY);
      iocFacade.registerProxyByConfigName(ProxyNames.ROLE_PROXY);

      var app:PranaSamplePureMvcArch101Demo = p_note.getBody() as PranaSamplePureMvcArch101Demo;
      facade.registerMediator(new ApplicationMediator(MediatorNames.APPLICATION_MDR, app));

      iocFacade.registerMediatorByConfigName(MediatorNames.USER_LIST_MDR, app.userList);

      facade.registerMediator(new UserFormMediator(MediatorNames.USER_FORM_MDR, app.userForm));
      iocFacade.registerMediatorByConfigName(MediatorNames.ROLE_PANEL_MDR, app.rolePanel);

      facade.removeCommand(ApplicationFacade.STARTUP);
    }
  }
}
