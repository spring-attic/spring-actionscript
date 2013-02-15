package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import org.springextensions.actionscript.core.operation.AbstractOperation;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteErrorEvent;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteResultEvent;
	
	public class QueryOperation extends AbstractOperation
	{
		public function QueryOperation(sqliteDatabase:ISQLiteDatabase, sql:String, parameters:Object=null, rowMapper:IRowMapper=null)
		{
			super();
			var query:Query = new Query();
			query.sql = sql;
			if (parameters != null){
				query.parameters = parameters;
			}
			sqliteDatabase.addEventListener(SQLiteResultEvent.SQLITE_RESULT,sqliteresult_handler,false,0,true);
			sqliteDatabase.addEventListener(SQLiteErrorEvent.SQLITE_ERROR,sqliteerror_handler,false,0,true);
			sqliteDatabase.executeQuery(query, rowMapper);
		}
		
		protected function sqliteresult_handler(event:SQLiteResultEvent):void {
			result = event.sqlResult.data;
			dispatchCompleteEvent();
		}

		protected function sqliteerror_handler(event:SQLiteErrorEvent):void {
			error = event.errorEvent;
			dispatchErrorEvent();
		}

	}
}