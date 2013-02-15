package org.springextensions.actionscript.samples.organizer.infrastructure.ui
{
	import com.adobe.air.alert.NativeAlert;
	
	import org.springextensions.actionscript.samples.organizer.application.IAlertFactory;
	
	public class AIRAlertFactory implements IAlertFactory
	{
		public function AIRAlertFactory()
		{
		}
		
		public function createAlert(text:String, title:String, flags:uint = 4, closeHandler:Function = null):void
		{
			NativeAlert.show(text, title, flags, true, null, closeHandler);
		}
	}
}