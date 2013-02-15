/*
  PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.view.mediator {
  import flash.events.Event;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.model.IUserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.enum.DeptEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.puremvc.arch_101.unit_03.lab_02.view.component.UserForm;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.mediator.IocMediator;

  /**
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   */
  public class UserFormMediator extends IocMediator {
    private var m_userProxy:IUserProxy;

    public function UserFormMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);
    }

    override public function setViewComponent(p_viewComponent:Object):void {
      if (getViewComponent() != null) {
        userForm.removeEventListener(UserForm.ADD, onAdd);
        userForm.removeEventListener(UserForm.UPDATE, onUpdate);
        userForm.removeEventListener(UserForm.CANCEL, onCancel);
      }

      super.setViewComponent(p_viewComponent);

      init();
    }

    public function init():void {
      userForm.addEventListener(UserForm.ADD, onAdd);
      userForm.addEventListener(UserForm.UPDATE, onUpdate);
      userForm.addEventListener(UserForm.CANCEL, onCancel);
    }

    public function set userProxy(p_userProxy:IUserProxy):void {
      m_userProxy = p_userProxy;
    }

    public function get userProxy():IUserProxy {
      return m_userProxy;
    }

    private function get userForm():UserForm {
      return getViewComponent() as UserForm;
    }

    private function onAdd(p_event:Event):void {
      var user:UserVO = userForm.user;
      userProxy.addItem(user);
      sendNotification(ApplicationFacade.USER_ADDED, user);
      clearForm();
    }

    private function onUpdate(p_event:Event):void {
      var user:UserVO = userForm.user;
      userProxy.updateItem(user);
      sendNotification(ApplicationFacade.USER_UPDATED, user);
      clearForm();
    }

    private function onCancel(event:Event):void {
      sendNotification(ApplicationFacade.CANCEL_SELECTED);
      clearForm();
    }

    override public function listNotificationInterests():Array {
      return [ApplicationFacade.NEW_USER, ApplicationFacade.USER_DELETED, ApplicationFacade.USER_SELECTED];
    }

    override public function handleNotification(p_note:INotification):void {
      switch (p_note.getName()) {
        case ApplicationFacade.NEW_USER: {
          userForm.user = p_note.getBody() as UserVO;
          userForm.mode = UserForm.MODE_ADD;
          userForm.first.setFocus();
          break;
        }
        case ApplicationFacade.USER_DELETED: {
          userForm.user = null;
          clearForm();
          break;
        }
        case ApplicationFacade.USER_SELECTED: {
          userForm.user = p_note.getBody() as UserVO;
          userForm.mode = UserForm.MODE_EDIT;
          userForm.first.setFocus();
          userForm.first.setSelection(userForm.first.length, userForm.first.length);
          break;
        }
      }
    }

    private function clearForm():void {
      userForm.user = null;
      userForm.username.text = "";
      userForm.first.text = "";
      userForm.last.text = "";
      userForm.email.text = "";
      userForm.password.text = "";
      userForm.confirm.text = "";
      userForm.department.selectedItem = DeptEnum.NONE_SELECTED;
    }
  }
}
