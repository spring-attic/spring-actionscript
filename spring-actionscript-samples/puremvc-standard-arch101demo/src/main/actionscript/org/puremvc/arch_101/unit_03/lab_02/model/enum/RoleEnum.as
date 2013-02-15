/*
   PureMVC Architecture 101 Course
  Copyright(c) 2007 FutureScale, Inc.  All rights reserved.
 */
package org.puremvc.arch_101.unit_03.lab_02.model.enum {
  [Bindable]
  /**
   * Version: $Revision: 275 $, $Date: 2008-01-22 19:16:11 +0100 (di, 22 jan 2008) $, $Author: dmurat1 $
   */
  public class RoleEnum {
    public static const NONE_SELECTED:RoleEnum = new RoleEnum("--None Selected--", -1);
    public static const ADMIN:RoleEnum = new RoleEnum("Administrator", 0);
    public static const ACCT_PAY:RoleEnum = new RoleEnum("Accounts Payable", 1);
    public static const ACCT_RCV:RoleEnum = new RoleEnum("Accounts Receivable", 2);
    public static const EMP_BENEFITS:RoleEnum = new RoleEnum("Employee Benefits", 3);
    public static const GEN_LEDGER:RoleEnum = new RoleEnum("General Ledger", 4);
    public static const PAYROLL:RoleEnum = new RoleEnum("Payroll", 5);
    public static const INVENTORY:RoleEnum = new RoleEnum("Inventory", 6);
    public static const PRODUCTION:RoleEnum = new RoleEnum("Production", 7);
    public static const QUALITY_CTL:RoleEnum = new RoleEnum("Quality Control", 8);
    public static const SALES:RoleEnum = new RoleEnum("Sales", 9);
    public static const ORDERS:RoleEnum = new RoleEnum("Orders", 10);
    public static const CUSTOMERS:RoleEnum = new RoleEnum("Customers", 11);
    public static const SHIPPING:RoleEnum = new RoleEnum("Shipping", 12);
    public static const RETURNS:RoleEnum = new RoleEnum("Returns", 13);

    public var ordinal:int;
    public var value:String;

    public function RoleEnum (p_value:String, p_ordinal:int) {
      value = p_value;
      ordinal = p_ordinal;
    }

    public static function get list():Array {
      return [
          ADMIN, ACCT_PAY, ACCT_RCV, EMP_BENEFITS, GEN_LEDGER, PAYROLL, INVENTORY, PRODUCTION, QUALITY_CTL, SALES,
          ORDERS, CUSTOMERS, SHIPPING, RETURNS];
    }

    public static function get comboList():Array {
      var cList:Array = RoleEnum.list;
      cList.unshift(NONE_SELECTED);
      return cList;
    }

    public function equals(p_enum:RoleEnum):Boolean {
      return (ordinal == p_enum.ordinal && value == p_enum.value);
    }
  }
}
