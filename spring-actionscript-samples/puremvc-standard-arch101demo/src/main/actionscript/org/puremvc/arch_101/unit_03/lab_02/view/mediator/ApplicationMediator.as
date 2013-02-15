package org.puremvc.arch_101.unit_03.lab_02.view.mediator {
  import mx.managers.CursorManager;

  import org.puremvc.arch_101.unit_03.lab_02.ApplicationFacade;
  import org.puremvc.as3.interfaces.INotification;
  import org.springextensions.actionscript.puremvc.patterns.mediator.IocMediator;

  /**
   * Author: Damir Murat
   * Version: $Revision: 450 $, $Date: 2008-03-27 23:39:50 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public class ApplicationMediator extends IocMediator {
//    public static const NAME:String = "applicationMediator";

    private var m_remotingStartedCounter:int;

    public function ApplicationMediator(p_mediatorName:String = null, p_viewComponent:Object = null) {
      super(p_mediatorName, p_viewComponent);

      m_remotingStartedCounter = 0;
    }

    private function get app():PranaSamplePureMvcArch101Demo {
      return getViewComponent() as PranaSamplePureMvcArch101Demo;
    }

    override public function listNotificationInterests():Array {
      return [ApplicationFacade.REMOTING_STARTED, ApplicationFacade.REMOTING_FINISHED];
    }

    override public function handleNotification(p_note:INotification):void {
      switch (p_note.getName()) {
        case ApplicationFacade.REMOTING_STARTED: {
          m_remotingStartedCounter++;
          if (m_remotingStartedCounter > 0) {
            CursorManager.setBusyCursor();
            app.enabled = false;
          }

          break;
        }
        case ApplicationFacade.REMOTING_FINISHED: {
          m_remotingStartedCounter--;
          if (m_remotingStartedCounter < 1) {
            CursorManager.removeBusyCursor();
            app.enabled = true;
          }

          break;
        }
      }
    }
  }
}
