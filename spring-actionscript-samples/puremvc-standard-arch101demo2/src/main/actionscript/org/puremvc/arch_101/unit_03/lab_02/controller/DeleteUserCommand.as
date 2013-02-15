/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.controller {
  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.model.IRoleProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.IUserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.command.IocSimpleCommand;

  /**
   * <b>Version:</b> $Revision: 877 $, $Date: 2008-10-12 23:30:14 +0200 (zo, 12 okt 2008) $, $Author: dmurat1 $<br/>
   */
  public class DeleteUserCommand extends IocSimpleCommand {
    private var m_userProxy:IUserProxy;
    private var m_roleProxy:IRoleProxy;

    public function set userProxy(p_userProxy:IUserProxy):void {
      m_userProxy = p_userProxy;
    }

    public function get userProxy():IUserProxy {
      return m_userProxy;
    }

    public function set roleProxy(p_roleProxy:IRoleProxy):void {
      m_roleProxy = p_roleProxy;
    }

    public function get roleProxy():IRoleProxy {
      return m_roleProxy;
    }

    // retrieve the user and role proxies and delete the user and his roles. then send the USER_DELETED notification
    override public function execute(p_notification:INotification):void {
      var user:UserVO = p_notification.getBody() as UserVO;

      userProxy.deleteItem(user);
      roleProxy.deleteItem(user);

      sendNotification(ApplicationFacade.USER_DELETED);
    }
  }
}
