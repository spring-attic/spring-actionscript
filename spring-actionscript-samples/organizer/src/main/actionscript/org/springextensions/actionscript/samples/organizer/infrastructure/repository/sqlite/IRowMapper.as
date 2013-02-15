package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import flash.data.SQLResult;

	public interface IRowMapper
	{
		function get mappedClass():Class;
		function set mappedClass(value:Class):void;
		
		function get propertyMap():Object;
		function set propertyMap(value:Object):void;
		
		function map(sqlResult:SQLResult):SQLResult;
	}
}