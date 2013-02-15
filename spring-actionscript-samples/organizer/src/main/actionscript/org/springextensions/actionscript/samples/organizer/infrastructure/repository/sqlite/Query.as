package org.springextensions.actionscript.samples.organizer.infrastructure.repository.sqlite
{
	import mx.utils.UIDUtil;
	
	import org.as3commons.lang.Assert;

	public class Query
	{
		public function Query()
		{
			super();
			_id = UIDUtil.createUID();
		}

		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			_id = value;
		}

		private var _sql:String;
		public function get sql():String
		{
			return _sql;
		}
		public function set sql(value:String):void
		{
			Assert.notNull(value,"The sql property must not be null");
			_sql = value;
		}
		
		
		private var _parameters:Object = {};
		public function get parameters():Object
		{
			return _parameters;
		}

		public function set parameters(value:Object):void
		{
			Assert.notNull(value,"The parameters property must not be null");
			_parameters = value;
		}
		
		private var _parameterPrefix:ParameterPrefix = ParameterPrefix.COLON;
		public function get parameterPrefix():ParameterPrefix
		{
			return _parameterPrefix;
		}
		public function set parameterPrefix(value:ParameterPrefix):void
		{
			Assert.notNull(value,"The parameterPrefix property must not be null");
			_parameterPrefix = value;
		}

	}
}