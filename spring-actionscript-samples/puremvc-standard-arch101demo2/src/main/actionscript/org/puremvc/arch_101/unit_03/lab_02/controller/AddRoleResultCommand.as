/*
  PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.controller {
  import mx.controls.Alert;

  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.command.IocSimpleCommand;

  /**
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
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
