package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations {
	import mx.collections.ArrayCollection;
	
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.ISQLiteDatabase;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.QueryOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.SimpleRowMapper;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteResultEvent;

	public class GetContactsByNameOperation extends QueryOperation {
		
		public static const SELECT_SQL:String = "SELECT * FROM Contacts where firstName LIKE :name OR lastName LIKE :name";
		
		public function GetContactsByNameOperation(sqliteDatabase:ISQLiteDatabase, name:String) {
			super(sqliteDatabase, SELECT_SQL, {name: '%'+name+'%'}, new SimpleRowMapper(Contact));
		}

		override protected function sqliteresult_handler(event:SQLiteResultEvent):void {
			var recordset:Array=(event.sqlResult.data as Array);
			if (recordset != null) {
				result = new ArrayCollection(recordset);
			} else {
				result = new ArrayCollection();
			}
			dispatchCompleteEvent();
		}
	}
}
