package org.puremvc.arch_101.unit_03.lab_02.event {
  import flash.events.Event;

  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public class DataLoadingEvent extends Event {
    public static const INVOKE:String = "dataLoadingInvoke";
    public static const RESULT:String = "dataLoadingResult";
    public static const FAULT:String = "dataLoadingFault";

    private var m_data:Object = null;

    public function DataLoadingEvent(p_type:String, p_data:Object = null) {
      super(p_type, false, false);

      m_data = p_data;
    }

    public function get data():Object {
      return m_data;
    }

    override public function clone():Event {
      var clonedEvent:DataLoadingEvent = new DataLoadingEvent(type, data);
      return clonedEvent;
    }
  }
}
