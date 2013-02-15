package org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.components.codebehind
{
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.core.Repeater;
	
	public class FieldRepeaterBase extends VBox {
		
		[Bindable]
		public var mainrepeater:Repeater;
		
		public function FieldRepeaterBase()	{
			super();
		}
		
		private var _dataProvider:Array;
		public function get dataProvider():Array{
			return _dataProvider;
		}
		[Bindable(event="dataProviderChanged")]
		public function set dataProvider(value:Array):void {
			if (value !== _dataProvider) {
				_dataProvider = value;
				dispatchEvent(new Event("dataProviderChanged"));
			}
		}
	}
}