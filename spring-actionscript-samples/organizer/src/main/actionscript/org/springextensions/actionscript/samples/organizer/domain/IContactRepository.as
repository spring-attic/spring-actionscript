package org.springextensions.actionscript.samples.organizer.domain
{
	import org.springextensions.actionscript.core.operation.IOperation;

	public interface IContactRepository
	{
		/**
		 * Returns all contacts.
		 *
		 * @return an async operation for which the result is an ArrayCollection of type Contact
		 */
		function getContacts():IOperation /* <ArrayCollection<Contact>> */;
		
		/**
		 * Returns a contact that matches the given name.
		 */
		function getContactsByName(name:String):IOperation /* <Contact> */;
		
		/**
		 * Saves a contact. Handles both create and update.
		 *
		 * @param contact the Contact to save
		 */
		function save(contact:Contact):IOperation;
		
		/**
		 * Removes a contact.
		 *
		 * @param contact the Contact to remove
		 */
		function remove(contact:Contact):IOperation;
	}
}