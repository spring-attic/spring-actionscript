/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.view.mediator {
  import flash.events.Event;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.model.IRoleProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.enum.RoleEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.RoleVO;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.puremvc.arch_101.unit_03.lab_02.view.component.RolePanel;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.mediator.IocMediator;

  /**
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   */
  public class RolePanelMediator extends IocMediator {
    private var m_roleProxy:IRoleProxy;

    public function RolePanelMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);
    }

    public function set roleProxy(p_roleProxy:IRoleProxy):void {
      m_roleProxy = p_roleProxy;
    }

    public function get roleProxy():IRoleProxy {
      return m_roleProxy;
    }

    override public function setViewComponent(p_viewComponent:Object):void {
      if (getViewComponent() != null) {
        rolePanel.removeEventListener(RolePanel.ADD, onAddRole);
        rolePanel.removeEventListener(RolePanel.REMOVE, onRemoveRole);
      }

      super.setViewComponent(p_viewComponent);

      init();
    }

    public function init():void {
      rolePanel.addEventListener(RolePanel.ADD, onAddRole);
      rolePanel.addEventListener(RolePanel.REMOVE, onRemoveRole);
    }

    private function get rolePanel():RolePanel {
      return getViewComponent() as RolePanel;
    }

    private function onAddRole(p_event:Event):void {
      roleProxy.addRoleToUser(rolePanel.user, rolePanel.selectedRole);
    }

    private function onRemoveRole(p_event:Event):void {
      roleProxy.removeRoleFromUser(rolePanel.user, rolePanel.selectedRole);
    }

    override public function listNotificationInterests():Array {
      return [
          ApplicationFacade.NEW_USER, ApplicationFacade.USER_ADDED, ApplicationFacade.USER_UPDATED,
          ApplicationFacade.USER_DELETED, ApplicationFacade.CANCEL_SELECTED, ApplicationFacade.USER_SELECTED,
          ApplicationFacade.ADD_ROLE_RESULT];
    }

    override public function handleNotification(p_note:INotification):void {
      switch (p_note.getName()) {
        case ApplicationFacade.NEW_USER: {
          clearForm();
          break;
        }
        case ApplicationFacade.USER_ADDED: {
          rolePanel.user = p_note.getBody() as UserVO;
          var roleVO:RoleVO = new RoleVO(rolePanel.user.username);
          roleProxy.addItem(roleVO);
          clearForm();
          break;
        }
        case ApplicationFacade.USER_UPDATED: {
          clearForm();
          break;
        }
        case ApplicationFacade.USER_DELETED: {
          clearForm();
          break;
        }
        case ApplicationFacade.CANCEL_SELECTED: {
          clearForm();
          break;
        }
        case ApplicationFacade.USER_SELECTED: {
          rolePanel.user = p_note.getBody() as UserVO;
          rolePanel.userRoles = roleProxy.getUserRoles(rolePanel.user.username);
          rolePanel.roleCombo.selectedItem = RoleEnum.NONE_SELECTED;
          break;
        }
        case ApplicationFacade.ADD_ROLE_RESULT: {
          rolePanel.userRoles = null;
          rolePanel.userRoles = roleProxy.getUserRoles(rolePanel.user.username);
          break;
        }
      }
    }

    private function clearForm():void {
      rolePanel.user = null;
      rolePanel.userRoles = null;
      rolePanel.roleCombo.selectedItem = RoleEnum.NONE_SELECTED;
    }
  }
}
