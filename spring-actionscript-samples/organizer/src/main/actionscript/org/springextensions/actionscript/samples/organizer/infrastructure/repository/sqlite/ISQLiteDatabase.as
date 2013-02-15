package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import flash.data.SQLConnection;
	import flash.events.IEventDispatcher;
	import flash.net.Responder;
	import flash.utils.ByteArray;
	
	[Event(name="error", type="flash.events.SQLErrorEvent")]
	[Event(name="result", type="flash.events.SQLEvent")]
	public interface ISQLiteDatabase extends IEventDispatcher
	{
		function get dataSource():IDataSource;
		function set dataSource(value:IDataSource):void;
		
		function get connection():SQLConnection;
		
		function open(encryptionKey:ByteArray=null):void;
		function close():void;
		
		function executeQuery(query:Query, rowMapper:IRowMapper=null, responder:Responder=null):void;
		function executeQueries(queries:Vector.<Query>, rowMappers:Vector.<IRowMapper>=null, responder:Responder=null):void;
		function executeQueryBatch(queries:Vector.<Query>, rowMappers:Vector.<IRowMapper>=null, responder:Responder=null):void;
	}
}