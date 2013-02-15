/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.vo {
  import mx.collections.ArrayCollection;

  /**
   * Version: $Revision: 275 $, $Date: 2008-01-22 19:16:11 +0100 (di, 22 jan 2008) $, $Author: dmurat1 $
   */
  [Bindable]
  public class RoleVO {
    public var username:String = "";
    public var roles:ArrayCollection = new ArrayCollection();

    public function RoleVO (p_username:String = null, p_roles:Array = null) {
      if (p_username != null) this.username = p_username;
      if (p_roles != null) this.roles = new ArrayCollection(p_roles);
    }
  }
}
