package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations
{
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.ISQLiteDatabase;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.QueryOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteResultEvent;
	
	public class SaveContactOperation extends QueryOperation {
		
		public static const INSERT_SQL:String = "INSERT INTO Contacts (id,firstName,lastName,email,phone,address,city,state,zip,dob,pic) " +
												"values " +
												"(:id,:firstName,:lastName,:email,:phone,:address,:city,:state,:zip,:dob,:pic);\n" +
												"SELECT last_insert_rowid() as newid;";
		
		public static const UPDATE_SQL:String = "UPDATE Contacts SET " +
												"firstName=:firstName,lastName=:lastName,email=:email,phone=:phone,address=:address,"+
												"city=:city,state=:state,zip=:zip,dob=:dob,pic=:pic " +
												"WHERE id = :id";

		private var _contact:Contact;
		
		public function SaveContactOperation(sqliteDatabase:ISQLiteDatabase, contact:Contact) {
			Assert.notNull(sqliteDatabase,"sqliteDatabase argument must not be null");
			Assert.notNull(contact,"contact argument must not be null");
			_contact = contact;
			var sql:String = (contact.id < 1) ? INSERT_SQL : UPDATE_SQL;
			super(sqliteDatabase, sql, _contact.toPlainObject());
		}

		override protected function sqliteresult_handler(event:SQLiteResultEvent):void {
			if (_contact.id < 1){
				var arr:Array = event.sqlResult.data as Array;
				if ((arr != null) && (arr.length > 0)){
					_contact.id = arr[0].newid;
				}
			}
			dispatchCompleteEvent();
		}

	}
}