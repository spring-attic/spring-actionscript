/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.vo {
  import mx.collections.ArrayCollection;

  /**
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
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
