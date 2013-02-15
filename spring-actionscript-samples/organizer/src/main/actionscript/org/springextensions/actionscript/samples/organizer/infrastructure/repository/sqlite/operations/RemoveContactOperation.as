package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations {
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.ISQLiteDatabase;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.QueryOperation;

	public class RemoveContactOperation extends QueryOperation {
		
		public static const DELETE_SQL:String = "DELETE FROM Contacts WHERE id = :id";
		
		public function RemoveContactOperation(sqliteDatabase:ISQLiteDatabase, contact:Contact) {
			Assert.notNull(sqliteDatabase, "sqliteDatabase argument must not be null");
			Assert.notNull(contact, "contact argument must not be null");
			super(sqliteDatabase, DELETE_SQL, {id: contact.id});
		}
	}
}