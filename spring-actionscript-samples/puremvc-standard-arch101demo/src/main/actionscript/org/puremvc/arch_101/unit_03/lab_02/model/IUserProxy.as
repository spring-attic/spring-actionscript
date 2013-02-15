package org.puremvc.arch_101.unit_03.lab_02.model {
  import mx.collections.ArrayCollection;

  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public interface IUserProxy {
    function loadUsers():void;
    function get users():ArrayCollection;
    function addItem(p_item:Object):void;
    function updateItem(p_item:Object):void;
    function deleteItem(p_item:Object):void;
  }
}
