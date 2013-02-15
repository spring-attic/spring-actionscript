package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import flash.filesystem.File;

	public interface IDataSource
	{
		function get databasePath():String;
		function get file():File;
	}
}