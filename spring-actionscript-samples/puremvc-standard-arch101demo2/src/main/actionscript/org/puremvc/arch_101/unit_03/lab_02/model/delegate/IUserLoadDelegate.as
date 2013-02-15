package org.puremvc.arch_101.unit_03.lab_02.model.delegate {
  import flash.events.IEventDispatcher;

  /**
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
   */
  public interface IUserLoadDelegate extends IEventDispatcher {
    function loadUsers():void;
  }
}
