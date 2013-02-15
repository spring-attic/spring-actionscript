package org.puremvc.arch_101.unit_03.lab_02.model {
  import mx.collections.ArrayCollection;

  import org.puremvc.arch_101.unit_03.lab_02.model.enum.RoleEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;

  /**
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
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
