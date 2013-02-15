/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.view.mediator {
  import flash.events.Event;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.model.IUserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.puremvc.arch_101.unit_03.lab_02.view.component.UserList;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.mediator.IocMediator;

  /**
   * Version: $Revision: 450 $, $Date: 2008-03-27 23:39:50 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   */
  public class UserListMediator extends IocMediator {
//    public static const NAME:String = "userListMediator";

    private var m_userProxy:IUserProxy;

    public function UserListMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);

      userList.addEventListener(UserList.NEW, onNew);
      userList.addEventListener(UserList.DELETE, onDelete);
      userList.addEventListener(UserList.SELECT, onSelect);

      // This code can be executed only when IoC container inject dependencies. So it is refactored in init() method
      // which is configured in IoC container as an initialization method for this class.
//      userList.users = userProxy.users;
//      userProxy.loadUsers();
    }

    public function init():void {
      userList.users = userProxy.users;
      userProxy.loadUsers();
    }

    public function set userProxy(p_userProxy:IUserProxy):void {
      m_userProxy = p_userProxy;
    }

    public function get userProxy():IUserProxy {
      return m_userProxy;
    }

    private function get userList():UserList {
      return getViewComponent() as UserList;
    }

    private function onNew(p_event:Event):void {
      var user:UserVO = new UserVO();
      sendNotification(ApplicationFacade.NEW_USER, user);
    }

    private function onDelete(p_event:Event):void {
      sendNotification(ApplicationFacade.DELETE_USER, userList.selectedUser);
    }

    private function onSelect(p_event:Event):void {
      sendNotification(ApplicationFacade.USER_SELECTED, userList.selectedUser);
    }

    override public function listNotificationInterests():Array {
      return [ApplicationFacade.CANCEL_SELECTED, ApplicationFacade.USER_UPDATED];
    }

    override public function handleNotification(p_note:INotification):void {
      switch (p_note.getName()) {
        case ApplicationFacade.CANCEL_SELECTED:
          userList.deSelect();
          break;
        case ApplicationFacade.USER_UPDATED:
          userList.deSelect();
          break;
      }
    }
  }
}
