package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import flash.filesystem.File;
	
	import org.as3commons.lang.Assert;

	public class DataSource implements IDataSource
	{
		public function DataSource(databasePath:String)
		{
			Assert.hasText(databasePath,"The databasePath argument must not be null or empty");
			_databasePath = databasePath;
			_file = File.applicationDirectory.resolvePath(_databasePath);
		}
		
		private var _databasePath:String;
		public function get databasePath():String
		{
			return _databasePath;
		}
		
		private var _file:File;
		public function get file():File
		{
			return _file;
		}
		
	}
}