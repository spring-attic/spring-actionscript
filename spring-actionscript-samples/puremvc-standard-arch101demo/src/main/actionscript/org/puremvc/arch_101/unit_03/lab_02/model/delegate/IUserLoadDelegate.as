package org.puremvc.arch_101.unit_03.lab_02.model.delegate {
  import flash.events.IEventDispatcher;

  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public interface IUserLoadDelegate extends IEventDispatcher {
    function loadUsers():void;
  }
}
