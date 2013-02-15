package org.springextensions.actionscript.samples.organizer.application
{
	import org.springextensions.actionscript.samples.organizer.domain.Contact;

	public interface IContactWindowManager
	{
		function openContact(contact:Contact):void;
		
		function closeContact(contact:Contact):void;
	}
}