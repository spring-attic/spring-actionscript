package org.puremvc.arch_101.unit_03.lab_02.model {
  import mx.collections.ArrayCollection;

  import org.puremvc.arch_101.unit_03.lab_02.model.enum.RoleEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;

  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public interface IRoleProxy {
    function get roles():ArrayCollection;
    function addItem(p_item:Object):void;
    function deleteItem(p_item:Object):void;
    function doesUserHaveRole(p_user:UserVO, p_role:RoleEnum):Boolean;
    function addRoleToUser(p_user:UserVO, p_role:RoleEnum):void;
    function removeRoleFromUser(p_user:UserVO, p_role:RoleEnum):void;
    function getUserRoles(p_username:String):ArrayCollection;
  }
}
