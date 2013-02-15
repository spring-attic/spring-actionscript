package org.springextensions.actionscript.samples.organizer.application.events {
import flash.events.Event;

import org.springextensions.actionscript.samples.organizer.application.model.ContactsViewMode;

public class ChangeContactsViewModeEvent extends Event {

	public var mode:ContactsViewMode;

	public function ChangeContactsViewModeEvent(mode:ContactsViewMode) {
		super(ApplicationEvents.CHANGE_CONTACTS_VIEW_MODE);
		this.mode = mode;
	}

	override public function clone():Event {
		return new ChangeContactsViewModeEvent(mode);
	}
}
}