package org.springextensions.actionscript.samples.organizer.infrastructure.repository {
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.core.operation.IOperation;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.domain.IContactRepository;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.ISQLiteDatabase;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations.GetAllContactsOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations.GetContactsByNameOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations.RemoveContactOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations.SaveContactOperation;

public class ContactSqliteRepository implements IContactRepository {
		
		private var _sqliteDatabase:ISQLiteDatabase;
		
		public function ContactSqliteRepository(sqliteDatabase:ISQLiteDatabase) {
			_sqliteDatabase = sqliteDatabase;
			if (!_sqliteDatabase.connection.connected){
				_sqliteDatabase.open();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getContacts():IOperation {
			return new GetAllContactsOperation(_sqliteDatabase);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getContactsByName(name:String):IOperation {
			Assert.hasText(name,"name argument must not be null or empty");
			return new GetContactsByNameOperation(_sqliteDatabase,name);
		}
		
		/**
		 * @inheritDoc
		 */
		public function save(contact:Contact):IOperation {
			Assert.notNull(contact,"contact argument must not be null");
			return new SaveContactOperation(_sqliteDatabase,contact);
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove(contact:Contact):IOperation {
			Assert.notNull(contact,"contact argument must not be null");
			return new RemoveContactOperation(_sqliteDatabase,contact);
		}
	}
}