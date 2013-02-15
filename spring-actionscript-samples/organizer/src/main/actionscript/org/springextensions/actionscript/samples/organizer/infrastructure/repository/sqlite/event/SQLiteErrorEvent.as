package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event {
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.Query;

	public class SQLiteErrorEvent extends SQLiteResultEvent {
		public static const SQLITE_ERROR:String="SQLiteError";

		private var _errorEvent:SQLErrorEvent;

		public function get errorEvent():SQLErrorEvent {
			return _errorEvent;
		}

		public function SQLiteErrorEvent(type:String, errorEvent:SQLErrorEvent, query:Query, statement:SQLStatement, sqlResult:SQLResult=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, query, statement, sqlResult, bubbles, cancelable);
			_errorEvent=errorEvent;
		}

		override public function clone():Event {
			return new SQLiteErrorEvent(type, errorEvent, query, statement, sqlResult, bubbles, cancelable);
		}

	}
}
