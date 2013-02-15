/*
  PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.controller {
  import mx.controls.Alert;

  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.command.IocSimpleCommand;

  /**
   * Version: $Revision: 432 $, $Date: 2008-03-27 11:02:00 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   */
  public class AddRoleResultCommand extends IocSimpleCommand {
    override public function execute(p_notification:INotification):void {
      var result:Boolean = p_notification.getBody() as Boolean;
      if (result == false) {
        Alert.show("Role already exists for this user!", "Add User Role");
      }
    }
  }
}
