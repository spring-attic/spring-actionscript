package org.puremvc.arch_101.unit_03.lab_02 {
  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public final class CommandNames {
    public static const STARTUP_CMD:String = "startupCommand";
    public static const DELETE_USER_CMD:String = "deleteUserCommand";

    public final function CommandNames() {
      throw new Error("This class is only constants container. It can't be instantiated.");
    }
  }
}
