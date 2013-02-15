package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.Query;
	
	public class SQLiteResultEvent extends Event
	{
		public static const SQLITE_RESULT:String = "SQLiteResult";
		
		private var _query:Query;
		public function get query():Query {
			return _query;
		}
		
		private var _statement:SQLStatement;
		public function get statement():SQLStatement {
			return _statement;
		}

		private var _sqlResult:SQLResult;
		public function get sqlResult():SQLResult {
			return _sqlResult;
		}

		public function SQLiteResultEvent(type:String, query:Query, statement:SQLStatement, sqlResult:SQLResult=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_query = query;
			_statement = statement;
			_sqlResult = sqlResult;
		}
		
		override public function clone():Event{
			return new SQLiteResultEvent(type, query, statement, sqlResult, bubbles, cancelable);
		}
			
	}
}