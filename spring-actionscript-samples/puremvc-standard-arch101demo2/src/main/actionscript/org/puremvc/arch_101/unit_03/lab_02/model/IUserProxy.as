package org.puremvc.arch_101.unit_03.lab_02.model {
  import mx.collections.ArrayCollection;

  /**
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
   */
  public interface IUserProxy {
    function loadUsers():void;
    function get users():ArrayCollection;
    function addItem(p_item:Object):void;
    function updateItem(p_item:Object):void;
    function deleteItem(p_item:Object):void;
  }
}
