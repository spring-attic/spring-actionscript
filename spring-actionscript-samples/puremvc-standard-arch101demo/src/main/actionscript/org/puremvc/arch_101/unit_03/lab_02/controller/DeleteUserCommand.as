/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.controller {
  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.ProxyNames;
  import org.puremvc.arch_101.unit_03.lab_02.model.IRoleProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.IUserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.command.IocSimpleCommand;

  /**
   * Version: $Revision: 748 $, $Date: 2008-06-06 11:06:25 +0200 (vr, 06 jun 2008) $, $Author: dmurat1 $
   */
  public class DeleteUserCommand extends IocSimpleCommand {
    private var m_userProxy:IUserProxy;

    // retrieve the user and role proxies and delete the user
    // and his roles. then send the USER_DELETED notification
    override public function execute(p_notification:INotification):void {
      var user:UserVO = p_notification.getBody() as UserVO;

      // IoC injected user proxy
      userProxy.deleteItem(user);

      // ad hoc from IoC fetched role proxy
      var roleProxy:IRoleProxy = facade.retrieveProxy(ProxyNames.ROLE_PROXY) as IRoleProxy;
      roleProxy.deleteItem(user);
      sendNotification(ApplicationFacade.USER_DELETED);
    }

    public function set userProxy(p_userProxy:IUserProxy):void {
      m_userProxy = p_userProxy;
    }

    public function get userProxy():IUserProxy {
      return m_userProxy;
    }
  }
}
