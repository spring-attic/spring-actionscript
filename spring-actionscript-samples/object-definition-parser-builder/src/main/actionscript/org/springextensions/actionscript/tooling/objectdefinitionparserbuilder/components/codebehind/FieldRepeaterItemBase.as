package org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.components.codebehind
{
	import flash.events.Event;
	
	import mx.containers.FormItem;
	import mx.containers.FormItemDirection;
	import mx.controls.CheckBox;
	import mx.controls.TextInput;
	
	import org.springextensions.actionscript.tooling.objectdefinitionparserbuilder.classes.FieldExportInfo;
	
	public class FieldRepeaterItemBase extends FormItem {
		
		[Bindable]
		public var cbUse:CheckBox;
		[Bindable]
		public var cbRequired:CheckBox;
		[Bindable]
		public var tiAttrName:TextInput;
		[Bindable]
		public var tiConstName:TextInput;
		
		public function FieldRepeaterItemBase() {
			super();
			direction = FormItemDirection.HORIZONTAL;
		}
		
		[Bindable]
		public var fieldExportInfo:FieldExportInfo;
		
		protected function generic_changeHandler(event:Event):void {
			switch(event.target) {
				case cbUse:
					fieldExportInfo.useInExport = cbUse.selected;
					break;
				case cbRequired:
					fieldExportInfo.isRequired = cbRequired.selected;
					break;
				default:
					break;
			}
		}
		
		protected function generic_commitHandler(event:Event):void{
			switch(event.target) {
				case tiAttrName:
					fieldExportInfo.xmlName = tiAttrName.text;
					break;
				case tiConstName:
					fieldExportInfo.constantName = tiConstName.text;
					break;
				default:
					break;
			}
		}
		
	}
}