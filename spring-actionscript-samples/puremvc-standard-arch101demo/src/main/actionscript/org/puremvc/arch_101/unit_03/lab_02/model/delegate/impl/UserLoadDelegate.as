package org.puremvc.arch_101.unit_03.lab_02.model.delegate.impl {
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  import mx.collections.ArrayCollection;
  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;
  import mx.rpc.http.HTTPService;

  import org.puremvc.arch_101.unit_03.lab_02.event.DataLoadingEvent;
  import org.puremvc.arch_101.unit_03.lab_02.model.delegate.IUserLoadDelegate;
  import org.puremvc.arch_101.unit_03.lab_02.model.enum.DeptEnum;
  import org.puremvc.arch_101.unit_03.lab_02.model.vo.UserVO;

  /**
   * Author: Damir Murat
   * Version: $Revision: 725 $, $Date: 2008-05-27 18:09:32 +0200 (di, 27 mei 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public class UserLoadDelegate extends EventDispatcher implements IResponder, IUserLoadDelegate {
    private var m_serviceUrl:String;
    private var m_service:HTTPService;

    public function UserLoadDelegate() {
      super();

      m_service = new HTTPService();
      m_service.resultFormat = "e4x";
    }

    public function set serviceUrl(p_serviceUrl:String):void {
      m_serviceUrl = p_serviceUrl;
      m_service.url = m_serviceUrl;
    }

    public function loadUsers():void {
      dispatchEvent(new DataLoadingEvent(DataLoadingEvent.INVOKE));

      // Simulating slow loading
      var timer:Timer = new Timer(3000, 1);
      timer.addEventListener(TimerEvent.TIMER, onTimer);
      timer.start();
    }

    private function onTimer(p_event:TimerEvent):void {
      var timer:Timer = p_event.currentTarget as Timer;
      timer.stop();
      timer.removeEventListener(TimerEvent.TIMER, onTimer);

      var asyncToken:AsyncToken = m_service.send();
      asyncToken.addResponder(this);
    }

    public function result(p_data:Object):void {
      var resultXml:XML = p_data.result as XML;
      var resultXmlList:XMLList = resultXml.user;
      var userCollection:ArrayCollection = new ArrayCollection();

      for (var i:int = 0; i < resultXmlList.length(); i++) {
        var xmlElement:XML = resultXmlList[i];
        var username:String = xmlElement.@username;
        var fname:String = xmlElement.@fname;
        var lname:String = xmlElement.@lname;
        var email:String = xmlElement.@email;
        var password:String = xmlElement.@password;
        var departmentCode:String = xmlElement.@department;
        var department:DeptEnum = DeptEnum.findByValue(departmentCode);

        var user:UserVO = new UserVO(username, fname, lname, email, password, department);
        userCollection.addItem(user);
      }

      dispatchEvent(new DataLoadingEvent(DataLoadingEvent.RESULT, userCollection));
    }

    public function fault(p_info:Object):void {
      trace(p_info);
      dispatchEvent(new DataLoadingEvent(DataLoadingEvent.FAULT, p_info));
    }
  }
}
