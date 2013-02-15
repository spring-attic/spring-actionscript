package org.puremvc.arch_101.unit_03.lab_02 {
  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public final class MediatorNames {
    public static const APPLICATION_MDR:String = "applicationMediator";
    public static const ROLE_PANEL_MDR:String = "rolePanelMediator";
    public static const USER_FORM_MDR:String = "userFormMediator";
    public static const USER_LIST_MDR:String = "userListMediator";

    public final function MediatorNames() {
      throw new Error("This class is only constants container. It can't be instantiated.");
    }
  }
}
