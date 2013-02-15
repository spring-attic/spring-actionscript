/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.vo {
  import org.puremvc.arch_101.unit_03.lab_02.model.enum.DeptEnum;

  /**
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   */
  [Bindable]
  public class UserVO {
    public var username:String = "";
    public var fname:String = "";
    public var lname:String = "";
    public var email:String = "";
    public var password:String = "";
    public var department:DeptEnum = DeptEnum.NONE_SELECTED;

    public function UserVO (
        p_uname:String = null, p_fname:String = null, p_lname:String = null, p_email:String = null,
        p_password:String = null, p_department:DeptEnum = null)
    {
      if (p_uname != null) this.username = p_uname;
      if (p_fname != null) this.fname = p_fname;
      if (p_lname != null) this.lname = p_lname;
      if (p_email != null) this.email = p_email;
      if (p_password != null) this.password = p_password;
      if (p_department != null) this.department = p_department;
    }

    public function get isValid():Boolean {
      return username != "" && password != "" && department != DeptEnum.NONE_SELECTED;
    }

    public function get givenName():String {
      return this.lname + ", " + this.fname;
    }
  }
}
