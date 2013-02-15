package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import flash.data.SQLResult;
	
	import org.as3commons.lang.Assert;

	public class SimpleRowMapper implements IRowMapper
	{
		public function SimpleRowMapper(mappedClass:Class,propertyMap:Object=null)
		{
			Assert.notNull(mappedClass,"The mappedClass argument must not be null");
			super();
			this.mappedClass = mappedClass;
			this.propertyMap = propertyMap;
		}
		
		private var _mappedClass:Class;
		public function get mappedClass():Class
		{
			return _mappedClass;
		}
		
		public function set mappedClass(value:Class):void
		{
			Assert.notNull(value,"The mappedClass property must not be null");
			_mappedClass = value;
		}

		private var _propertyMap:Object;
		public function get propertyMap():Object
		{
			return _propertyMap;
		}
		public function set propertyMap(value:Object):void
		{
			_propertyMap = value;
		}
		
		public function map(sqlResult:SQLResult):SQLResult
		{
			Assert.notNull(mappedClass,"The mappedClass property must not be null");
			if ((sqlResult.data != null) && (propertyMap != null))
			{
				var len:uint = sqlResult.data.length;
				for(var i:int=0; i < len;i++)
				{
					sqlResult.data[i] = mapRow(sqlResult.data[i]);
				}
			}
			return sqlResult;
		}
		
		protected function mapRow(row:Object):Object
		{
			var result:Object = new _mappedClass();
			var name:String;
			if (_propertyMap == null)
			{
				for(name in row)
				{
					result[name] = row[name];
				}
			}
			else
			{
				for(name in _propertyMap)
				{
					result[name] = row[String(_propertyMap[name])];
				}
			}
			return result;
		}
		
	}
}