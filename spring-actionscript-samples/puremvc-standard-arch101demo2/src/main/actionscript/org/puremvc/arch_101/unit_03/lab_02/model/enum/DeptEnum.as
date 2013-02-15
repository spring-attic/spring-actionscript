/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.enum {
  [Bindable]
  /**
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   */
  public class DeptEnum  {
    public static const NONE_SELECTED:DeptEnum = new DeptEnum("--None Selected--", -1);
    public static const ACCT:DeptEnum = new DeptEnum("Accounting", 0);
    public static const SALES:DeptEnum = new DeptEnum("Sales", 1);
    public static const PLANT:DeptEnum = new DeptEnum("Plant", 2);
    public static const SHIPPING:DeptEnum = new DeptEnum("Shipping", 3);
    public static const QC:DeptEnum = new DeptEnum("Quality Control", 4);

    public var ordinal:int;
    public var value:String;

    public function DeptEnum (p_value:String, p_ordinal:int) {
      value = p_value;
      ordinal = p_ordinal;
    }

    public static function get list():Array {
      return [ACCT, SALES, PLANT];
    }

    public static function get comboList():Array {
      var cList:Array = DeptEnum.list;
      cList.unshift(NONE_SELECTED);
      return cList;
    }

    public function equals(p_enum:RoleEnum):Boolean {
      return (ordinal == p_enum.ordinal && value == p_enum.value);
    }

    public static function findByValue(p_value:String):DeptEnum {
      var retval:DeptEnum = null;
      switch (p_value) {
        case "Accounting": {
          retval = DeptEnum.ACCT;
          break;
        }
        case "Sales": {
          retval = DeptEnum.SALES;
          break;
        }
        case "Plant": {
          retval = DeptEnum.PLANT;
          break;
        }
        case "Shipping": {
          retval = DeptEnum.SHIPPING;
          break;
        }
        case "Quality Control": {
          retval = DeptEnum.QC;
          break;
        }
        default: {
          retval = DeptEnum.NONE_SELECTED;
          break;
        }
      }

      return retval;
    }
  }
}
