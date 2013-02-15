package org.puremvc.arch_101.unit_03.lab_02.event {
  import flash.events.Event;

  /**
   * <b>Author:</b> Damir Murat<br/>
   * <b>Version:</b> $Revision: 761 $, $Date: 2008-06-07 12:47:18 +0200 (za, 07 jun 2008) $, $Author: dmurat1 $<br/>
   * <b>Since:</b> 0.6
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
