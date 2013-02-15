package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.Assert;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteErrorEvent;
	import org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite.event.SQLiteResultEvent;
	
	[Event(name="open", type="flash.events.SQLEvent")]
	[Event(name="close", type="flash.events.SQLEvent")]
	[Event(name="SQLiteError", type="org.springextensions.actionscript.samples.organizer.sqlite.event.SQLiteErrorEvent")]
	[Event(name="SQLiteResult", type="org.springextensions.actionscript.samples.organizer.sqlite.event.SQLiteResultEvent")]
	public class SQLiteDatabase extends EventDispatcher implements ISQLiteDatabase
	{
		private var _connection:SQLConnection;
		private var _statements:Dictionary;
		
		public function SQLiteDatabase(dataSource:IDataSource, target:IEventDispatcher=null)
		{
			super(target);
			_statements = new Dictionary();
			_dataSource = dataSource;
		}
		
		private var _dataSource:IDataSource;
		public function get dataSource():IDataSource
		{
			return _dataSource;
		}
		
		public function set dataSource(value:IDataSource):void
		{
			if (value !== _dataSource)
			{
				_dataSource = value;
			}
		}
		
		public function get connection():SQLConnection
		{
			return _connection;
		}
		
		public function open(encryptionKey:ByteArray=null):void
		{
			Assert.notNull(_dataSource,"The dataSource property must not be null in order to open a connection");
			close();
			_connection = new SQLConnection();
			_connection.addEventListener(SQLEvent.OPEN, redispatch);
			_connection.addEventListener(SQLEvent.CLOSE, redispatch);
			_connection.addEventListener(SQLErrorEvent.ERROR, redispatch);
			_connection.openAsync(_dataSource.file,SQLMode.UPDATE,null,false,1024,encryptionKey);
		}
		
		public function close():void
		{
			if ((_connection) && (_connection.connected))
			{
				_connection.close();
				_connection.removeEventListener(SQLEvent.OPEN, redispatch);
				_connection.removeEventListener(SQLEvent.CLOSE, redispatch);
				_connection.removeEventListener(SQLErrorEvent.ERROR, redispatch);
			}
		}
		
		public function executeQuery(query:Query, rowMapper:IRowMapper=null, responder:Responder=null):void
		{
			if ((_connection) && (_connection.connected))
			{
				var statement:SQLStatement = new SQLStatement();
				statement.sqlConnection = _connection;
				statement.text = query.sql;
				var paramName:String = "";
				for(var name:String in query.parameters){
					paramName = (query.parameterPrefix == ParameterPrefix.QUESTION_MARK) ? name : query.parameterPrefix.name + name;
					statement.parameters[paramName] = query.parameters[name];
				}
				if ((rowMapper != null) && (rowMapper.propertyMap == null)){
					statement.itemClass = rowMapper.mappedClass;
				}
				statement.addEventListener(SQLEvent.RESULT, onQueryResult);
				statement.addEventListener(SQLErrorEvent.ERROR, onQueryError);
				_statements[statement] = [query,rowMapper];
				statement.execute(-1,responder);
			}
		}
		
		public function executeQueries(queries:Vector.<Query>, rowMappers:Vector.<IRowMapper>=null, responder:Responder=null):void
		{
			if (rowMappers != null){
				Assert.state((queries.length==rowMappers.length),"queries and rowMappers arguments must be of equal length");
			}
			for(var i:int=0; i < queries.length; i++){
				executeQuery(queries[i],((rowMappers)?rowMappers[i]:null),responder);
			}
		}

		public function executeQueryBatch(queries:Vector.<Query>, rowMappers:Vector.<IRowMapper>=null, responder:Responder=null):void
		{
			throw new Error("NOT IMPLEMENTED YET!");
		}
		
		protected function redispatch(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function onQueryResult(event:SQLEvent):void {
			var statement:SQLStatement = (event.target as SQLStatement);
			var arr:Array  = _statements[statement] as Array;
			var query:Query = arr[0] as Query;
			var rowMapper:IRowMapper = arr[1] as IRowMapper;
			removeStatement(statement);
			var result:SQLResult;
			if (rowMapper != null){
				result = rowMapper.map(statement.getResult());
			} else {
				result = statement.getResult();
			}
			dispatchEvent(new SQLiteResultEvent(SQLiteResultEvent.SQLITE_RESULT, query, statement, result));
		}

		protected function onQueryError(event:SQLErrorEvent):void {
			var statement:SQLStatement = (event.target as SQLStatement);
			var arr:Array  = _statements[statement] as Array;
			removeStatement(statement);
			dispatchEvent(new SQLiteErrorEvent(SQLiteErrorEvent.SQLITE_ERROR, event, arr[0] as Query, statement));
		}
		
		protected function removeStatement(statement:SQLStatement):void {
			if (statement != null)
			{
				statement.removeEventListener(SQLEvent.RESULT, onQueryResult);
				statement.removeEventListener(SQLErrorEvent.ERROR, onQueryError);
				delete _statements[statement];
			}
		}

	}
}