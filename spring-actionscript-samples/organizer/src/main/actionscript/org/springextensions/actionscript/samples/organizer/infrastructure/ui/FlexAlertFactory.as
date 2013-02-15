package org.springextensions.actionscript.samples.organizer.infrastructure.ui
{
	import mx.controls.Alert;
	

	
	public class FlexAlertFactory
	{
		public function FlexAlertFactory()
		{
		}
		
		public function createAlert(text:String, title:String, flags:uint, closeHandler:Function):void
		{
			Alert.show(text, title, flags, null, closeHandler);
		}
	}
}