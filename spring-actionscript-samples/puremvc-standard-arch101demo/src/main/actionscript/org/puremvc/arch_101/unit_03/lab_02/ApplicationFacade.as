/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02 {
  import org.puremvc.arch_101.unit_03.lab_02.controller.AddRoleResultCommand;
  import org.springextensions.actionscript.puremvc.interfaces.IIocFacade;
  import org.springextensions.actionscript.puremvc.patterns.facade.IocFacade;

  /**
   * Version: $Revision: 738 $, $Date: 2008-06-05 19:15:07 +0200 (do, 05 jun 2008) $, $Author: dmurat1 $
   */
  public class ApplicationFacade extends IocFacade implements IIocFacade {
    // Notification name constants
    public static const STARTUP:String = "startup";

    public static const REMOTING_STARTED:String = "remotingStarted";
    public static const REMOTING_FINISHED:String = "remotingFinished";

    public static const NEW_USER:String = "newUser";
    public static const DELETE_USER:String = "deleteUser";
    public static const CANCEL_SELECTED:String = "cancelSelected";

    public static const USER_SELECTED:String = "userSelected";
    public static const USER_ADDED:String = "userAdded";
    public static const USER_UPDATED:String = "userUpdated";
    public static const USER_DELETED:String = "userDeleted";

    public static const ADD_ROLE:String = "addRole";
    public static const ADD_ROLE_RESULT:String = "addRoleResult";

    public function ApplicationFacade(p_configuration:*) {
      super(p_configuration);
    }

    /**
     * Singleton ApplicationFacade Factory Method
     */
    public static function getInstance(p_configSource:* = null):ApplicationFacade {
      if (instance == null) {
        if (p_configSource == null) {
          throw new Error("Parameter p_configSource can't be null.");
        }

        new ApplicationFacade(p_configSource);
      }

      return instance as ApplicationFacade;
    }

    /**
     * Register Commands with the Controller
     */
    override protected function initializeController():void {
      super.initializeController();
      registerCommandByConfigName(STARTUP, CommandNames.STARTUP_CMD);
      registerCommandByConfigName(DELETE_USER, CommandNames.DELETE_USER_CMD);
      registerCommand(ADD_ROLE_RESULT, AddRoleResultCommand);
    }
  }
}
