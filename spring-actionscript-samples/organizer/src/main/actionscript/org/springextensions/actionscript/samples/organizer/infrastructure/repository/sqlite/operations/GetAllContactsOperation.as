package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.operations {
	import mx.collections.ArrayCollection;
	
	import org.springextensions.actionscript.samples.organizer.domain.Contact;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.ISQLiteDatabase;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.QueryOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.SimpleRowMapper;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteResultEvent;

	public class GetAllContactsOperation extends QueryOperation {
		
		public static const SELECT_SQL:String = "SELECT * FROM Contacts"; 
		
		public function GetAllContactsOperation(sqliteDatabase:ISQLiteDatabase) {
			super(sqliteDatabase, SELECT_SQL, null, new SimpleRowMapper(Contact));
		}

		override protected function sqliteresult_handler(event:SQLiteResultEvent):void {
			result=new ArrayCollection(event.sqlResult.data as Array);
			dispatchCompleteEvent();
		}

	}
}