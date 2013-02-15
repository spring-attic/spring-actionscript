package {
  import mx.logging.targets.TraceTarget;

  import org.puremvc.arch_101.unit_03.lab_02.controller.DeleteUserCommand;
  import org.puremvc.arch_101.unit_03.lab_02.controller.StartupCommand;
  import org.puremvc.arch_101.unit_03.lab_02.model.delegate.impl.UserLoadDelegate;
  import org.puremvc.arch_101.unit_03.lab_02.model.impl.RoleProxy;
  import org.puremvc.arch_101.unit_03.lab_02.model.impl.UserProxy;
  import org.puremvc.arch_101.unit_03.lab_02.view.mediator.RolePanelMediator;
  import org.puremvc.arch_101.unit_03.lab_02.view.mediator.UserListMediator;
  import org.springextensions.actionscript.collections.IMap;
  import org.springextensions.actionscript.collections.Map;
  import org.springextensions.actionscript.ioc.IObjectDefinition;
  import org.springextensions.actionscript.ioc.ObjectDefinition;
  import org.springextensions.actionscript.ioc.factory.MethodInvokingObject;
  import org.springextensions.actionscript.puremvc.patterns.command.IocMacroCommand;

  /**
   * Author: Damir Murat
   * Version: $Revision: 436 $, $Date: 2008-03-27 13:18:27 +0100 (do, 27 mrt 2008) $, $Author: dmurat1 $
   * Since: 0.4
   */
  public class LinkageEnforcer {
    // Here must be listed all classes that are used in the IoC configuration and are not mentioned anywhere in the
    // source. This is needed so that a compiler links them in a produced swf. Of course, final implementation should
    // be based on compiler settings, but this is quick workaround.
    private var linkageEnforcer:Object = {
      prop1:TraceTarget,
      prop2:MethodInvokingObject,
      prop3:RoleProxy,
      prop4:UserProxy,
      prop5:UserLoadDelegate,
      prop6:UserListMediator,
      prop8:IObjectDefinition,
      prop9:ObjectDefinition,
      prop11:IMap,
      prop12:Map,
      prop13:IocMacroCommand,
      prop14:StartupCommand,
      prop15:RolePanelMediator,
      prop16:DeleteUserCommand
    };

    public function LinkageEnforcer() {
      super();
    }
  }
}
