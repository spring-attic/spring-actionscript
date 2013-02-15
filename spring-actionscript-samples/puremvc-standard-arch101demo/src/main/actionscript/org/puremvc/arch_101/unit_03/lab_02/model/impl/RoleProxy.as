/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.impl {
  import mx.collections.ArrayCollection;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.arch_101.unit_03.lab_02.model.IRoleProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.enum.RoleEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.RoleVO;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;
  import org.springextensions.actionscript.puremvc.patterns.proxy.IocProxy;

  /**
   * Version: $Revision: 275 $, $Date: 2008-01-22 19:16:11 +0100 (di, 22 jan 2008) $, $Author: dmurat1 $
   */
  public class RoleProxy extends IocProxy implements IRoleProxy {
    public function RoleProxy() {
      super(NAME, new ArrayCollection());

      // generate some test data
      addItem(new RoleVO("lstooge", [RoleEnum.PAYROLL, RoleEnum.EMP_BENEFITS]));
      addItem(new RoleVO("cstooge", [RoleEnum.ACCT_PAY, RoleEnum.ACCT_RCV, RoleEnum.GEN_LEDGER]));
      addItem(new RoleVO("mstooge", [RoleEnum.INVENTORY, RoleEnum.PRODUCTION, RoleEnum.SALES, RoleEnum.SHIPPING]));
    }

    // get the data property cast to the appropriate type
    public function get roles():ArrayCollection {
      return data as ArrayCollection;
    }

    // add an item to the data
    public function addItem(p_item:Object):void {
      roles.addItem(p_item);
    }

    // delete an item from the data
    public function deleteItem(p_item:Object):void {
      for (var i:int = 0; i < roles.length; i++) {
        if (roles.getItemAt(i).username == p_item.username) {
          roles.removeItemAt(i);
          break;
        }
      }
    }

    // determine if the user has a given role
    public function doesUserHaveRole(p_user:UserVO, p_role:RoleEnum):Boolean {
      var hasRole:Boolean = false;
      for (var i:int = 0; i < roles.length; i++) {
        if (roles.getItemAt(i).username == p_user.username) {
          var userRoles:ArrayCollection = roles.getItemAt(i).roles as ArrayCollection;
          for (var j:int = 0; j < userRoles.length; j++) {
            if (RoleEnum(userRoles.getItemAt(j)).equals(p_role)) {
              hasRole = true;
              break;
            }
          }

          break;
        }
      }

      return hasRole;
    }

    // add a role to this user
    public function addRoleToUser(p_user:UserVO, p_role:RoleEnum):void {
      var result:Boolean = false;
      if (!doesUserHaveRole(p_user, p_role)) {
        for (var i:int = 0; i < roles.length; i++) {
          if (roles.getItemAt(i).username == p_user.username) {
            var userRoles:ArrayCollection = roles.getItemAt(i).roles as ArrayCollection;
            userRoles.addItem(p_role);
            result = true;
            break;
          }
        }
      }

      sendNotification(ApplicationFacade.ADD_ROLE_RESULT, result);
    }

    // remove a role from the user
    public function removeRoleFromUser(p_user:UserVO, p_role:RoleEnum):void {
      if (doesUserHaveRole(p_user, p_role)) {
        for (var i:int = 0; i < roles.length; i++) {
          if (roles.getItemAt(i).username == p_user.username) {
            var userRoles:ArrayCollection = roles.getItemAt(i).roles as ArrayCollection;
            for (var j:int = 0; j < userRoles.length; j++) {
              if (RoleEnum(userRoles.getItemAt(j)).equals(p_role)) {
                userRoles.removeItemAt(j);
                break;
              }
            }

            break;
          }
        }
      }
    }

    // get a user's roles
    public function getUserRoles(p_username:String):ArrayCollection {
      var userRoles:ArrayCollection = new ArrayCollection();
      for (var i:int = 0; i < roles.length; i++) {
        if (roles.getItemAt(i).username == p_username) {
          userRoles = roles.getItemAt(i).roles as ArrayCollection;
          break;
        }
      }

      return userRoles;
    }
  }
}
