package org.springextensions.actionscript.samples.organizer.application.model {
import org.as3commons.lang.Enum;

public class ContactsViewMode extends Enum {

	public static const LIST:ContactsViewMode = new ContactsViewMode("LIST");
	public static const TILES:ContactsViewMode = new ContactsViewMode("TILES");
	
	public function ContactsViewMode(name:String) {
		super(name);
	}
}
}