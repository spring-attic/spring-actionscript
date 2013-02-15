package org.springextensions.actionscript.samples.organizer.domain {
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	
	
	public class ContactCollection extends ArrayCollection {
		
		public function ContactCollection(source:Array = null) {
			super(source);
			sort = new Sort();
			sort.fields = [new SortField("lastName", true)];
		}
		
		public function deleteContact(contact:Contact):void {
			for (var i:int = 0; i<length; i++) {
				var c:Contact = this[i];
				if (contact === c || (contact.id === c.id)) {
					removeItemAt(i);
					break;
				}
			}
		}
		
	}
}