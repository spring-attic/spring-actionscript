/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.impl {
  import mx.collections.ArrayCollection;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.event.DataLoadingEvent;
  import org.puremvc.arch_101.unit_03.lab_02.model.IUserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.delegate.IUserLoadDelegate;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.springextensions.actionscript.puremvc.patterns.proxy.IocProxy;

  /**
   * Version: $Revision: 315 $, $Date: 2008-02-03 13:27:00 +0100 (zo, 03 feb 2008) $, $Author: dmurat1 $
   */
  public class UserProxy extends IocProxy implements IUserProxy {
    private var m_userLoadDelegate:IUserLoadDelegate;

    public function UserProxy() {
      super(NAME, new ArrayCollection());
    }

    public function set userLoadDelegate(p_userLoadDelegate:IUserLoadDelegate):void {
      m_userLoadDelegate = p_userLoadDelegate;
    }

    public function loadUsers():void {
      var userLoadDelegate:IUserLoadDelegate = m_userLoadDelegate;

      userLoadDelegate.addEventListener(DataLoadingEvent.INVOKE, onUsersLoadingInvoked);
      userLoadDelegate.addEventListener(DataLoadingEvent.RESULT, onUsersLoaded);
      userLoadDelegate.addEventListener(DataLoadingEvent.FAULT, onUsersLoadingFailed);

      userLoadDelegate.loadUsers();
    }

    private function onUsersLoadingInvoked(p_event:DataLoadingEvent):void {
      var userLoadDelegateTarget:IUserLoadDelegate = p_event.currentTarget as IUserLoadDelegate;
      userLoadDelegateTarget.removeEventListener(DataLoadingEvent.INVOKE, onUsersLoadingInvoked);

      sendNotification(ApplicationFacade.REMOTING_STARTED);
    }

    private function onUsersLoaded(p_event:DataLoadingEvent):void {
      var userLoadDelegateTarget:IUserLoadDelegate = p_event.currentTarget as IUserLoadDelegate;
      userLoadDelegateTarget.removeEventListener(DataLoadingEvent.RESULT, onUsersLoaded);

      var loadedUserCollection:ArrayCollection = p_event.data as ArrayCollection;
      for (var i:int = 0; i < loadedUserCollection.length; i++) {
        addItem(loadedUserCollection.getItemAt(i));
      }

      sendNotification(ApplicationFacade.REMOTING_FINISHED);
    }

    private function onUsersLoadingFailed(p_event:DataLoadingEvent):void {
      var userLoadDelegateTarget:IUserLoadDelegate = p_event.currentTarget as IUserLoadDelegate;
      userLoadDelegateTarget.removeEventListener(DataLoadingEvent.FAULT, onUsersLoadingFailed);

      trace(p_event.data);
      sendNotification(ApplicationFacade.REMOTING_FINISHED);
    }

    // return data property cast to proper type
    public function get users():ArrayCollection {
      return data as ArrayCollection;
    }

    // add an item to the data
    public function addItem(p_item:Object):void {
      users.addItem(p_item);
    }

    // update an item in the data
    public function updateItem(p_item:Object):void {
      var user:UserVO = p_item as UserVO;
      for (var i:int = 0; i < users.length; i++) {
        if (users[i].username == user.username) {
          users[i] = user;
        }
      }
    }

    // delete an item in the data
    public function deleteItem(p_item:Object):void {
      var user:UserVO = p_item as UserVO;
      for (var i:int = 0; i < users.length; i++) {
        if (users[i].username == user.username) {
          users.removeItemAt(i);
        }
      }
    }
  }
}
