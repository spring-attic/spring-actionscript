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
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   */
  public class UserListMediator extends IocMediator {
    private var m_userProxy:IUserProxy;

    public function UserListMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);
    }

    override public function setViewComponent(p_viewComponent:Object):void {
      if (getViewComponent() != null) {
        userList.removeEventListener(UserList.NEW, onNew);
        userList.removeEventListener(UserList.DELETE, onDelete);
        userList.removeEventListener(UserList.SELECT, onSelect);
      }

      super.setViewComponent(p_viewComponent);

      init();
    }

    public function init():void {
      userList.addEventListener(UserList.NEW, onNew);
      userList.addEventListener(UserList.DELETE, onDelete);
      userList.addEventListener(UserList.SELECT, onSelect);

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
        case ApplicationFacade.CANCEL_SELECTED: {
          userList.deSelect();
          break;
        }
        case ApplicationFacade.USER_UPDATED: {
          userList.deSelect();
          break;
        }
      }
    }
  }
}
